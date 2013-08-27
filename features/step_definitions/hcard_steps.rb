Given(/^an existing webfinger document$/) do
  url = 'https://' + @server + '//webfinger?q=acct:' + @diaspora_user
  @webfinger = Nokogiri::XML(open(url))
end

When(/^I make a hcard request with not existing user$/) do
	begin
  	RestClient.get 'https://' + @server + '/hcard/users/23@42@notvaliduser'
  rescue => e
  	@invalid_request = e.to_s
  end
end

When(/^I make a hcard\-request$/) do
  @response = RestClient.get @webfinger.xpath('//xmlns:Link')[0].attr('href')
end

Then(/^the document should contain User profile$/) do
  response = RestClient.get @webfinger.xpath('//xmlns:Link')[0].attr('href')
  response.to_s.index("User profile") > 0
end

Then(/^I should receive a valid hcard document$/) do
  pending # express the regexp above with the code you wish you had
end

