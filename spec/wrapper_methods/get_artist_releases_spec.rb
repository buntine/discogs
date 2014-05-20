require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @artist_id = "313929"
  end

  describe ".get_artists_releases" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("artist_releases"))
      @http_response_as_file = mock(StringIO, :read => read_sample("artist_releases"))
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

      it "should have a first release with a title" do
        @artist_releases.releases.first.title.should == "Frost And Fire"
      end

      it "should have a first release with a type" do
        @artist_releases.releases.first.type.should == "master"
      end

      it "should not have a bogus attribute" do
        @artist_releases.bogus_attr.should be_nil
      end

    end

  end

end 
