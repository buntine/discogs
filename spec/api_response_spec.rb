require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::APIResponse do

  before do
    @valid_api_response = Discogs::APIResponse.prepare(sample_valid_binary)
    @invalid_api_response = Discogs::APIResponse.new(sample_invalid_data)
  end

  it "should successfully inflate the binary data" do
    @valid_api_response.should be_instance_of(Discogs::APIResponse)
    @invalid_api_response.should be_instance_of(Discogs::APIResponse)

    # Sample data-mining, just to make it clear...
    @valid_api_response.root.attributes["requests"].should_not be_nil
    @invalid_api_response.root.attributes["requests"].should_not be_nil
  end

  it "should be valid if resp is 'ok'" do
    @valid_api_response.valid?.should be_true
  end

  it "should be invalid if resp is 'fail'" do
    @invalid_api_response.valid?.should be_false
  end

  it "should return the number of requests" do
    @valid_api_response.requests.should == 1
    @invalid_api_response.requests.should == 2
  end
end
