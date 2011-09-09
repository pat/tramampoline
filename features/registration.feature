Feature: Registration
  In order to register for Trampoline
  As a person
  I want to register for a spot on the website

  Background:
    Given an event open for registration

  Scenario: Registering as a normal attendee
    When  I go to the registration page
      And I fill in "Name" with "Steve Hopkins"
      And I fill in "Email Address" with "steve@thesquigglyline.com"
      And I press "Continue"
    Then  I should see "We're just sending you off to PayPal"
    When  PayPal redirects me back after a successful payment for "Steve Hopkins"
    Then  I should see "Thanks for registering"
      But "steve@thesquigglyline.com" should have no emails
    When  PayPal confirms the payment for "Steve Hopkins"
    Then  "steve@thesquigglyline.com" should have 1 email

  Scenario: Registering as an invited attendee
    Given a registered attendee "Steve Hopkins"
    When  I go to the registration page with the invite code from "Steve Hopkins"
    Then  I should not see "Invitation Email Address"
    When  I fill in "Name" with "Aida Lee"
      And I fill in "Email Address" with "aida@aidalee.com"
      And I press "Register"
    Then  I should see "Thanks for registering"
      And "aida@aidalee.com" should have 1 email

  Scenario: Registering via an invite
    Given an invite "Sponsors Pass" for 2 people
    When  I go to the registration page with the invite code for "Sponsors Pass"
      And I fill in "Name" with "Col Duthie"
      And I fill in "Email Address" with "col@ergo.com"
      And I press "Register"
    Then  I should see "Thanks for registering"
      And "col@ergo.com" should have 1 email
    When  I go to the registration page with the invite code for "Sponsors Pass"
      And I fill in "Name" with "Derek Winter"
      And I fill in "Email Address" with "derek@ergo.com"
      And I press "Register"
      And "derek@ergo.com" should have 1 email
    Then  I should see "Thanks for registering"
    When  I go to the registration page with the invite code for "Sponsors Pass"
    Then  I should see "This invitation has already been registered"

  Scenario: Registering in the second round
    Given the event's first round has passed
    When  I go to the registration page
    Then  I should not see "Invitation Email Address"
    When  I fill in "Name" with "Steve Hopkins"
      And I fill in "Email Address" with "steve@thesquigglyline.com"
      And I press "Register"
    Then  I should see "Thanks for registering"
      And "steve@thesquigglyline.com" should have 1 email
