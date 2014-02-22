module VagrantPlugins
  module Blockwart
    class Config < Vagrant.plugin("2", :config)
    	attr_accessor :machine_uuid

    	def initialize
    		@machine_uuid = UNSET_VALUE
    	end
	end
end