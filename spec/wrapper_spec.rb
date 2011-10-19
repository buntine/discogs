require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::Wrapper do

  def mock_http_with_response(code="200", response=nil)
    @http_request = mock(Net::HTTP)
    @http_response = mock(Net::HTTPResponse, :code => code, :body => "")

    unless response.nil?
      @http_response_as_file = mock(StringIO, :read => response)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
    end

    # As of 04/09/2010 - The and_yield method is not working for me. I've removed
    # this from the specs for now, but it's a little troubling because it used to
    # work correctly... (replacement on line #21)
    #@http_session = mock("HTTP Session")
    #@http_session.should_receive(:request).and_return(@http_response)
    #@http_request.should_receive(:start).and_yield(@http_session)

    @http_request.should_receive(:start).and_return(@http_response)
    Net::HTTP.should_receive(:new).and_return(@http_request)
  end

  before do
    @app_name = "some_app"
    @wrapper = Discogs::Wrapper.new(@app_name)
    @release_id = "666666"
    @artist_name = "Dark"
    @label_name = "Monitor"
    @search_term = "barry"
  end

  it "should have an user agent" do
    @wrapper.app_name.should == @app_name
  end

  describe "requested URIs" do
    before do
      @uri = mock("uri", :host => "", :query => "", :path => "")
    end

    it "should generate the correct release URL to parse" do
      mock_http_with_response "200", valid_release_xml
      URI.should_receive(:parse).with("http://api.discogs.com/release/666666?f=xml").and_return(@uri)

      @wrapper.get_release(@release_id)
    end

    it "should generate the correct artist URL to parse" do
      mock_http_with_response "200", valid_artist_xml
      URI.should_receive(:parse).with("http://api.discogs.com/artist/Dark?f=xml&releases=1").and_return(@uri)

      @wrapper.get_artist(@artist_name)
    end

    it "should generate the correct label URL to parse" do
      mock_http_with_response "200", valid_label_xml
      URI.should_receive(:parse).with("http://api.discogs.com/label/Monitor?f=xml&releases=1").and_return(@uri)

      @wrapper.get_label(@label_name)
    end

    it "should generate the correct default search URL to parse" do
      mock_http_with_response "200", valid_search_xml
      URI.should_receive(:parse).with("http://api.discogs.com/search?f=xml&page=1&q=barry&type=all").and_return(@uri)

      @wrapper.search(@search_term)
    end

    it "should generate the correct second-page search URL to parse" do
      mock_http_with_response "200", valid_search_xml
      URI.should_receive(:parse).with("http://api.discogs.com/search?f=xml&page=2&q=barry&type=all").and_return(@uri)

      @wrapper.search(@search_term, :page => 2)
    end

    it "should generate the correct second-page artist search URL to parse" do
      mock_http_with_response "200", valid_search_xml
      URI.should_receive(:parse).with("http://api.discogs.com/search?f=xml&page=2&q=barry&type=artist").and_return(@uri)

      @wrapper.search(@search_term, :page => 2, :type => :artist)
    end

    it "should sanitize the path correctly" do
      mock_http_with_response "200", valid_artist_xml
      URI.should_receive(:parse).with("http://api.discogs.com/artist/A+very+long+band+name?f=xml&releases=1").and_return(@uri)

      @wrapper.get_artist("A very long band name")
    end 

  end

  ## NOTE: See ./spec/wrapper_methods/*.rb for indepth tests on valid API requests.

  describe "when requesting a release" do

    it "should successfully return a Discogs::Release object" do
      mock_http_with_response "200", valid_release_xml
 
      @wrapper.get_release(@release_id).should be_instance_of(Discogs::Release)
    end

    it "should raise an exception if the release does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_release(@release_id) }.should raise_error(Discogs::UnknownResource)
    end

    it "should raise an exception if the server dies a horrible death" do
      mock_http_with_response "500"

      lambda { @wrapper.get_release(@release_id) }.should raise_error(Discogs::InternalServerError)
    end

  end

  describe "when requesting an artist" do

    it "should successfully return a Discogs::Artist object" do
      mock_http_with_response "200", valid_artist_xml
 
      @wrapper.get_artist(@artist_name).should be_instance_of(Discogs::Artist)
    end

    it "should raise an exception if the artist does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_artist(@artist_name) }.should raise_error(Discogs::UnknownResource)
    end

    it "should raise an exception if the server dies a horrible death" do
      mock_http_with_response "500"

      lambda { @wrapper.get_artist(@artist_name) }.should raise_error(Discogs::InternalServerError)
    end

  end

  describe "when requesting a label" do

    it "should successfully return a Discogs::Label object" do
      mock_http_with_response "200", valid_label_xml
 
      @wrapper.get_label(@label_name).should be_instance_of(Discogs::Label)
    end

    it "should raise an exception if the label does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_label(@label_name) }.should raise_error(Discogs::UnknownResource)
    end

    it "should raise an exception if the server dies a horrible death" do
      mock_http_with_response "500"

      lambda { @wrapper.get_label(@label_name) }.should raise_error(Discogs::InternalServerError)
    end

  end

end
