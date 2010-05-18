require 'rubygems' unless ENV['NO_RUBYGEMS']
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Ishi::Persist do
  before do
    prep_sandbox
    load File.dirname(__FILE__) + '/foo_bar.rb'
    load File.dirname(__FILE__) + '/fee_fur.rb'
  end
  
  it "should generate id for FooBar on first save, but not on second" do
    foo = FooBar.new
    foo.save!
    foo.id.should_not be nil

    the_id = foo.id
    foo.save!
    foo.id.should == the_id
  end

  it "should save and retrieve object" do
    foo = FooBar.new
    foo.save!

    bar = FooBar.load(foo.id)

    bar.should == foo
  end

  it "should have attribute-based == equality" do
    foo = FooBar.new
    faa = FooBar.new

    foo.should == faa

    foo.alpha = "purr"
    faa.alpha = "meow"

    foo.should_not == faa
    
    faa.alpha = "purr"
    
    foo.should == faa

    fee = FeeFur.new

    fee.should_not == foo

    fee.alpha = "purr"

    fee.should == foo
  end

  it "should have class and attribute-based .eql? equality" do
    foo = FooBar.new
    faa = FooBar.new

    foo.should.eql? faa

    foo.alpha = "purr"
    faa.alpha = "meow"

    foo.should_not.eql? faa

    faa.alpha = "purr"

    foo.should.eql? faa

    fee = FeeFur.new

    fee.should_not.eql? foo

    fee.alpha = "purr"

    fee.should_not.eql? foo
  end
  
end
