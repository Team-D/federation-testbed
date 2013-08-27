Given(/^an existing server$/) do
  @server = "joindiaspora.com"
end

When(/^I send a host meta request to an existing diaspora pod$/) do
  @response = RestClient.get @server + "/.well-known/host-meta"
end

Then(/^it should contain a link to the webfinger document$/) do
  @webfinger_url = @response.to_s.rpartition(/(https?):((\/\/)|(\\\\))+[\w\d:\#\@\%\/;$()~_?\+-=\\\.&]*/)[-2] + "mokus@joindiaspora.com"
  RestClient.get @webfinger_url
end




