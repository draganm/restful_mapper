Feature: raising exception when return structure is an instance of exception


  Scenario: raising exception when structure is exception
    Given following service definition
    """
    class ExceptionResponse < Exception
      include StructureMapper::Hash
      attribute a: String      
    end    
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      put :simple_endpoint do
        path "/simple"

        body_parameter :body
        
        responses 201 => ExceptionResponse
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint body: {'p1' => 'v1'}" expecting exception    
    And exception should be raised
    """
    ExceptionResponse.new
    """
    