require 'spec_helper'

describe Subscriber do
  describe '.cleanup!' do
    it "should remove blank named subscribers when one exists with a name and the same email address" do
      Subscriber.new(:name => 'Xavier Shay', :email => 'x@shay.com').
        save(:validate => false)
      Subscriber.new(:name => '', :email => 'x@shay.com').
        save(:validate => false)

      Subscriber.cleanup!

      subscribers = Subscriber.where(:email => 'x@shay.com')
      expect(subscribers.length).to eq(1)
      expect(subscribers.first.name).to eq('Xavier Shay')
    end

    it "should keep one subscriber if there are multiple with no names for the same email address" do
      Subscriber.new(:name => '', :email => 's@sabey.com').
        save(:validate => false)
      Subscriber.new(:name => '', :email => 's@sabey.com').
        save(:validate => false)

      Subscriber.cleanup!

      expect(Subscriber.where(:email => 's@sabey.com').length).to eq(1)
    end

    it "should remove all but one named subscriber for each email address" do
      Subscriber.new(:name => 'Pete Spence', :email => 'p@spen.ce').
        save(:validate => false)
      Subscriber.new(:name => 'Pete Spence', :email => 'p@spen.ce').
        save(:validate => false)

      Subscriber.cleanup!

      expect(Subscriber.where(:email => 'p@spen.ce').length).to eq(1)
    end
  end

  describe '#valid?' do
    it "should be invalid without an email address" do
      subscriber = Subscriber.make :email => nil
      expect(subscriber).to have(1).error_on(:email)
    end

    it "should be invalid without a unique email address" do
      existing = Subscriber.make!
      subscriber = Subscriber.make :email => existing.email
      expect(subscriber).to have(1).error_on(:email)
    end
  end
end
