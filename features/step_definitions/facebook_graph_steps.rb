Given /^I am signed into Facebook with the following information:$/ do |table|
  user_info = table.transpose.hashes.first

  $fake_devise.stub_facebook_login_with(user_info)
end

Given /^I have the following Facebook friends:$/ do |table|
#  facebook_response = {"data" => []}
#  table.hashes.each do |row|
#    facebook_response["data"] << row
#  end
#  json = facebook_response.to_json
#  $facebook_graph['/me/friends'] = [200, { 'Content-Length' => json.size }, [json]]
end
