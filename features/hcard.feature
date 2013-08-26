Feature: Hcard request
  As a user of diaspora-federation
  I should be able to send a hcard request to a diaspora pod
  And receive back valid information about a user account

  Background:
   Given an existing user account diaspora_user	
    Given an existing webfinger document

  Scenario: Existing a webfinger document
    Then I make a hcard-request
    Then the status code should be success	
#    Then I should receive a valid hcard document
    And the document should contain User profile	


