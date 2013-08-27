Feature: Hcard request
  As a user of diaspora-federation
  I should be able to send a hcard request to a diaspora pod
  And receive back valid information about a user account

  Background:
  	Given an existing server 

  Scenario: Existing hcard document
		Given an existing user account diaspora_user	
		Given an existing webfinger document
    When I make a hcard-request
    Then the status code should be success
    And the document should contain User profile	
    And I should receive a valid hcard document	

  Scenario: hcard request with not existing user
  	When I make a hcard request with not existing user
  	Then the status code should be not found
