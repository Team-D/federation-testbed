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
  @webfinger.xpath('//xmlns:Link').each do |hcard|
    
  end

  pending # express the regexp above with the code you wish you had
end

Then(/^I should receive a valid hcard document$/) do
  pending # express the regexp above with the code you wish you had
end
