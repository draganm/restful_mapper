# RestfulMapper

Provides DSL for describing RESTFul services using JSON transport.

## Installation

Add this line to your application's Gemfile:

    gem 'restful_mapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restful_mapper

## Usage

RestfulMapper provides a way to integrate calls to RESTful services into your code without much fuss. It gives you control over the format of the outgoing messages, request parameters and request paths. It also maps response codes to Ruby objects using structure_mapper gem.

The best way to learn about the DSL is to try combining features demonstrated by examples:

### Get request
In order to invoke a simple get request without any parameters, one can use following mapping:

    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"        
        responses 200 => true, 0 => false
      end
    end

Invoking SimpleService.simple_endpoint will return 'true' value if the response code of the service http://localhost:8765/simple is 200 and false for any other response code.

### Get request with request parameters
In order to add parameter to a simple service definition, one has to add 'query_parameters' array:

    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"
        query_parameters [:name]      
        responses 200 => true, 0=>false
      end

    end

When invoked with 'SimpleService.simple_endpoint name: "test"' RestfulMapper will perform a GET request to http://localhost:8765/simple?name=test.

### Get request with path parameters
Path of the service can be parametrized using Mustache syntax:

    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple/{{name}}"        
        responses 200 => true, 0=>false
      end
    end

Calling 'SimpleService.simple_endpoint name: "test"' will perform GET request to http://localhost:8765/simple/test.


### Post request with JSON body
In order to use parameter as JSON body, one has to declare it using 'body_parameter' directive

    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      post :simple_endpoint do
        path "/simple/{{name}}"        
        body_parameter :body
        responses 200 => true, 0=>false
      end
    end

Calling 'SimpleService.simple_endpoint name: "test", body: {'a' => 'b'}' will perform POST request to http://localhost:8765/simple/test with body '{"a":"b"}'.

### Mapping JSON response to Ruby objects
Thanks to structure_mapper, one can easily transform JSON returned by the service into Ruby object. First we
need definition of the object:

    class SimpleResponse
      include StructureMapper::Hash

      attribute a: String
    end

And then we need to use the defined object as response mapping:

    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"        
        responses 200 => SimpleResponse, 0 => false
      end
    end

If http://localhost:8765/simple returns 200 and a JSON body '{"a":"b"}' then calling 'SimpleService.simple_endpoint'
will return instance of SimpleResponse with property 'a' set to 'b'.

### Basic Authentication
TBD

### Raising Exception
TBD

## Contributing

1. Fork it ( http://github.com/<my-github-username>/restful_mapper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
