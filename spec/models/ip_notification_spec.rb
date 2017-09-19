require 'spec_helper'

describe IPNotification do
  let(:paypal_regex) {
    /^https:\/\/www\.paypal\.com\/cgi-bin\/webscr/
  }

  before :each do
    stub_request(:get, paypal_regex).to_return(body: 'VERIFIED')
  end

  describe '.process' do
    let(:request)      { double('request', :params => {}, :body => body) }
    let(:body)         { double('body', :read => '') }
    let(:notification) {
      double('ip_notification', :legit? => true, :process! => nil, :save! => true)
    }

    it "instantiates a new notification object" do
      expect(IPNotification).to receive(:create!).and_return(notification)

      IPNotification.process request
    end

    context 'legit' do
      before :each do
        IPNotification.stub(:create! => notification)
        notification.stub(:legit? => true)
      end

      it "calls #process on the notification object if valid" do
        expect(notification).to receive(:process!)

        IPNotification.process request
      end

      it "returns true" do
        expect(IPNotification.process(request)).to eq(true)
      end
    end

    context 'not legit' do
      before :each do
        IPNotification.stub(:new => notification)
        notification.stub(:legit? => false)
      end

      it "doesn't call #process" do
        expect(notification).not_to receive(:process!)

        IPNotification.process request
      end

      it "returns false" do
        expect(IPNotification.process(request)).to eq(false)
      end
    end
  end

  describe '#legit?' do
    let(:request)      { double('request') }
    let(:notification) { IPNotification.new :request => request }

    it "is valid when verified and business matches" do
      notification.stub(:verified? => true, :correct_business? => true)
      expect(notification).to be_legit
    end

    it "isn't valid when not verified but business matches" do
      notification.stub(:verified? => false, :correct_business? => true)
      expect(notification).not_to be_legit
    end

    it "isn't valid when not verified and business doesn't match" do
      notification.stub(:verified? => false, :correct_business? => false)
      expect(notification).not_to be_legit
    end

    it "isn't valid when verified but business doesn't match" do
      notification.stub(:verified? => true, :correct_business? => false)
      expect(notification).not_to be_legit
    end
  end

  describe '#verified?' do
    let(:body)         { double('body', :read => 'foo=bar') }
    let(:request)      { double('request', :params => {}, :body => body) }
    let(:notification) { IPNotification.make! :request => request }

    it "is verified when PayPal returns VERIFIED" do
      stub_request(:get, paypal_regex).to_return(body: 'VERIFIED')

      expect(notification).to be_verified
    end

    it "is invalid when PayPal returns INVALID" do
      stub_request(:get, paypal_regex).to_return(body: 'INVALID')

      expect(notification).not_to be_verified
    end

    it "is invalid when PayPal returns anything else" do
      stub_request(:get, paypal_regex).to_return(body: 'foo')

      expect(notification).not_to be_verified
    end

    it "passes the original query string back to PayPal" do
      stub_request(:get, paypal_regex).to_return(body: 'VERIFIED')

      notification.verified?

      expect(a_request(:get,
        'https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate&foo=bar')
      ).to have_been_made.once
    end
  end

  describe '#correct_business?' do
    let(:body)         { double('body', :read => '') }
    let(:request)      { double('request', :params => {}, :body => body) }
    let(:notification) { IPNotification.make! :request => request }

    it "is true if the business email matches" do
      request.params['business'] = IPNotification::Business
      expect(notification).to be_correct_business
    end

    it "is false if the receiver email is someone else" do
      request.params['business'] = 'foo@bar.com'
      expect(notification).not_to be_correct_business
    end
  end

  describe '#process!' do
    let(:body)         { double('body', :read => '') }
    let(:request)      { double('request', :params => {}, :body => body) }
    let(:notification) { IPNotification.make! :request => request, :attendee => attendee }
    let(:attendee)     { Attendee.make! }

    before :each do
      request.params['custom'] = attendee.id.to_s

      Attendee.stub(:find => attendee)
    end

    context 'not legit' do
      before :each do
        notification.stub(:legit? => false)
      end

      it "raises an exception if invalid" do
        expect {
          notification.process!
        }.to raise_error(IPNotification::InvalidNotificationError)
      end

      it "does not confirm the attendee" do
        expect(attendee).not_to receive(:confirm!)

        begin
          notification.transaction_type = 'send_money'
          notification.process!
        rescue IPNotification::InvalidNotificationError
        end
      end
    end

    context 'legit' do
      before :each do
        notification.stub(:legit? => true, :attendee => attendee)
      end

      it "confirms the attendee if money is sent" do
        expect(attendee).to receive(:confirm!)

        notification.transaction_type = 'send_money'
        notification.process!
      end
    end
  end
end
