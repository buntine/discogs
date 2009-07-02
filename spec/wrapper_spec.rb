require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::Wrapper do

  def mock_http_with_response(code="200")
    @http_request = mock(Net::HTTP)
    @http_response = mock(Net::HTTPResponse, :code => code, :body => "")
    @http_session = mock("HTTP Session")
    @http_session.should_receive(:request).and_return(@http_response)
    @http_request.should_receive(:start).and_yield(@http_session)
    Net::HTTP.should_receive(:new).and_return(@http_request)
  end

  before do
    @api_key = "some_key"
    @wrapper = Discogs::Wrapper.new(@api_key)
    @release_id = "666666"
    @artist_name = "Dark"
    @label_name = "Monitor"
  end

  it "should have an api key" do
    @wrapper.api_key.should == @api_key
  end

  ## NOTE: See ./spec/wrapper_methods/*.rb for indepth tests on valid API requests.

  describe "when requesting a release" do

    it "should successfully return a Discogs::Release object" do
      @http_response_as_file = mock(StringIO, :read => valid_release_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      mock_http_with_response "200"
 
      @wrapper.get_release(@release_id).should be_instance_of(Discogs::Release)
    end

    it "should raise an exception if an invalid API Key is supplied" do
      mock_http_with_response "400"

      lambda { @wrapper.get_release(@release_id) }.should raise_error(Discogs::InvalidAPIKey)
    end

    it "should raise an exception if the release does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_release(@release_id) }.should raise_error(Discogs::UnknownResource)
    end

  end

  describe "when requesting an artist" do

    it "should successfully return a Discogs::Artist object" do
      @http_response_as_file = mock(StringIO, :read => valid_artist_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      mock_http_with_response "200"
 
      @wrapper.get_artist(@artist_name).should be_instance_of(Discogs::Artist)
    end

    it "should raise an exception if an invalid API Key is supplied" do
      mock_http_with_response "400"

      lambda { @wrapper.get_artist(@artist_name) }.should raise_error(Discogs::InvalidAPIKey)
    end

    it "should raise an exception if the artist does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_artist(@artist_name) }.should raise_error(Discogs::UnknownResource)
    end

  end

  describe "when requesting a label" do

    it "should successfully return a Discogs::Label object" do
      @http_response_as_file = mock(StringIO, :read => valid_label_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      mock_http_with_response "200"
 
      @wrapper.get_label(@label_name).should be_instance_of(Discogs::Label)
    end

    it "should raise an exception if an invalid API Key is supplied" do
      mock_http_with_response "400"

      lambda { @wrapper.get_label(@label_name) }.should raise_error(Discogs::InvalidAPIKey)
    end

    it "should raise an exception if the label does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_label(@label_name) }.should raise_error(Discogs::UnknownResource)
    end

  end

end
