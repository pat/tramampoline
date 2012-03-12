Feature: Multiple events
  In order to support multiple events
  As a person
  I want to register for specific events

  Background:
    Given an event in Melbourne that is on sale
      And an event in Sydney that is on sale

  Scenario: Registering as a normal attendee
    When  I go to the home page
      And I register for the Melbourne event
      And PayPal confirms the payment from "Steve Hopkins" for the Melbourne event
    Then  I should have an email for the Melbourne event

    When  I go to the home page
      And I register for the Sydney event
      And PayPal confirms the payment from "Steve Hopkins" for the Sydney event
    Then  I should have an email for the Sydney event
