Feature: Webfinger request
  As a user of diaspora-federation
  I should be able to send a webfinger request to a diaspora pod
  And receive back valid information about a user account


  Scenario: Existing user account
  Given an existing user account with id "ID"
  When I make a webfinger-request to an existing diaspora pod with url "URL"
  Then I should receive a valid webfinger document