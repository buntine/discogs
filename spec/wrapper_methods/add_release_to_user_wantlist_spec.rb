require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = mock(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", @oauth_access_token)

    @username = "abuntine"
    @release_id = "1"
  end

  describe ".add_release_to_user_wantlist" do

    before do
      @oauth_response = mock(OAuth::AccessToken, :code => "200", :body => read_sample("wantlist_release"))
      @oauth_response_as_file = mock(StringIO, :read => read_sample("wantlist_release"))
      Zlib::GzipReader.should_receive(:new).and_return(@oauth_response_as_file)
      @oauth_access_token.should_receive(:put).and_return(@oauth_response)

      @wantlist_release = @wrapper.add_release_to_user_wantlist(@username, @release_id)
    end

    describe "when calling simple wantlist release attributes" do

      it "should have an id" do
        @wantlist_release.id.should == 1
      end

      it "should have a rating" do
        @wantlist_release.rating.should == 0
      end

      it "should have some basic information" do
        @wantlist_release.basic_information.title.should == "Stockholm"
      end

    end

  end

end 
