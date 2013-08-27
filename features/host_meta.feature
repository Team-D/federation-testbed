Feature: Host meta request
	As a user of diaspora-federation
  I should be able to send a HostMeta request to a diaspora pod
  And receive back valid information about hte meta host

  Scenario: sending host meta request to existing server
  	Given an existing server
  	When I send a host meta request to an existing diaspora pod  
  	Then the status code should be success
  	And the document type should be XML
  	And it should contain a link to the webfinger document

