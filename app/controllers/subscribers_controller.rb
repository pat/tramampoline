class SubscribersController < ApplicationController
  def create
    subscriber = Subscriber.new subscriber_params
    unless subscriber.save
      flash[:notice] = "We already have your details recorded - but thanks for making sure you're on the list."
      render :action => 'new'
    end
  end

  private

  def subscriber_params
    params.fetch(:subscriber, {}).permit :name, :email
  end
end
