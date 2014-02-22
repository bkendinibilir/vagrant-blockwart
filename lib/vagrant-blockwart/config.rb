module VagrantPlugins
	module Blockwart
    	class Config < Vagrant.plugin("2", :config)
    		attr_accessor :node_name
    		attr_accessor :node_uuid

    		def initialize
    			@node_name = UNSET_VALUE
    			@node_uuid = UNSET_VALUE
    		end

    		def finalize!
    			@node_name = "node" if @node_name == UNSET_VALUE
    			@node_uuid = nil if @node_uuid == UNSET_VALUE
    		end
    	end
	end
end