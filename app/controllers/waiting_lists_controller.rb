class WaitingListsController < ApplicationController
  before_filter :redirect_if_no_event

  expose(:event) { Event.find params[:event_id] }

  def new
    @waiter = event.waiters.build
  end

  def create
    @waiter = event.waiters.build waiter_params
    if @waiter.save
      redirect_to event_waiting_list_path(event, @waiter.code)
    else
      puts @waiter.errors.full_messages
      render :action => 'new'
    end
  end

  def show
    @waiter = Waiter.find_by(:code => params[:id])
  end

  private

  def waiter_params
    params.fetch(:waiter, {}).permit :name, :email
  end
end
