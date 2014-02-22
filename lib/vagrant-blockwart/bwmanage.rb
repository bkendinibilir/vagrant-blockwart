module VagrantPlugins
	module Blockwart
		class BwManage

			def initialize(repo_path)
				@repo_path = repo_path
			end

			def bw_cli(params, ret_stdout=true)
				params = params.gsub(/[^a-zA-Z0-9\-\_\.\s]/,'')
				old_path = Dir.pwd
				Dir.chdir(@repo_path)
				if ret_stdout
					result = `bw #{params}`
				else
					result = system("bw #{params}")
				end
				Dir.chdir(old_path)
				return result
			end

			def nodes()
				nodes = bw_cli("nodes")
				return nodes.split("\n")
			end

			def node_hosts()
				nodes = bw_cli("nodes --hostname")
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

				File.open(@repo_path + "/nodes.py", "w+") do |f|
					f.write(content)
				end
			end

			def clean_nodes()
				update_nodes({})
			end

			def apply(node)
				node = node.gsub(/[^a-zA-Z0-9\-\_\.]/,'')
				return bw_cli("apply #{node}", ret_stdout=false)
			end

		end
	end
end