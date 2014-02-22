module Vagrant
	module Blockwart
		class Provisioner < Vagrant.plugin("2", :provisioner)

			def initialize(machine, config)
				super
				@logger = Log4r::Logger.new("vagrant::provisioners::blockwart")
				@logger.debug("initialize")
			end

			def configure(root_config)
				@logger.debug("configure")
			end

			def provision
				@logger.debug("provision")
			end

			def cleanup
				@logger.debug("cleanup")
			end
		end
	end
end