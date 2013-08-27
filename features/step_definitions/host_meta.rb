Given(/^an existing server$/) do
  @server = "joindiaspora.com"
end

When(/^I send a host meta request to an existing diaspora pod$/) do
  @response = RestClient.get @server + "/.well-known/host-meta"
end

Then(/^it should contain a link to the webfinger document$/) do
  pending #@response.to_s.index("template") != nil
  # ((https?):((\/\/)|(\\\\))+[\w\d:#@%\/;$()~_?\+-=\\\.&]*)
end



