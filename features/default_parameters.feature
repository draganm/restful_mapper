Feature: default parameters

Scenario: simple get request with default request parameters
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      default_parameters name: 'test'

      get :simple_endpoint do
        path "/simple"

        query_parameters [:name]
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint"
    Then the endpoint should receive request
    """
    GET /simple?name=test HTTP/1.1

    """



Scenario: overriding default parameters with method parameters
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      default_parameters name: 'test'

      get :simple_endpoint do
        path "/simple"

        query_parameters [:name]
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint name: 'test2'"
    Then the endpoint should receive request
    """
    GET /simple?name=test2 HTTP/1.1

    """
