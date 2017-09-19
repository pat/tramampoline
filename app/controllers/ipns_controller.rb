class IpnsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    IPNotification.process request
    render :plain => 'OK'
  end
end
