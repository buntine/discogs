require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::Wrapper do

  before do
    @valid_api_key = "f20d709d54"
    @invalid_api_key = "wolfspider"
    @wrapper = Discogs::Wrapper.new(@valid_api_key)
  end

  it "should have an api key" do
    @wrapper.api_key.should == @valid_api_key
  end

end
