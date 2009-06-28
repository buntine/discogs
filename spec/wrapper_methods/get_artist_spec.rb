require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Wrapper do

  before do
    @api_key = "f20d709d54"
    @wrapper = Discogs::Wrapper.new(@api_key)
    @artist_name = "Root"
  end

  describe "when asking for artist information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_artist_xml)
      @http_response_as_file = mock(StringIO, :read => valid_artist_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_session = mock("HTTP Session")
      @http_session.should_receive(:request).and_return(@http_response)
      @http_request.should_receive(:start).and_yield(@http_session)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @artist = @wrapper.get_artist(@artist_name)
    end

    describe "when calling simple artist attributes" do

      it "should have a name attribute" do
        @artist.name.should == "Root"
      end
  
      it "should have a realname attribute" do
        @artist.realname.should == "Rootan"
      end

    end

  end

end
