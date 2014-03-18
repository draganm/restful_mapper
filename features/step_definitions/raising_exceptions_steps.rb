When(/^exception should be raised$/) do |code|
  @exception.should == @module.module_eval(code)
end

When(/^I call service "(.*?)" expecting exception$/) do |code|
  failed=true
  begin
    @result=@module.module_eval code
    failed=false
  rescue Exception => e
    @exception=e
  end

  raise "expected to raise exception" unless failed
end