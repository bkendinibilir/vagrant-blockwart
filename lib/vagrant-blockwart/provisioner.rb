require "fileutils"
require "ssh-config"

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
				update_sshconfig()
			end

			def cleanup
				@logger.warn("cleanup()")
				reset_sshconfig()
			end


			def get_nodes()
				nodes = `bw nodes`
				return nodes.split('\n')
			end

			def touch_sshconfig()
				unless File.directory?(ENV['HOME'] + "/.ssh")
  					FileUtils.mkdir_p(ENV['HOME'] + "/.ssh")
				end
				FileUtils.touch(ENV['HOME'] + "/.ssh/config")
			end

			def update_sshconfig()
				ssh_info = @machine.ssh_info

				touch_sshconfig()
				ssh_config = ConfigFile.new
				ssh_config.set(config.node_uuid, 'HostName', ssh_info[:host])
				ssh_config.set(config.node_uuid, 'Port', ssh_info[:port])
				ssh_config.set(config.node_uuid, 'User', ssh_info[:username])
				
				ssh_keys = ssh_info[:private_key_path]
				ssh_keys.each do |ssh_key|
					ssh_config.set(config.node_uuid, 'IdentityFile', ssh_key)
				end

				if ssh_info[:forward_agent]
					ssh_config.set(config.node_uuid, 'ForwardAgent', 'yes')
				end

				if ssh_info[:forward_x11]
					ssh_config.set(config.node_uuid, 'ForwardX11', 'yes')
				end

				if ssh_info[:proxy_command]
					ssh_config.set(config.node_uuid, 'ProxyCommand', ssh_info[:proxy_command])
				end

				ssh_config.set(config.node_uuid, 'UserKnownHostsFile', '/dev/null')
				ssh_config.set(config.node_uuid, 'StrictHostKeyChecking', 'no')
				ssh_config.set(config.node_uuid, 'PasswordAuthentication', 'no')
				ssh_config.set(config.node_uuid, 'IdentitiesOnly', 'yes')
				ssh_config.set(config.node_uuid, 'LogLevel', 'FATAL')
				
				ssh_config.save()
			end

			def reset_sshconfig()
				nodes = get_nodes()
				if nodes
					touch_sshconfig()
					ssh_config = ConfigFile.new
					nodes.each do |node_uuid|
						ssh_config.rm(node_uuid)
					end
					ssh_config.save()
				end
			end

		end
	end
end