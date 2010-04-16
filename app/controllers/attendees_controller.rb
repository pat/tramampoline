class AttendeesController < ApplicationController
  def show
    @attendee = Attendee.find_by_invite_code params[:id]
  end
  
  def new
    if invalid_referral_code?
      flash[:notice] = "The link you just clicked isn't quite right."
      render :action => 'warning'
    elsif used_referral_code?
      flash[:notice] = "This invitation has already been registered."
      render :action => 'warning'
    end
  end
  
  def create
    if attendee.save
      redirect_to attendee_path(attendee.invite_code)
    else
      render :action => 'new'
    end
  end
  
  private
  
  def attendee
    @attendee ||= Attendee.new params[:attendee]
  end
  
  def invalid_referral_code?
    return false if attendee.referral_code.blank?
    
    Attendee.find_by_invite_code(attendee.referral_code).nil?
  end
  
  def used_referral_code?
    return false if attendee.referral_code.blank?
    
    !Attendee.find_by_referral_code(attendee.referral_code).nil?
  end
end
