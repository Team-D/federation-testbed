Feature: Webfinger request
  As a user of diaspora-federation
  I should be able to send a webfinger request to a diaspora pod
  And receive back valid information about a user account


  Scenario: Existing user account
  Given an existing user account 'ladila'
  When I make a request to 'well-known-ladila'
  Then I should receive a valid webfinger document