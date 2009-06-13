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

  describe "when requesting a release" do
 
    before do
      @valid_release_id = "999"
      @invalid_release_id = "krematorr"
    end

    it "should successfully return a Discogs::Release object"

    it "should raise an exception if an invalid API Key is supplied"

    it "should raise an exception if the release does not exist"

    describe "when calling release attributes" do

      before do
        
      end

      it "should have a name attribute"

      it "should have an ID attribute"

      it "should have one or more releases"

    end

  end

end
