require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::Wrapper do

  before do
    @valid_api_key = "f20d709d54"
    @invalid_api_key = "wolfspider"
    @wrapper = Discogs::Wrapper.new(@valid_api_key)
    @invalid_wrapper = Discogs::Wrapper.new(@invalid_api_key)
  end

  it "should have an api key" do
    @wrapper.api_key.should == @valid_api_key
  end

  describe "when requesting a release" do
 
    before do
      @valid_release_id = "999"
      @invalid_release_id = "krematorr"
    end

    it "should successfully return a Discogs::Release object" do
      @wrapper.get_release(@valid_release_id).should be_instance_of(Discogs::Release)
    end

    it "should raise an exception if an invalid API Key is supplied" do
      lambda { @invalid_wrapper.get_release(@valid_release_id) }.should raise_error(Discogs::InvalidAPIKey)
    end

    it "should raise an exception if the release does not exist" do
      lambda { @wrapper.get_release(@invalid_release_id) }.should raise_error(Discogs::UnknownResource)
    end

    describe "when calling simple release attributes" do

      before do
        @release = @wrapper.get_release(@valid_release_id)
      end

      it "should have a title attribute" do
        @release.title.should == "Into the Abyss"
      end

      it "should have an ID attribute" do
        @release.id.should == "999"
      end

      it "should have one or more tracks" do
        @release.tracklist.should be_instance_of(Array)
        @release.tracklist[0].should be_instance_of(Discogs::Track)
      end

    end

    describe "when calling complex release attributes" do

      before do
        @release = @wrapper.get_release(@valid_release_id)
      end

      it "should have a duration for the first track" do
        @release.tracklist[0].duration.should == "8:30"
      end

      it "should have a traversible list of styles" do
        @release.styles.should be_instance_of(Discogs::StyleList)
        @release.styles[0].should == "Black Metal"
        @release.styles[1].should == "Thrash"
      end

      it "should have an artist associated to the second track" do
        @release.tracks[1].artists[0].should be_instance_of(Discogs::Artist)
        @release.tracks[1].artists[0].name.should == "Poison"
      end

    end

  end

end
