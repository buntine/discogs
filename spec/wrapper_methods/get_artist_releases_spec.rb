require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @artist_id = "313929"
  end

  describe ".get_artists_releases" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("artist_releases"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("artist_releases"))

      allow(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      allow(@http_request).to receive(:start).and_return(@http_response)
      allow(Net::HTTP).to receive(:new).and_return(@http_request)

      @artist_releases = @wrapper.get_artist_releases(@artist_id)
    end

    describe "when calling simple releases attributes" do

      it "should have 37 releases per page" do
        expect(@artist_releases.releases.length).to eq(37)
      end

      it "should have 37 releases total" do
        expect(@artist_releases.pagination.items).to eq(37)
      end

      it "should have a first release with a title" do
        expect(@artist_releases.releases.first.title).to eq("Frost And Fire")
      end

      it "should have a first release with a type" do
        expect(@artist_releases.releases.first.type).to eq("master")
      end

      it "should not have a bogus attribute" do
        expect(@artist_releases.bogus_attr).to be_nil
      end

    end

  end

end 
