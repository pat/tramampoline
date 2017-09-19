require 'spec_helper'

describe AttendeesController do
  describe '#show' do
    let(:attendee) { Attendee.make! }

    it "should find the attendee by invite code" do
      get :show, :event_id => attendee.event.to_param, :id => attendee.slug

      expect(controller.attendee).to eq(attendee)
    end
  end

  describe '#new' do
    it "should redirect if tickets aren't on sale yet" do
      event = Event.make! :release_at => 1.day.from_now

      get :new, :event_id => event.to_param

      expect(response).to redirect_to(patience_event_attendees_path(event))
    end

    it "should redirect if Trampoline is finished" do
      event = Event.make! :happens_on => 1.day.ago

      get :new, :event_id => event.to_param

      expect(response).to redirect_to('/')
    end

    it "should assign a new attendee" do
      event = Event.make! :release_at => 1.day.ago

      get :new, :event_id => event.to_param

      expect(controller.attendee).to be_a_new_record
    end

    it "should pass through the given referral code" do
      event = Event.make! :release_at => 1.day.ago
      attendee = Attendee.make!

      get :new, :event_id => event.to_param,
        :attendee => {:referral_code => attendee.invite.code}

      expect(controller.attendee.referral_code).to eq(attendee.invite.code)
    end

    it "should accept invite codes in simple parameters" do
      event    = Event.make! :release_at => 1.day.ago
      attendee = Attendee.make! :event => event

      get :new, :event_id => event.to_param,
        :invite_code => attendee.invite.code

      expect(controller.attendee.referral_code).to eq(attendee.invite.code)
    end

    context 'invalid referral code' do
      before :each do
        event = Event.make! :release_at => 1.day.ago
        get :new, :event_id => event.to_param,
          :attendee => {:referral_code => 'foo'}
      end

      it "should provide a warning" do
        expect(flash[:notice]).to match(/link you just clicked isn't quite right/)
      end

      it "should render the warning view" do
        expect(response).to render_template('attendees/warning')
      end
    end

    context 'already used referral code' do
      before :each do
        event    = Event.make! :release_at => 1.day.ago
        attendee = Attendee.make! :referral_code => Attendee.make!.invite.code,
          :event => event

        get :new, :event_id => event.to_param,
          :attendee => {:referral_code => attendee.referral_code}
      end

      it "should provide a warning" do
        expect(flash[:notice]).to match(/invitation has already been registered/)
      end

      it "should render the warning view" do
        expect(response).to render_template('attendees/warning')
      end
    end

    context 'initial release booked out' do
      let(:event) { Event.make! :release_at => 1.day.ago }

      before :each do
        event.stub(:sold_out? => true)
        Event.stub(:find => event)
      end

      it "should redirect to the sold out view if there's no places free" do
        get :new, :event_id => event.to_param

        expect(response).to redirect_to(sold_out_event_attendees_path(event))
      end

      it "should render the default view if a valid referral code is provided" do
        attendee = Attendee.make!

        get :new, :event_id => event.to_param,
          :attendee => {:referral_code => attendee.invite.code}

        expect(response).to render_template('attendees/new')
      end
    end
  end

  describe '#create' do
    let(:event) { Event.make! :release_at => 1.day.ago }
    let(:attendee) {
      Attendee.make!.tap { |attendee| Attendee.stub(:new => attendee) }
    }

    it "should render the paypal page on success" do
      attendee.stub(:save => true)

      post :create, :event_id => event.to_param, :attendee => {}

      expect(response).to render_template('attendees/paypal_redirect')
    end

    it "should re-render the new view on failure" do
      attendee.stub(:save => false)

      post :create, :event_id => event.to_param, :attendee => {}

      expect(response).to render_template('attendees/new')
    end
  end
end
