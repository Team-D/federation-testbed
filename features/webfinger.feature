Feature: Webfinger request
  As a user of diaspora-federation
  I should be able to send a webfinger request to a diaspora pod
  And receive back valid information about a user account
  Background:
   Given an existing user account diaspora_user	

  Scenario: Existing user account
    Then I make a webfinger-request to an existing diaspora pod with url
    Then I should receive a valid webfinger document

  Scenario: Existing a webfinger document
   Given an existing webfinger document
   Then I make a hcard-request
   Then I should receive a valid hcard document