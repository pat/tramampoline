require 'spec_helper'

describe Subscriber do
  describe '.cleanup!' do
    it "should remove blank named subscribers when one exists with a name and the same email address" do
      Subscriber.new(:name => 'Xavier Shay', :email => 'x@shay.com').save(false)
      Subscriber.new(:name => '', :email => 'x@shay.com').save(false)
      
      Subscriber.cleanup!
      
      subscribers = Subscriber.find_all_by_email('x@shay.com')
      subscribers.length.should == 1
      subscribers.first.name.should == 'Xavier Shay'
    end
    
    it "should keep one subscriber if there are multiple with no names for the same email address" do
      Subscriber.new(:name => '', :email => 's@sabey.com').save(false)
      Subscriber.new(:name => '', :email => 's@sabey.com').save(false)
      
      Subscriber.cleanup!
      
      Subscriber.find_all_by_email('s@sabey.com').length.should == 1
    end
    
    it "should remove all but one named subscriber for each email address" do
      Subscriber.new(:name => 'Pete Spence', :email => 'p@spen.ce').save(false)
      Subscriber.new(:name => 'Pete Spence', :email => 'p@spen.ce').save(false)
      
      Subscriber.cleanup!
      
      Subscriber.find_all_by_email('p@spen.ce').length.should == 1
    end
  end
  
  describe '#valid?' do
    it "should be invalid without an email address" do
      subscriber = Subscriber.make_unsaved :email => nil
      subscriber.should have(1).error_on(:email)
    end
    
    it "should be invalid without a unique email address" do
      existing = Subscriber.make
      subscriber = Subscriber.make_unsaved :email => existing.email
      subscriber.should have(1).error_on(:email)
    end
  end
end
