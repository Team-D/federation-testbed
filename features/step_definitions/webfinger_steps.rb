When(/^I make a webfinger request with not existing user$/) do
  begin
    RestClient.get 'https://'+ @server +'//webfinger?q=acct:lkasdjflasjiohsdfgj@' + @server
  rescue => e
    @invalid_request = e.to_s
  end
end

When(/^I make a webfinger request to an existing diaspora pod$/) do
  RestClient.get 'https://'+ @server +'//webfinger?q=acct:'+ @diaspora_user
end

Then(/^I should receive a valid webfinger document$/) do
  @response = RestClient.get 'https://' + @server + '//webfinger?q=acct:' + @diaspora_user
end

Then(/^the document type should be XML$/) do
  @response.to_s.index("application/xrd+xml") == 0
end

Then(/^the webfinger document contains the link to the hcard$/) do
  @response.to_s.index("hcard") > 0
end

