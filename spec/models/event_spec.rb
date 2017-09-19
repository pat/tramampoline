require 'spec_helper'

describe Event do
  describe '.sold_out?' do
    context 'before excess is released' do
      let(:event) {
        Event.make!(
          :release_at    => 1.day.ago,
          :excess_at     => 1.day.from_now,
          :max_attendees => 10
        )
      }

      it "should return true if there are 5 registrations without referral codes" do
        5.times do
          Attendee.make! :event => event, :confirmed => true
        end

        expect(event).to be_sold_out
      end

      it "should return false if there are 5 registrations but not all with referral codes" do
        4.times do
          Attendee.make! :event => event, :confirmed => true
        end

        Attendee.make! :referral_code => Invite.make!.code, :confirmed => true

        expect(event).not_to be_sold_out
      end

      it "does not count unconfirmed attendees" do
        4.times do
          Attendee.make! :event => event, :confirmed => true
        end
        Attendee.make! :confirmed => false

        expect(event).not_to be_sold_out
      end

      it "should return true if 5 registrations with some cancelled" do
        5.times do
          Attendee.make! :event => event, :confirmed => true
        end

        Attendee.limit(2).each(&:cancel!)

        expect(event).to be_sold_out
      end
    end

    context 'after excess is released' do
      let(:event) {
        Event.make!(
          :release_at    => 3.day.ago,
          :excess_at     => 1.day.ago,
          :happens_on    => 1.day.from_now,
          :max_attendees => 10
        )
      }

      it "should return true if 10 places are taken" do
        10.times do
          Attendee.make! :event => event, :confirmed => true
        end

        expect(event).to be_sold_out
      end

      it "should return false if 9 places are taken" do
        9.times do
          Attendee.make! :event => event, :confirmed => true
        end

        expect(event).not_to be_sold_out
      end

      it "should not count unconfirmed attendees" do
        9.times do
          Attendee.make! :event => event, :confirmed => true
        end
        attendee = Attendee.make! :event => event
        attendee.update_attributes(:confirmed => false)

        expect(event).not_to be_sold_out
      end

      it "should return false if 10 registrations with some cancelled before excess" do
        10.times do
          Attendee.make! :event => event, :confirmed => true
        end

        Attendee.limit(1).each { |attendee|
          attendee.cancel! event.excess_at - 1.second
        }

        expect(event).not_to be_sold_out
      end

      it "should return true if 10 registrations with some cancelled after excess released" do
        10.times do
          Attendee.make! :event => event, :confirmed => true
        end

        Attendee.limit(1).each { |attendee|
          attendee.cancel! event.excess_at + 1.second
        }

        expect(event).to be_sold_out
      end
    end
  end
end
