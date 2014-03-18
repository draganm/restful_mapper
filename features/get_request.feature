Feature: get request

  Scenario: simple get request without any parameters that returns 200
    Given following service definition
    """    
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"
        
        responses 200 => {String => String}
      end

    end
    """
    And the service endpoint at port 8765 responds with following http response:
    """
    HTTP/1.1 200 OK    
    Connection: close
    Content-Type: application/json

    {"a": "b"}
    """
    When I call service "SimpleService.simple_endpoint"
    Then the result should be equal to:
    """
      {"a" => "b"}
    """

 Scenario: simple get request without any parameters that returns 302
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 responds with following http response:
    """
    HTTP/1.1 302 OK    
    Connection: close
    Content-Type: application/json

    """
    When I call service "SimpleService.simple_endpoint"
    Then the result should be equal to:
    """
      true
    """

 Scenario: simple get request with request parameters
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"

        query_parameters [:name]
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint name: 'test'"
    Then the endpoint should receive request
    """
    GET /simple?name=test HTTP/1.1

    """

Scenario: simple get request with path parameters
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple/{{name}}"
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint name: 'test'"
    Then the endpoint should receive request
    """
    GET /simple/test HTTP/1.1
    
    """

Scenario: simple get request with path and query parameters
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple/{{name}}"
        query_parameters [:name]        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint name: 'test'"
    Then the endpoint should receive request
    """
    GET /simple/test?name=test HTTP/1.1
    
    """
