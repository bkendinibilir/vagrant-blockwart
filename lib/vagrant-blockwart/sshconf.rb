require "ssh-config"

module Vagrant
	module Blockwart
		module SshConf

			def initialize()
				touch_sshconfig()
				@ssh_config = ConfigFile.new
			end

			def update(ssh_info)
				@ssh_config.set(config.node_uuid, 'HostName', ssh_info[:host])
				@ssh_config.set(config.node_uuid, 'Port', ssh_info[:port])
				@ssh_config.set(config.node_uuid, 'User', ssh_info[:username])
				
				ssh_keys = ssh_info[:private_key_path]
				ssh_keys.each do |ssh_key|
					@ssh_config.set(config.node_uuid, 'IdentityFile', ssh_key)
				end

				if ssh_info[:forward_agent]
					@ssh_config.set(config.node_uuid, 'ForwardAgent', 'yes')
				end

				if ssh_info[:forward_x11]
					@ssh_config.set(config.node_uuid, 'ForwardX11', 'yes')
				end

				if ssh_info[:proxy_command]
					@ssh_config.set(config.node_uuid, 'ProxyCommand', ssh_info[:proxy_command])
				end

				@ssh_config.set(config.node_uuid, 'UserKnownHostsFile', '/dev/null')
				@ssh_config.set(config.node_uuid, 'StrictHostKeyChecking', 'no')
				@ssh_config.set(config.node_uuid, 'PasswordAuthentication', 'no')
				@ssh_config.set(config.node_uuid, 'IdentitiesOnly', 'yes')
				@ssh_config.set(config.node_uuid, 'LogLevel', 'FATAL')
				
				@ssh_config.save()
			end

			def remove_hosts(hosts)
				bw = Blockwart::Manage.new
				hosts = bw.node_hosts()
				if hosts
					touch_sshconfig()
					@ssh_config = ConfigFile.new
					hosts.each do |host|
						@ssh_config.rm(host)
					end
					@ssh_config.save()
				end
			end

			def touch_sshconfig()
				unless File.directory?(ENV['HOME'] + "/.ssh")
  					FileUtils.mkdir_p(ENV['HOME'] + "/.ssh")
				end
				FileUtils.touch(ENV['HOME'] + "/.ssh/config")
			end
