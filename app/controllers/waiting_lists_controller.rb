class WaitingListsController < ApplicationController
  before_filter :redirect_if_no_event
  
  def new
    @waiter = event.waiters.build
  end
  
  def create
    @waiter = event.waiters.build params[:waiter]
    if @waiter.save
      redirect_to waiting_list_path(@waiter.code)
    else
      puts @waiter.errors.full_messages
      render :action => 'new'
    end
  end
  
  def show
    @waiter = Waiter.find_by_code(params[:id])
  end
  
  private
  
  def event
    @event ||= Event.next
  end
end
