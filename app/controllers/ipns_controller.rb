class IpnsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    IPNotification.process request
    render :text => 'OK'
  end
end
