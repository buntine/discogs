require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)
  end

  describe ".get_identity" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("identity"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("identity"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:get).and_return(@oauth_response)

      @identity = @wrapper.get_identity
    end

    describe "when calling simple identity attributes" do

      it "should have a username" do
        expect(@identity.username).to eq("example")
      end

      it "should have a consumer_name" do
        expect(@identity.consumer_name).to eq("Your Application Name")
      end

    end

  end

end 
