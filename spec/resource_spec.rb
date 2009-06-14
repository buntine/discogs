require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::Resource do

  before do
    @api_response = Discogs::APIResponse.prepare(sample_valid_binary)
    @resource = Discogs::Resource.new(@api_response)
  end

  it "should have a default element name" do
    Discogs::Resource.element_name.should == "resource"
  end

  it "should have a default plural element name" do
    Discogs::Resource.plural_element_name.should == "resources"
  end

end
