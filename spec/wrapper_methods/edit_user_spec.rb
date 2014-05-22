require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = mock(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", @oauth_access_token)
    @username = "abuntine"
  end

  describe ".edit_user" do

    before do
      @oauth_response = mock(OAuth::AccessToken, :code => "200", :body => read_sample("user_profile"))
      @oauth_response_as_file = mock(StringIO, :read => read_sample("user_profile"))
      Zlib::GzipReader.should_receive(:new).and_return(@oauth_response_as_file)
      @oauth_access_token.should_receive(:post).and_return(@oauth_response)

      @user_profile = @wrapper.edit_user(@username, {:profile => "This is a new profile"})
    end

    describe "when calling simple user profile attributes" do

      it "should have a username" do
        @user_profile.username.should == "abuntine"
      end

      it "should have a new profile" do
        @user_profile.profile.should == "This is a new profile"
      end

    end

  end

end 
