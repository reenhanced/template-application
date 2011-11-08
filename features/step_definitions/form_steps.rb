When /^I clear "([^\"]*)"$/ do |field|
  fill_in field, :with => ''
end

Then %{I should see the error message "$error_msg"} do |error_msg|
  within("div#flash_failure") do
    page.should have_content(error_msg)
  end
end

Then %{I should not see error messages} do
  page.should_not have_css("div#flash_failure")
end

Then %{I should see the success message "$sucess_msg"} do |success_msg|
  within("div#flash_notice") do
    page.should have_content(success_msg)
  end
end

