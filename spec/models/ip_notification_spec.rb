require 'spec_helper'

describe IPNotification do
  describe '.process' do
    let(:request)      { double('request', :params => {}, :body => body) }
    let(:body)         { double('body', :read => '') }
    let(:notification) {
      stub('ip_notification', :legit? => true, :process! => nil, :save! => true)
    }

    it "instantiates a new notification object" do
      IPNotification.should_receive(:create!).and_return(notification)

      IPNotification.process request
    end

    context 'legit' do
      before :each do
        IPNotification.stub!(:create! => notification)
        notification.stub!(:legit? => true)
      end

      it "calls #process on the notification object if valid" do
        notification.should_receive(:process!)

        IPNotification.process request
      end

      it "returns true" do
        IPNotification.process(request).should be_true
      end
    end

    context 'not legit' do
      before :each do
        IPNotification.stub!(:new => notification)
        notification.stub!(:legit? => false)
      end

      it "doesn't call #process" do
        notification.should_not_receive(:process!)

        IPNotification.process request
      end

      it "returns false" do
        IPNotification.process(request).should be_false
      end
    end
  end

  describe '#legit?' do
    let(:request)      { stub('request') }
    let(:notification) { IPNotification.new :request => request }

    it "is valid when verified and business matches" do
      notification.stub!(:verified? => true, :correct_business? => true)
      notification.should be_legit
    end

    it "isn't valid when not verified but business matches" do
      notification.stub!(:verified? => false, :correct_business? => true)
      notification.should_not be_legit
    end

    it "isn't valid when not verified and business doesn't match" do
      notification.stub!(:verified? => false, :correct_business? => false)
      notification.should_not be_legit
    end

    it "isn't valid when verified but business doesn't match" do
      notification.stub!(:verified? => true, :correct_business? => false)
      notification.should_not be_legit
    end
  end

  describe '#verified?' do
    let(:paypal_regex) {
      /^https:\/\/www\.paypal\.com\/cgi-bin\/webscr/
    }
    let(:body)         { stub('body', :read => 'foo=bar') }
    let(:request)      { stub('request', :params => {}, :body => body) }
    let(:notification) { IPNotification.make! :request => request }

    it "is verified when PayPal returns VERIFIED" do
      FakeWeb.register_uri(:get, paypal_regex, :body => 'VERIFIED')

      notification.should be_verified
    end

    it "is invalid when PayPal returns INVALID" do
      FakeWeb.register_uri(:get, paypal_regex, :body => 'INVALID')

      notification.should_not be_verified
    end

    it "is invalid when PayPal returns anything else" do
      FakeWeb.register_uri(:get, paypal_regex, :body => 'foo')

      notification.should_not be_verified
    end

    it "passes the original query string back to PayPal" do
      notification.verified?

      FakeWeb.should have_requested(:get,
        'https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate&foo=bar')
    end
  end

  describe '#correct_business?' do
    let(:body)         { stub('body', :read => '') }
    let(:request)      { stub('request', :params => {}, :body => body) }
    let(:notification) { IPNotification.make! :request => request }

    it "is true if the business email matches" do
      request.params['business'] = IPNotification::Business
      notification.should be_correct_business
    end

    it "is false if the receiver email is someone else" do
      request.params['business'] = 'foo@bar.com'
      notification.should_not be_correct_business
    end
  end

  describe '#process!' do
    let(:body)         { stub('body', :read => '') }
    let(:request)      { stub('request', :params => {}, :body => body) }
    let(:notification) { IPNotification.make! :request => request }
    let(:attendee)     { Attendee.make! }

    before :each do
      request.params['custom'] = attendee.id.to_s

      Attendee.stub!(:find => attendee)
    end

    context 'not legit' do
      before :each do
        notification.stub!(:legit? => false)
      end

      it "raises an exception if invalid" do
        lambda {
          notification.process!
        }.should raise_error(IPNotification::InvalidNotificationError)
      end

      it "does not confirm the attendee" do
        attendee.should_not_receive(:confirm!)

        begin
          notification.transaction_type = 'send_money'
          notification.process!
        rescue IPNotification::InvalidNotificationError
        end
      end
    end

    context 'legit' do
      before :each do
        notification.stub!(:legit? => true)
      end

      it "confirms the attendee if money is sent" do
        attendee.should_receive(:confirm!)

        notification.transaction_type = 'send_money'
        notification.process!
      end
    end
  end
end
