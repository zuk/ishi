require 'rubygems' unless ENV['NO_RUBYGEMS']
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Ishi::DataStore do
  before do
    class Foo
      attr_accessor :id
      attr_accessor :payload
    end

    prep_sandbox
  end
  
  it "should use foo as the directory for the Foo model" do
    Ishi.datastore.directory_for_class(Foo).should == SANDBOX + "/foo"
  end

  it "init_class should create a foo directory for the Foo model" do
    Ishi.datastore.init_class(Foo)
    File.exists?(SANDBOX + '/foo').should be true
  end

  it "should generate a new id of 1 when it is the first instance of Foo" do
    Ishi.datastore.init_class(Foo)
    Ishi.datastore.new_id_for_class(Foo).should == 1
  end

  it "should generate file '1.yml' for the first saved instance" do
    Ishi.datastore.init_class(Foo)
    foo = Foo.new
    Ishi.datastore.store_object(foo)
    File.exists?(SANDBOX + '/foo/1.yml').should be true
  end

  it "should generate file '2.yml' for the second saved instance" do
    Ishi.datastore.init_class(Foo)
    foo = Foo.new
    Ishi.datastore.store_object(foo)
    foo2 = Foo.new
    Ishi.datastore.store_object(foo2)
    File.exists?(SANDBOX + '/foo/2.yml').should be true
  end

  it "should perform CRUD operations on an object" do
    Ishi.datastore.init_class(Foo)
    foo = Foo.new
    foo.payload = "hello"
    Ishi.datastore.store_object(foo)
    foo2 = Ishi.datastore.retrieve_object_by_class_and_id(foo.class, foo.id)
    foo2.id.should == foo.id
    foo2.payload.should == "hello"
  end

  it "should automatically initialize the class for storage" do
    # note that we don't call Init.datastore.init_class(Foo) here
    foo = Foo.new
    foo.payload = "hello"
    Ishi.datastore.store_object(foo)
  end

  it "should raise Ishi::NoSuchObject when trying to retrieve an object that doesn't exist" do
    lambda do
      Ishi.datastore.retrieve_object_by_class_and_id(Foo, 999999)
    end.should raise_error Ishi::DataStore::NoSuchObject
  end

  it "should work on primitive Ruby Hash objects" do
    hash = {:one => 1, 'two' => "TWO", :three => {:i_am => 'nested'}}
    Ishi.datastore.store_object(hash)
    require 'ruby-debug'
    
    hash2 = Ishi.datastore.retrieve_object_by_class_and_id(Hash, hash.object_id)
    hash2.should == hash
  end
  
end
