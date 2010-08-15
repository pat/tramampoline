require 'spec_helper'

describe Event do
  describe '.sold_out?' do
    context 'before excess is released' do
      let(:event) {
        Event.make(
          :release_at    => 1.day.ago,
          :excess_at     => 1.day.from_now,
          :max_attendees => 150
        )
      }
      
      it "should return true if there are 75 registrations without referral codes" do
        75.times do
          Attendee.make :event => event
        end
        
        event.should be_sold_out
      end
      
      it "should return false if there are over 75 registrations but not all with referral codes" do
        74.times do
          Attendee.make :event => event
        end
        
        Attendee.make :referral_code => 'foo'
        
        event.should_not be_sold_out
      end
    end
    
    context 'after excess is released' do
      let(:event) {
        Event.make(
          :release_at    => 3.day.ago,
          :excess_at     => 1.day.ago,
          :happens_on    => 1.day.from_now,
          :max_attendees => 150
        )
      }
      
      it "should return true if 150 places are taken" do
        150.times do
          Attendee.make :event => event
        end
        
        event.should be_sold_out
      end
      
      it "should return false if 149 places are taken" do
        149.times do
          Attendee.make :event => event
        end
        
        event.should_not be_sold_out
      end
    end
  end
end