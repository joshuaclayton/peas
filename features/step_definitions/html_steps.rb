Then /^I should be redirected to "([^\"]*)"$/ do |url|
  response.redirect?.should be_true
  response.location.should == url
end

Then /^I should see a field labeled "([^\"]*)"$/ do |label|
  assert field_labeled(label)
end
