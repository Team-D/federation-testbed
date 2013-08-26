Given(/^an existing webfinger document$/) do
  url = 'https://diaspora-fr.org//webfinger?q=acct:' + @diaspora_user
  @webfinger = Nokogiri::XML(open(url))
end

Then(/^I make a hcard\-request$/) do
  @response = RestClient.get @webfinger.xpath('//xmlns:Link')[0].attr('href')
  @response.code == 200
end

Then(/^the document should contain User profile$/) do
  response = RestClient.get @webfinger.xpath('//xmlns:Link')[0].attr('href')
  response.to_s.index("User profile") > 0
end


Then(/^I should receive a valid hcard document$/) do
  pending # express the regexp above with the code you wish you had
end

