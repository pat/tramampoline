class AttendeesController < ApplicationController
  before_action :redirect_if_no_event
  before_action :redirect_if_upcoming, :only => [:new, :create]
  before_action :translate_params
  before_action :check_if_over,     :only => [:new, :create]
  before_action :check_if_on_sale,  :only => [:new, :create]
  before_action :check_if_sold_out, :only => [:new, :create]

  expose(:attendee) { attendee_in_context }
  expose(:invite)   { Invite.with_code(attendee.referral_code) }
  expose(:waiter)   { Waiter.find_by(:code => params[:waiting_code]) }
  expose(:event)    { Event.find params[:event_id] }

  def new
    if invalid_referral_code?
      flash[:notice] = "The link you just clicked isn't quite right."
      render :action => 'warning'
    elsif used_referral_code?
      flash[:notice] = "This invitation has already been registered."
      render :action => 'warning'
    elsif late_referral_code?
      flash[:notice] = 'This invitation is no longer valid.'
      render :action => 'warning'
    end
  end

  def create
    attendee.event = event
    if attendee.save
      waiter.update_attributes(:attendee_id => attendee.id) unless waiter.nil?
      if attendee.confirmed?
        redirect_to event_attendee_path(event, attendee.slug)
      else
        render :action => 'paypal_redirect'
      end
    else
      render :action => 'new'
    end
  end

  def confirmed
    render :action => 'show'
  end

  def cancelled
    redirect_to register_path
  end

  private

  def attendee_params
    params.fetch(:attendee, {}).permit :name, :email, :phone, :invite_email,
      :referral_code
  end

  def attendee_in_context
    if params[:id].present?
      Attendee.find_by(:slug => params[:id]) || Attendee.find(params[:id])
    else
      Attendee.new attendee_params
    end
  end

  def invalid_referral_code?
    attendee.referral_code.present? && invite.nil?
  end

  def used_referral_code?
    invite && invite.consumed?
  end

  def late_referral_code?
    invite && invite.expired?
  end

  def check_if_over
    redirect_to pending_event_attendees_path(event) if over?
  end

  def check_if_on_sale
    redirect_to patience_event_attendees_path(event) unless event.on_sale?
  end

  def check_if_sold_out
    redirect_to sold_out_event_attendees_path(event) if sold_out?
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

  def redirect_if_upcoming
    redirect_to '/' if event.id == 15
  end
end
