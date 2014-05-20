require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = mock(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", @oauth_access_token)
  end

  describe ".get_identity" do

    before do
      @oauth_response = mock(OAuth::AccessToken, :code => "200", :body => read_sample("identity"))
      @oauth_response_as_file = mock(StringIO, :read => read_sample("identity"))
      Zlib::GzipReader.should_receive(:new).and_return(@oauth_response_as_file)
      @oauth_access_token.should_receive(:get).and_return(@oauth_response)

      @identity = @wrapper.get_identity
    end

    describe "when calling simple identity attributes" do

      it "should have a username" do
        @identity.username.should == "example"
      end

      it "should have a consumer_name" do
        @identity.consumer_name.should == "Your Application Name"
      end

    end

  end

end 
