require "vagrant"

module VagrantPlugins
	module Blockwart
		class Plugin < Vagrant.plugin("2")
  			name "vagrant-blockwart"

  			provisioner "blockwart" do
  				require_relative "provisioner"
    			Provisioner
  			end
  		end
  	end
end
