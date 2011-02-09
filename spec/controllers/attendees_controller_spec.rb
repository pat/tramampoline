require 'spec_helper'

describe AttendeesController do
  describe '#show' do
    let(:attendee) { Attendee.make! }
    
    it "should find the attendee by invite code" do
      get :show, :id => attendee.invite_code
      
      assigns[:attendee].should == attendee
    end
  end
  
  describe '#new' do
    it "should redirect if tickets aren't on sale yet" do
      Event.make! :release_at => 1.day.from_now
      
      get :new
      
      response.should redirect_to(patience_attendees_path)
    end
    
    it "should redirect if Trampoline is finished" do
      Event.make! :happens_on => 1.day.ago
      
      get :new
      
      response.should redirect_to(pending_attendees_path)
    end
    
    it "should assign a new attendee" do
      Event.make! :release_at => 1.day.ago
      
      get :new
      
      assigns[:attendee].should be_a_new_record
    end
    
    it "should pass through the given referral code" do
      Event.make! :release_at => 1.day.ago
      attendee = Attendee.make!
      
      get :new, :attendee => {:referral_code => attendee.invite_code}
      
      assigns[:attendee].referral_code.should == attendee.invite_code
    end
    
    it "should accept invite codes in simple parameters" do
      Event.make! :release_at => 1.day.ago
      attendee = Attendee.make!
      
      get :new, :invite_code => attendee.invite_code
      
      assigns[:attendee].referral_code.should == attendee.invite_code
    end
    
    context 'invalid referral code' do
      before :each do
        Event.make! :release_at => 1.day.ago
        get :new, :attendee => {:referral_code => 'foo'}
      end
      
      it "should provide a warning" do
        flash[:notice].should match(/link you just clicked isn't quite right/)
      end
      
      it "should render the warning view" do
        response.should render_template('attendees/warning')
      end
    end
    
    context 'already used referral code' do
      before :each do
        Event.make! :release_at => 1.day.ago
        attendee = Attendee.make! :referral_code => Attendee.make!.invite_code
        
        get :new, :attendee => {:referral_code => attendee.referral_code}
      end
      
      it "should provide a warning" do
        flash[:notice].should match(/invitation has already been registered/)
      end
      
      it "should render the warning view" do
        response.should render_template('attendees/warning')
      end
    end
    
    context 'initial release booked out' do
      before :each do
        event = Event.make! :release_at => 1.day.ago
        event.stub!(:sold_out? => true)
        Event.stub!(:next => event)
      end
      
      it "should redirect to the sold out view if there's no places free" do
        get :new
        
        response.should redirect_to(sold_out_attendees_path)
      end
      
      it "should render the default view if a valid referral code is provided" do
        attendee = Attendee.make!

        get :new, :attendee => {:referral_code => attendee.invite_code}
        
        response.should render_template('attendees/new')
      end
    end
  end
  
  describe '#create' do
    before :each do
      Event.make! :release_at => 1.day.ago
    end
    
    let(:attendee) {
      attendee = Attendee.make!
      Attendee.stub!(:new => attendee)
      attendee
    }
    
    it "should redirect to the attendee page on success" do
      attendee.stub!(:save => true)
      
      post :create, :attendee => {}
      
      response.should redirect_to(attendee_path(attendee.invite_code))
    end
    
    it "should re-render the new view on failure" do
      attendee.stub!(:save => false)
      
      post :create, :attendee => {}
      
      response.should render_template('attendees/new')
    end
  end
end
