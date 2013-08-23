When(/^I make a hcard\-request to an existing diaspora_pod$/) do
  RestClient.get 'https://joindiaspora.com/hcard/users/cb84797d2a2ca64d'
end

Then(/^the document type should be HTML$/) do
	@response.to_s.index("text/html") < 0
end
