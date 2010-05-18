require 'rubygems' unless ENV['NO_RUBYGEMS']
require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Ishi README Examples" do
  before do
    prep_sandbox
  end
  
  it "CRUD example should work" do
    # Any plain Ruby class will do. Just include Ishi::Persist
#    class Kitty
#      include Ishi::Persist
#
#      def name=(name)
#        @name = name
#      end
#
#      def name
#        @name
#      end
#    end
#
#
#    k1 = Kitty.new
#    k1.name = "Eva"
#    k1.save!
#
#    k1.id.should == 1
#
#    k2 = Kitty.new
#    k2.name = "Batman"
#    k2.save!
#
#    k2.id.should == 2
#
#    k1b = Kitty.load(1)
#    k1b.should == k1
#
#    k2b = Kitty.load(2)
#    k2b.should == k2
  end
  
end
