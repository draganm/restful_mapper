Feature: post request

  Scenario: simple get request with a body and no other parameters that returns 200
    Given following service definition
    """    
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      post :simple_endpoint do
        path "/simple"

        body_parameter :body
        
        responses 201 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint body: {'p1' => 'v1'}"
    And the endpoint should receive request
    """
    POST /simple HTTP/1.1
    """
    And request body should be
    """
    {"p1":"v1"}
    """
    

 