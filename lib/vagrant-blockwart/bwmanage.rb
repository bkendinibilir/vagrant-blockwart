module VagrantPlugins
	module Blockwart
		class BwManage

			def initialize()
			end

			def nodes()
				nodes = `bw nodes`
				return nodes.split("\n")
			end

			def node_hosts()
				nodes = `bw nodes --hostname`
				return nodes.split("\n")
			end

			def update_nodes(nodes)
				content = "nodes = {\n"
				nodes.each do |name, uuid|
					content += "	'#{name}': {\n"
					content += "		'hostname': \"#{uuid}\",\n"
					content += "	},\n"
				end
				content += "}\n"

				File.open("nodes.py", "w+") do |f|
					f.write(content)
				end
			end

			def clean_nodes()
				update_nodes({})
			end

			def apply(node)
				node = node.gsub(/[^a-zA-Z0-9\-\_\.]/,'')
				return system("bw apply #{node}")
			end

		end
	end
end