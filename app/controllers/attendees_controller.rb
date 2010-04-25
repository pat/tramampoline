class AttendeesController < ApplicationController
  before_filter :translate_params
  before_filter :check_if_over,     :only => [:new, :create]
  before_filter :check_if_on_sale,  :only => [:new, :create]
  before_filter :check_if_sold_out, :only => [:new, :create]
  
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
  
  def check_if_over
    redirect_to pending_attendees_path if over?
  end
  
  def check_if_on_sale
    redirect_to patience_attendees_path unless Attendee.on_sale?
  end
  
  def check_if_sold_out
    redirect_to sold_out_attendees_path if sold_out?
  end
  
  def over?
    Time.zone.now >= Time.zone.local(2010, 5, 2, 18, 0)
  end
  
  def sold_out?
    (params[:attendee].blank? || params[:attendee][:referral_code].blank?) &&
    Attendee.sold_out?
  end
  
  def translate_params
    return if params[:invite_code].blank?
    
    params[:attendee] ||= {}
    params[:attendee][:referral_code] = params[:invite_code]
  end
end
