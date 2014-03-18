Feature: basic authentication

Scenario: basic authentication of a GET request
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      default_parameters name: 'test'

      basic_authentication 'username', 'password'

      get :simple_endpoint do
        path "/simple"

        query_parameters [:name]
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint"    
    And the endpoint should receive request header "Authorization" with value "Basic dXNlcm5hbWU6cGFzc3dvcmQ="

Scenario: basic authentication using parameters for username and password
    Given following service definition
    """
    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      default_parameters name: 'test'

      basic_authentication :user, :password

      get :simple_endpoint do
        path "/simple"

        query_parameters [:name]
        
        responses 302 => true
      end

    end
    """
    And the service endpoint at port 8765 is running
    When I call service "SimpleService.simple_endpoint user: 'username', password: 'password' "    
    And the endpoint should receive request header "Authorization" with value "Basic dXNlcm5hbWU6cGFzc3dvcmQ="
