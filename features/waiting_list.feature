Feature: Waiting List
  In order to possibly register for Trampoline
  As a person
  I want to add my name to the waiting list when the event is sold out
  
  Background:
    Given a completely sold out event
  
  Scenario: Adding Details to the Waiting List
    When  I go to the registration page
      And I follow "join the waiting list"
      And I fill in "Name" with "Melina Chan"
      And I fill in "Email Address" with "melina@trampolineday.com"
      And I press "Join the Queue"
    Then  I should see "You are 1st in the queue"
  
  Scenario: Claiming Attendance Position
    Given a registered attendee "Peter Spence"
      And "bei@yin.com" is waiting
    When  "Peter Spence" cancels his attendance
    Then  "bei@yin.com" should receive an email
    When  I open the email
      And I follow "this link" in the email
      And I fill in "Name" with "Bei Yin"
      And I fill in "Email Address" with "bei@yin.com"
      And I press "Register"
    Then  I should see "Thanks for registering"
    When  I open the email
      And I follow "this link" in the email
    Then  I should see "This invitation has already been registered"
  
  Scenario: Re-offering Attendance Positions
    Given a registered attendee "Peter Spence"
      And "bei@yin.com" is waiting
      And "steve@mckinnon.com" is waiting
    When  "Peter Spence" cancelled his attendance 2 days ago
    Then  "bei@yin.com" should receive an email
    When  I open the email
      And I follow "this link" in the email
    Then  I should see "This invitation is no longer valid."
    When  the waiting list is progressed
    Then  "steve@mckinnon.com" should receive an email
    When  I open the email
      And I follow "this link" in the email
      And I fill in "Name" with "Steve McKinnon"
      And I fill in "Email Address" with "steve@mckinnon.com"
      And I press "Register"
    Then  I should see "Thanks for registering"
  
