require 'spec_helper'

describe 'model validations' do

  let(:klass) { Class.new(AWS::Record::Base) }

  before(:each) do
    klass.create_domain
    klass.each{|u| u.destroy }
    sleep(2)
  end

  describe 'validates_uniqueness_of' do
    it 'should only allow one record with a given attribute value' do
      klass.string_attr :name
      klass.validates_uniqueness_of :name
      widg = klass.new(:name => "Turd Furguson")
      widg.valid?.should be_true
      widg.save
      sleep(2) # Allow a couple of seconds for SimpleDB to catch up

      widg = klass.new(:name => "Turd Furguson")
      widg.valid?.should be_false
      widg.errors[:name].should == ['has already been taken']
    end

    it 'should only allow one record with a given attribute value within a given scope' do
      klass.string_attr :name
      klass.string_attr :category
      klass.validates_uniqueness_of :name, :scope => :category
      widg = klass.new(:name => "Turd Furguson", :category => "Funny name")
      widg.valid?.should be_true
      widg.save
      sleep(2) # Allow a couple of seconds for SimpleDB to catch up

      widg = klass.new(:name => "Turd Furguson", :category => "Funny name")
      widg.valid?.should be_false
      widg.errors[:name].should == ['has already been taken']

      widg.category = "Silly name"
      widg.valid?.should be_true
    end


    it 'should skip the validation if the given attribute is nil when :allow_nil => true' do
      klass.string_attr :name
      klass.string_attr :category # need to avoid the "can't save empty record" error
      klass.validates_uniqueness_of :name#, :allow_nil => true
      widg = klass.new(:name => nil, :category => "A cat")
      widg.valid?.should be_true
      widg.save
      sleep(2) # Allow a couple of seconds for SimpleDB to catch up

      widg = klass.new(:name => nil, :category => "A cat")
      widg.valid?.should be_true
    end

    it 'should skip the validation if the given attribute is blank when :allow_blank => true' do
      klass.string_attr :name
      klass.string_attr :category # need to avoid the "can't save empty record" error
      klass.validates_uniqueness_of :name#, :allow_blank => true
      widg = klass.new(:name => "", :category => "A cat")
      widg.valid?.should be_true
      widg.save
      sleep(2) # Allow a couple of seconds for SimpleDB to catch up

      widg = klass.new(:name => "", :category => "A cat")
      widg.valid?.should be_true
    end

    it 'should skip the validation if the :if option evaluates to false' do
      klass.string_attr :name
      klass.boolean_attr :should_validate
      klass.validates_uniqueness_of :name, :if => :should_validate
      widg = klass.new(:name => "Turd Furguson")
      widg.valid?.should be_true
      widg.save
      sleep(2) # Allow a couple of seconds for SimpleDB to catch up

      widg = klass.new(:name => "Turd Furguson",:should_validate => false)
      widg.valid?.should be_true
    end

    it 'should skip the validation if the :unless option evaluates to true' do
      klass.string_attr :name
      klass.boolean_attr :should_not_validate
      klass.validates_uniqueness_of :name, :unless => :should_not_validate
      widg = klass.new(:name => "Turd Furguson")
      widg.valid?.should be_true
      widg.save
      sleep(2) # Allow a couple of seconds for SimpleDB to catch up

      widg = klass.new(:name => "Turd Furguson",:should_not_validate => true)
      widg.valid?.should be_true
    end

  end

end


