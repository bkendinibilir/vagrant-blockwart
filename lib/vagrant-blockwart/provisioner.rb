require "fileutils"
require_relative "bwmanage"
require_relative "sshconf"

module VagrantPlugins
	module Blockwart
		class Provisioner < Vagrant.plugin("2", :provisioner)

			def initialize(machine, config)
				super(machine, config)
				@logger = Log4r::Logger.new("vagrant::provisioners::blockwart")
				@logger.warn("initialize()")
				unless config.node_uuid
					config.node_uuid = machine.id
				end
				@logger.warn(config.node_uuid)
			end

			def configure(root_config)
				@logger.warn("configure()")
			end

			def provision
				@logger.warn("provision()")
				ssh = SshConf.new
				ssh.update(@machine.ssh_info)
				bw = BwManage.new
				bw.update_nodes({config.node_name => config.node_uuid})
			end

			def cleanup
				@logger.warn("cleanup()")
				ssh = SshConf.new
				bw = BwManage.new
				ssh.remove_hosts(bw.node_hosts)
				bw.update_nodes({})
			end

		end
	end
end