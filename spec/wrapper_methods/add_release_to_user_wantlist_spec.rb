require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @username = "abuntine"
    @release_id = "1"
  end

  describe ".add_release_to_user_wantlist" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("wantlist_release"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("wantlist_release"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:put).and_return(@oauth_response)

      @wantlist_release = @wrapper.add_release_to_user_wantlist(@username, @release_id)
    end

    describe "when calling simple wantlist release attributes" do

      it "should have an id" do
        expect(@wantlist_release.id).to eq(1)
      end

      it "should have a rating" do
        expect(@wantlist_release.rating).to eq(0)
      end

      it "should have some basic information" do
        expect(@wantlist_release.basic_information.title).to eq("Stockholm")
      end

    end

  end

end 
