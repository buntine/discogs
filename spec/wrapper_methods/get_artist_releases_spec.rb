require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @artist_id = "313929"
  end

  describe ".get_artists_releases" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_artist_releases_json)
      @http_response_as_file = mock(StringIO, :read => valid_artist_releases_json)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @artist_releases = @wrapper.get_artist_releases(@artist_id)
    end

    describe "when calling simple releases attributes" do

      it "should have 37 releases per page" do
        @artist_releases.releases.length.should == 37
      end

      it "should have 37 releases total" do
        @artist_releases.pagination.items.should == 37
      end

      it "should not have a bogus attribute" do
      	@artist_releases.bogus_attribute.should be_nil
      end

    end

    describe "when calling complex releases attributes" do

    end

  end

end 
