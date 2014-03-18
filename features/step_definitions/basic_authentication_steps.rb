Then(/^the endpoint should receive request header "(.*?)" with value "(.*?)"$/) do |name, value|
  headers=@response_headers_channel.receive.first
  # raise headers.inspect
  headers.should have_key name
  headers[name].should == value
end