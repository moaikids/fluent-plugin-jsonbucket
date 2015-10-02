require "yajl"

module Fluent
    class JsonbucketOutput < Fluent::Output
        Fluent::Plugin.register_output('jsonbucket', self)
        config_param :output_tag, :string, :default => nil
        config_param :json_key, :string, :default => 'json'

        def configure(conf)
            super
            unless config.has_key?('output_tag')
                raise Fluent::ConfigError, "you must set 'output_tag'"
            end
        end

        def emit(tag, es, chain)
            es.each {|time,record|
                chain.next
                bucket = {@json_key => Yajl.dump(record)}
                Fluent::Engine.emit(@output_tag, time, bucket)
            }
        end 
    end
end
