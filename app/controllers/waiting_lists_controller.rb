class WaitingListsController < ApplicationController
  before_filter :redirect_if_no_event

  expose(:event) { Event.find params[:event_id] }

  def new
    @waiter = event.waiters.build
  end

  def create
    @waiter = event.waiters.build params[:waiter]
    if @waiter.save
      redirect_to event_waiting_list_path(event, @waiter.code)
    else
      puts @waiter.errors.full_messages
      render :action => 'new'
    end
  end

  def show
    @waiter = Waiter.find_by_code(params[:id])
  end
end
