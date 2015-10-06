require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @username = "abuntine"
    @release_id = "1"
  end

  describe ".edit_release_in_user_wantlist" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("wantlist_release"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("wantlist_release"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:post).and_return(@oauth_response)

      @wantlist_release = @wrapper.edit_release_in_user_wantlist(@username, @release_id, {:notes => "This is a note"})
    end

    describe "when calling simple wantlist release attributes" do

      it "should have an id" do
        expect(@wantlist_release.id).to eq(1)
      end

      it "should have a some notes" do
        expect(@wantlist_release.notes).to eq("This is a note")
      end

    end

  end

end 
