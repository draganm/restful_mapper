require 'faraday'
require 'json'
require "restful_mapper/version"
require 'structure_mapper'
require 'multi_json'
require 'mustache'


class Object # http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
  def meta_def name, &blk
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
end


module RestfulMapper

  class EndpointDefinition

    def initialize base_url, method, basic_authentication
      @base_url=base_url
      @query_parameters=[]
      @method=method
      @basic_authentication=basic_authentication
    end

    def path path, options={}
      @path=path
    end

    def verbose
      @verbose=true
    end

    def responses response_mapping={}
      @response_mapping=response_mapping
    end

    def body_parameter body_parameter
      @body_parameter=body_parameter
    end


    def query_parameters parameters
      @query_parameters=parameters.dup
    end


    def filter_parameters hash
      hash.dup.delete_if do |k,v|
        not (@query_parameters.include?(k.to_sym) || @query_parameters.include?(k.to_s))
      end
    end

    def call_service params
      conn = Faraday.new(:url => @base_url) do |faraday|
        if @verbose
          faraday.response :logger
        end
        faraday.adapter Faraday.default_adapter  # make requests with Net::HTTP
      end

      if has_basic_authentication?
        conn.basic_auth(*basic_authentication_data(params))
      end

      response=conn.run_request(@method, Mustache.render(@path, params), nil, {'Content-Type' => 'application/json'}) { |request|
        request.params.update(filter_parameters(params)) if filter_parameters(params)
        if @body_parameter
          request.body=MultiJson.dump(params[@body_parameter].to_structure)
        end


      }


      status=response.status
      status_class=@response_mapping[status]
      status_class||=@response_mapping[0]
      body=response.body
      result=deserialize body, response.headers['Content-Type'], status_class
      if Exception === result
        raise result
      end
      result
    end

    def has_basic_authentication?
      @basic_authentication
    end

    def basic_authentication_data params
      @basic_authentication.map{|name| Symbol === name ? params[name] : name}
    end


    def deserialize json, content_type, mapping
      if content_type.start_with?('application/json')
        if json && !json.empty?
          mapping.from_structure(MultiJson.load(json))
        else
          if Hash == mapping || Array == mapping || mapping.is_a?(Class)
            mapping.new
          else
            mapping
          end
        end
      else
        mapping.from_content(content_type, json)
      end
    end


  end




  class Service

    def self.base_url base_url
      @base_url=base_url
    end

    attr_reader :base_url


    def self.get name, &definition
      service_method name, definition, :get
    end

    def self.post name, &definition
      service_method name, definition, :post
    end

    def self.put name, &definition
      service_method name, definition, :put
    end

    def self.delete name, &definition
      service_method name, definition, :delete
    end

    def self.default_parameters parameters
      @default_parameters=parameters
    end

    def self.basic_authentication username, password
      @basic_authentication=[username,password]
    end

    private

    def self.service_method name, definition, method
      endpoint_definition=EndpointDefinition.new @base_url, method, @basic_authentication
      endpoint_definition.instance_exec(&definition)
      self.meta_def(name.to_sym) do |params={}|
        copy=(@default_parameters || {}).merge(params)
        endpoint_definition.call_service copy
      end

    end

  end

end
