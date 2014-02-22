module VagrantPlugins
	module Blockwart
    	class Config < Vagrant.plugin("2", :config)
            attr_accessor :repo_path
    		attr_accessor :node_name
    		attr_accessor :node_uuid

    		def initialize
                @repo_path = UNSET_VALUE
    			@node_name = UNSET_VALUE
    			@node_uuid = UNSET_VALUE
    		end

    		def finalize!
    			@repo_path = "blockwart/" if @repo_path == UNSET_VALUE
                @node_name = "node1" if @node_name == UNSET_VALUE
    			@node_uuid = nil if @node_uuid == UNSET_VALUE
    		end

            def validate(machine)
                errors = _detected_errors

                unless File.directory?(repo_path) and File.exist?("#{repo_path}/nodes.py") and File.exist?("#{repo_path}/groups.py")
                    errors << "Blockwart repository is missing in repo_path='#{repo_path}'.\n  Create a new one with 'bw repo create'."
                end

                { "vagrant-blockwart" => errors }
              end
    	end
	end
end