require File.dirname(__FILE__) + "/spec_helper"

describe Discogs::Wrapper do

  before do
    @valid_api_key = "f20d709d54"
    @invalid_api_key = "wolfspider"
    @wrapper = Discogs::Wrapper.new(@valid_api_key)
    @invalid_wrapper = Discogs::Wrapper.new(@invalid_api_key)

    @valid_release_id = "666666"
    @invalid_release_id = "krematorr"
  end

  it "should have an api key" do
    @wrapper.api_key.should == @valid_api_key
  end

  describe "when requesting a release" do

    def mock_http_with_response(code="200")
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => code, :body => "")
      @http_session = mock("HTTP Session")
      @http_session.should_receive(:request).and_return(@http_response)
      @http_request.should_receive(:start).and_yield(@http_session)
      Net::HTTP.should_receive(:new).and_return(@http_request)
    end

    it "should successfully return a Discogs::Release object" do
      @http_response_as_file = mock(StringIO, :read => valid_release_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      mock_http_with_response "200"
 
      @wrapper.get_release(@valid_release_id).should be_instance_of(Discogs::Release)
    end

    it "should raise an exception if an invalid API Key is supplied" do
      mock_http_with_response "400"

      lambda { @wrapper.get_release(@valid_release_id) }.should raise_error(Discogs::InvalidAPIKey)
    end

    it "should raise an exception if the release does not exist" do
      mock_http_with_response "404"

      lambda { @wrapper.get_release(@invalid_release_id) }.should raise_error(Discogs::UnknownResource)
    end

  end

  
  describe "when asking for relase information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_release_xml)
      @http_response_as_file = mock(StringIO, :read => valid_release_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_session = mock("HTTP Session")
      @http_session.should_receive(:request).and_return(@http_response)
      @http_request.should_receive(:start).and_yield(@http_session)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @release = @wrapper.get_release(@valid_release_id)
    end

    describe "when calling simple release attributes" do

      it "should have a title attribute" do
        @release.title.should == "Into the Abyss"
      end
  
      it "should have an ID attribute" do
        @release.id.should == "666666"
      end

      it "should have one or more extra artists" do
        @release.extraartists.should be_instance_of(Array)
        @release.extraartists[0].should be_instance_of(Discogs::Artist)
      end

      it "should have one or more tracks" do
        @release.tracklist.should be_instance_of(Array)
        @release.tracklist[0].should be_instance_of(Discogs::Release::Track)
      end
 
    end

    describe "when calling complex release attributes" do

      it "should have a duration for the first track" do
        @release.tracklist[0].duration.should == "8:11"
      end

      it "should have a traversible list of styles" do
        @release.styles.should be_instance_of(Array)
        @release.styles[0].should == "Black Metal"
        @release.styles[1].should == "Thrash"
      end

      it "should have an artist associated to the second track" do
        @release.tracklist[1].artists[0].should be_instance_of(Discogs::Artist)
        @release.tracklist[1].artists[0].name.should == "Arakain"
      end

      it "should have a role associated to the first extra artist" do
        @release.extraartists[0].role.should == "Lyrics by"
      end

      it "should have no artist associated to the third track" do
        @release.tracklist[2].artists.should be_nil
      end

    end

  end

end
