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
  
