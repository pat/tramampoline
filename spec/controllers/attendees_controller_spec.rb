require 'spec_helper'

describe AttendeesController do
  describe '#show' do
    let(:attendee) { Attendee.make }
    
    it "should find the attendee by invite code" do
      get :show, :id => attendee.invite_code
      
      assigns[:attendee].should == attendee
    end
  end
  
  describe '#new' do
    it "should assign a new attendee" do
      get :new
      
      assigns[:attendee].should be_a_new_record
    end
    
    it "should pass through the given referral code" do
      get :new, :attendee => {:referral_code => 'foo'}
      
      assigns[:attendee].referral_code.should == 'foo'
    end
  end
  
  describe '#create' do
    let(:attendee) {
      attendee = Attendee.make
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
