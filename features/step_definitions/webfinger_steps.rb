Given(/^an existing user account diaspora_user$/) do 
  @diaspora_user = 'carolina@diaspora-fr.org'
end

Then(/^I make a webfinger\-request to an existing diaspora pod with url$/) do
  RestClient.get 'https://diaspora-fr.org//webfinger?q=acct:'+ @diaspora_user
end

Then(/^I should receive a valid webfinger document$/) do
  response = RestClient.get 'https://diaspora-fr.org//webfinger?q=acct:' + @diaspora_user
  response.code == '200'
end

Given(/^an existing webfinger document$/) do
  @response = 'https://diaspora-fr.org//webfinger?q=acct:' + @diaspora_user
  @webfinger = Nokogiri::XML(open(@response))
end
Then(/^I make a hcard\-request$/) do
  hcard= @webfinger.xpath('//xmlns:Link')[0].attr('href')
  RestClient.get hcard
end

Then(/^I should receive a valid hcard document$/) do
  pending # express the regexp above with the code you wish you had

When(/^I make a webfinger\-request to an existing diaspora pod with url "(.*?)"$/) do |arg1|
  RestClient.get 'https://joindiaspora.com/webfinger?q=acct:mokus@joindiaspora.com'
end

Then(/^the document type should be XML$/) do
  @response.to_s.index("application/xrd+xml") == 0
end

Then(/^the webfinger document contains the link to the hcard$/) do
	@response.to_s.index("hcard") > 0
end



