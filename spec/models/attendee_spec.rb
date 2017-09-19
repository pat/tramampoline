require 'spec_helper'

describe Attendee do
  let(:invite) { Invite.make! }

  before :each do
    ActionMailer::Base.deliveries.clear
  end

  describe '.create' do
    it "should automatically add an invite if not a referred user" do
      attendee = Attendee.make!
      expect(Invite.where(:parent_id => attendee.id, :parent_type => 'Attendee').count).
        to eq(1)
    end

    it "should email the attendee if created and confirmed" do
      attendee = Attendee.make! :confirmed => true

      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?(attendee.email)
      }).not_to be_nil
    end

    it "should email the invited email address" do
      Attendee.make! :invite_email => 'foo@bar.com', :confirmed => true

      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?('foo@bar.com')
      }).not_to be_nil
    end

    it "should not try to send an email if there's no invite email address" do
      Attendee.make! :confirmed => true

      expect(ActionMailer::Base.deliveries.length).to eq(1)
    end

    it "should not send an invite email if there is a referral code" do
      Attendee.make!(
        :invite_email  => 'foo@bar.com',
        :referral_code => invite.code,
        :confirmed     => true,
        :invite        => nil
      )

      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?('foo@bar.com')
      }).to be_nil
    end

    it "does not send an email when unconfirmed" do
      attendee = Attendee.make! :confirmed => false

      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?(attendee.email)
      }).to be_nil
    end

    it "does not send an invite email when unconfirmed" do
      Attendee.make! :invite_email => 'foo@bar.com', :confirmed => false

      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?('foo@bar.com')
      }).to be_nil
    end

    it "should ensure the slugs are unique" do
      attendee = Attendee.make!

      allow(Digest::SHA1).to receive(:hexdigest).and_return(attendee.slug, 'foo')

      expect(Attendee.make!.slug).to eq('foo')
    end
  end

  describe '#confirm!' do
    let(:attendee) { Attendee.make! :confirmed => false }

    it "marks the attendee as confirmed" do
      attendee.confirm!
      attendee.reload

      expect(attendee).to be_confirmed
    end
  end

  describe '#save' do
    let(:attendee) { Attendee.make! }

    it "sends email when an attendee is changed to be confirmed" do
      attendee.update_attributes(:confirmed => true)

      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?(attendee.email)
      }).not_to be_nil
    end

    it "send invite email when an attendee is changed to be confirmed" do
      attendee.update_attributes(:invite_email => 'foo@baz.com')
      expect(ActionMailer::Base.deliveries).to be_empty

      attendee.update_attributes(:confirmed => true)
      expect(ActionMailer::Base.deliveries.detect { |mail|
        mail.to.include?('foo@baz.com')
      }).not_to be_nil
    end
  end

  describe '#valid?' do
    {
      :name  => 'name',
      :email => 'email address'
    }.each do |attribute, human_name|
      it "should be invalid without a #{human_name}" do
        attendee = Attendee.make attribute => nil
        expect(attendee).not_to be_valid
        expect(attendee.errors[attribute].size).to eq(1)
      end
    end
  end

  describe '#inviting?' do
    it "should be true if there is an invite email address" do
      expect(Attendee.make!(:invite_email => 'foo@bar.com')).to be_inviting
    end

    it "should be false if there is no invite email address" do
      expect(Attendee.make!(:invite_email => nil)).not_to be_inviting
    end
  end

  describe '#invited?' do
    it "should be true if there is a referral invite" do
      expect(Attendee.make!(:referral_code => invite.code)).to be_invited
    end

    it "should be false if there is no referral code" do
      expect(Attendee.make!(:referral_code => nil)).not_to be_invited
    end
  end
end
