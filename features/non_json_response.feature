Feature: Handling Non-Json Response

@ok
  Scenario: mapping to false
  Given following service definition
    """
    class ::FalseClass
      def from_content(content_type, data)
        false
      end
    end

    class SimpleService < RestfulMapper::Service
      base_url "http://localhost:8765"

      get :simple_endpoint do
        path "/simple"

        responses 0 => false
      end

    end
    """
    And the service endpoint at port 8765 responds with following http response:
    """
    HTTP/1.1 200 OK
    Connection: close
    Content-Type: text/plain

    whatever
    """
    When I call service "SimpleService.simple_endpoint"
    Then the result should be equal to:
    """
      false
    """