require "fileutils"
require "ssh-config"

module VagrantPlugins
	module Blockwart
		class Provisioner < Vagrant.plugin("2", :provisioner)

			def initialize(machine, config)
				super(machine, config)
				@logger = Log4r::Logger.new("vagrant::provisioners::blockwart")
				@logger.warn("initialize()")
				config.machine_uuid = machine.id
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


			def touch_sshconfig()
				unless File.directory?(ENV['HOME'] + "/.ssh")
  					FileUtils.mkdir_p(ENV['HOME'] + "/.ssh")
				end
				FileUtils.touch(ENV['HOME'] + "/.ssh/config")
			end

			def update_sshconfig()
				ssh_info = @machine.ssh_info

				touch_sshconfig()
				config = ConfigFile.new
				config.set(config.machine_uuid, 'HostName', ssh_info[:host])
				config.set(config.machine_uuid, 'Port', ssh_info[:port])
				config.set(config.machine_uuid, 'User', ssh_info[:username])
				
				ssh_keys = ssh_info[:private_key_path]
				ssh_keys.each do |ssh_key|
					config.set(config.machine_uuid, 'IdentityFile', ssh_key)
				end

				if ssh_info[:forward_agent]
					config.set(config.machine_uuid, 'ForwardAgent', 'yes')
				end

				if ssh_info[:forward_x11]
					config.set(config.machine_uuid, 'ForwardX11', 'yes')
				end

				if ssh_info[:proxy_command]
					config.set(config.machine_uuid, 'ProxyCommand', ssh_info[:proxy_command])
				end

				config.set(config.machine_uuid, 'UserKnownHostsFile', '/dev/null')
				config.set(config.machine_uuid, 'StrictHostKeyChecking', 'no')
				config.set(config.machine_uuid, 'PasswordAuthentication', 'no')
				config.set(config.machine_uuid, 'IdentitiesOnly', 'yes')
				config.set(config.machine_uuid, 'LogLevel', 'FATAL')
				
				config.save()
			end

			def reset_sshconfig()
				touch_sshconfig()
				config = ConfigFile.new
				config.rm(config.machine_uuid)
				config.machine_uuid = nil
				config.save()
			end
		end
	end
end