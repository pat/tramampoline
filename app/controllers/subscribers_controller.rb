class SubscribersController < ApplicationController
  def create
    subscriber = Subscriber.new params[:subscriber]
    redirect_to :back unless subscriber.save
  end
end
