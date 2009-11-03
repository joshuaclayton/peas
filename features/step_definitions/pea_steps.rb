Given /^a pea exists for the URL "([^\"]*)"$/ do |long_url|
  Pea.create(:long_url => long_url)
end

Given /^the pea for "([^\"]*)" has the key "([^\"]*)"$/ do |long_url, key|
  Pea.find_by_long_url(long_url).update_attribute :key, key
end

Given /^a pea exists that refers to itself with key "([^\"]*)"$/ do |key|
  pea = Factory(:pea)
  pea.update_attribute :key, key
  pea.update_attribute :long_url, peapod_url(pea.key)
end

Then /^I should see a short URL for "([^\"]*)"$/ do |long_url|
  pea = Pea.find_by_long_url(long_url)
  assert_select("a[href=?]", peapod_url(pea.key))
end

When /^I visit the short URL for "([^\"]*)"$/ do |key|
  visit peapod_url(key)
end
