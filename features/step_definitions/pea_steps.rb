Then /^I should see a short URL for "([^\"]*)"$/ do |long_url|
  pea = Pea.find_by_long_url(long_url)
  assert_select("a[href=?]", peapod_url(pea.key))
end
