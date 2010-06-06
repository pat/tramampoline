class SubscribersController < ApplicationController
  def create
    subscriber = Subscriber.new params[:subscriber]
    unless subscriber.save
      flash[:notice] = "We already have your details recorded - but thanks for making sure you're on the list."
      render :action => 'new'
    end
  end
end
