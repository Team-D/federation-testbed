Feature: Hcard request
	As a user of diaspora-federation
  I should be able to send a hcard request to a diaspora pod
  And receive back valid information about a user account

  Background:
  	Given an existing user account with id "ID"

  Scenario: Requesting existing user account
		When I make a hcard-request to an existing diaspora_pod
		Then the status code should be success
		And the document type should be HTML
