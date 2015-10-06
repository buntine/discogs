require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @username = "abuntine"
  end

  describe ".edit_user" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("user_profile"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("user_profile"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:post).and_return(@oauth_response)

      @user_profile = @wrapper.edit_user(@username, {:profile => "This is a new profile"})
    end

    describe "when calling simple user profile attributes" do

      it "should have a username" do
        expect(@user_profile.username).to eq("abuntine")
      end

      it "should have a new profile" do
        expect(@user_profile.profile).to eq("This is a new profile")
      end

    end

  end

end 
