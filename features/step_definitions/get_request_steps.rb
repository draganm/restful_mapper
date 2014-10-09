Given(/^following service definition$/) do |code|
  pretext="require 'restful_mapper'\n"
  @module.module_eval "%s%s" % [pretext,code], "cucuber", 1
end

Given(/^the service endpoint at port (\d+) responds with following http response:$/) do |port, response|
  server=TCPServer.new port.to_i
  go! do
    connection=server.accept
    connection.readline
    connection.write(response)
    connection.close
    server.close
  end
end


When(/^I call service "(.*?)"$/) do |code|
  @result=@module.module_eval(code, "input",1)
end

Then(/^the result should be equal to:$/) do |expected|
  @result.should == @module.module_eval(expected)
end

Given(/^the service endpoint at port (\d+) is running$/) do |port|
  server=TCPServer.new port.to_i
  response = "HTTP/1.1 201 OK\n\n"
  channel=channel! String,1
  response_channel=channel! String, 1
  headers_channel=channel! Hash, 1
  @server_channel=channel
  @response_body_channel=response_channel
  @response_headers_channel=headers_channel

  go! do
    connection=server.accept
    channel << connection.readline()
    content_length=nil
    headers={}
    while (line=connection.readline()) != "\r\n"
      # puts "line: %s" % line
      name, value=line.split(":",2)
      if name == "Content-Length"
        content_length=value.to_i
        # puts "content length: %s" % content_length
      end
      headers[name]=value.gsub(/\n|\r/,'').strip
    end

    headers_channel << headers

    # puts "content length: %d" % content_length

    data=(content_length ? connection.read(content_length) : "")

    # puts "data: %s" % data

    response_channel << data

    connection.write(response)
    connection.close
    server.close

  end
end

Then(/^the endpoint should receive request$/) do |request|
  @server_channel.receive.first.gsub(/\r|\n/,'').should == request.gsub(/\r|\n/,'')
end

When(/^request body should be$/) do |expected|
  @response_body_channel.receive.first.should == expected
end

