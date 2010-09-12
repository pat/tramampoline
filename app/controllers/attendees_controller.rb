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
    elsif invalid_list_code?
      flash[:notice] = "This link you just clicked isn't quite right."
      render :action => 'list_warning'
    elsif used_list_code?
      flash[:notice] = "This invitation has already been registered."
      render :action => 'list_warning'
    elsif late_list_code?
      flash[:notice] = "This invitation is no longer valid."
      render :action => 'list_warning'
    end
  end
  
  def create
    attendee.event = event
    if attendee.save
      waiter.update_attributes(:attendee_id => attendee.id) unless waiter.nil?
      redirect_to attendee_path(attendee.invite_code)
    else
      render :action => 'new'
    end
  end
  
  private
  
  def attendee
    @attendee ||= Attendee.new params[:attendee]
  end
  
  def invite
    @invite ||= Invite.with_code(attendee.referral_code)
  end
  
  def waiter
    @waiter ||= Waiter.find_by_code(params[:waiting_code])
  end
  
  def event
    @event ||= Event.next
  end
  
  def invalid_referral_code?
    return false if attendee.referral_code.blank?
    
    Attendee.with_code(attendee.referral_code).nil? && invite.nil?
  end
  
  def used_referral_code?
    return false if attendee.referral_code.blank?
    return invite.consumed? if invite
    
    !Attendee.find_by_referral_code(attendee.referral_code).nil?
  end
  
  def invalid_list_code?
    params[:waiting_code].present? && waiter.nil?
  end
  
  def used_list_code?
    waiter && waiter.attendee.present?
  end
  
  def late_list_code?
    waiter && waiter.invited? &&
    ((waiter.invited_at <= (Time.zone.now - 1.day)) || waiter.closed?)
  end
  
  def check_if_over
    redirect_to pending_attendees_path if over?
  end
  
  def check_if_on_sale
    redirect_to patience_attendees_path unless event.on_sale?
  end
  
  def check_if_sold_out
    redirect_to sold_out_attendees_path if sold_out?
  end
  
  def over?
    event.nil?
  end
  
  def sold_out?
    (
      params[:attendee].blank? ||
      params[:attendee][:referral_code].blank?
    ) && params[:waiting_code].blank? && event.sold_out?
  end
  
  def translate_params
    return if params[:invite_code].blank?
    
    params[:attendee] ||= {}
    params[:attendee][:referral_code] = params[:invite_code]
  end
end
