require 'spec_helper'

describe Subscriber do
  describe '#valid?' do
    it "should be invalid without an email address" do
      subscriber = Subscriber.make_unsaved :email => nil
      subscriber.should have(1).error_on(:email)
    end
  end
end
