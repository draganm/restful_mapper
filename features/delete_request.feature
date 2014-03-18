Feature: delete request

  Scenario: simple get request with a body and no other parameters that returns 200
    Given following service definition
    """    
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      delete :simple_endpoint do
        path "/simple"
        
        responses 201 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint"
    And the endpoint should receive request
    """
    DELETE /simple HTTP/1.1
    """
    

 