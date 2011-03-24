class Notifications < ActionMailer::Base
  helper :application
  
  default :from => 'Trampoline Team <pat@freelancing-gods.com>'
  
  def registration(attendee)
    @attendee = attendee
    
    mail :to => attendee.email, :subject => 'Trampoline Registration'
  end
  
  def invite(attendee)
    @attendee = attendee
    
    mail :to => attendee.invite_email, :subject => 'Trampoline Invitation'
  end
  
  def invite_reminder(attendee)
    @attendee = attendee

    mail :to => attendee.email, :subject => 'Trampoline Invitation Reminder'
  end
  
  def preoverview(attendee)
    @attendee = attendee
    
    mail :to => attendee.email, :subject => 'Trampoline Approaching'
  end
  
  def preparing(attendee)
    @attendee = attendee
    
    mail :to => attendee.email, :subject => 'Preparing for Trampoline'
  end
  
  def final_reminder(attendee)
    mail :to => attendee.email, :subject => 'Trampoline: The Final Reminder'
  end
  
  def wrapup(attendee)
    mail :to => attendee.email, :subject => 'Trampoline: Wrapping Up'
  end
  
  def waiting_over(waiter)
    @waiter = waiter
    
    mail :to => waiter.email, :subject => 'Trampoline Waiting List: The Waiting is Over'
  end
end
