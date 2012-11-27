require 'spec_helper'

describe Discogs::Resource do

  before do
    @resource = Discogs::Resource.new(sample_valid_binary)
  end

  it "should have a default element name" do
    Discogs::Resource.element_names.should == [ :resource ]
  end

  it "should have a default plural element name" do
    Discogs::Resource.plural_element_names.should == [ :resources ]
  end

  it "should have an original_content method" do
    @resource.original_content.should == sample_valid_binary
  end

  it "should be able to build the content"

  it "should remove the <resp> element by default"

  it "should leave the <resp> element if told to"

end
