class IpnsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    IPNotification.process request
    render :plain => 'OK'
  end
end
