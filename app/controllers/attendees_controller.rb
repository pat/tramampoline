class AttendeesController < ApplicationController
  def show
    @attendee = Attendee.find_by_invite_code params[:id]
  end
  
  def new
    @attendee = Attendee.new params[:attendee]
  end
  
  def create
    @attendee = Attendee.new params[:attendee]
    
    if @attendee.save
      redirect_to attendee_path(@attendee.invite_code)
    else
      render :action => 'new'
    end
  end
end
