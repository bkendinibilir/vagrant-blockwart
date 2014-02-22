require "fileutils"
require_relative "bwmanage"
require_relative "sshconf"

module VagrantPlugins
	module Blockwart
		class Provisioner < Vagrant.plugin("2", :provisioner)

			def initialize(machine, config)
				super(machine, config)
				@logger = Log4r::Logger.new("vagrant::provisioners::blockwart")

				unless config.node_uuid
					config.node_uuid = machine.id
				end
			end

			def configure(root_config)
			end

			def provision
				ssh = SshConf.new
				ssh.update(config.node_uuid, @machine.ssh_info)
				bw = BwManage.new(config.repo_path)
				bw.update_nodes({config.node_name => config.node_uuid})
				bw.apply(config.node_name)
			end

			def cleanup
				bw = BwManage.new(config.repo_path)
				ssh = SshConf.new
				ssh.remove_hosts(bw.node_hosts)
				bw.clean_nodes()
			end

		end
	end
end