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

      it "should have one or more aliases" do
        @artist.aliases.should be_instance_of(Array)
        @artist.aliases[0].should == "Roooot"
      end

      it "should have one or more name variations" do
        @artist.namevariations.should be_instance_of(Array)
        @artist.namevariations[0].should == "Rootan"
      end

    end

    describe "when calling complex artist attributes" do

      it "should have a traversible list of URLs" do
        @artist.urls.should be_instance_of(Array)
        @artist.urls[0].should == ""
        @artist.urls[1].should == ""
      end

      it "should have a traversible list of images" do
        @artist.images.should be_instance_of(Array)
        @artist.images[0].should be_instance_of(Discogs::Image)
      end

      it "should have specifications for each image" do
        specs = [ [ '350', '240', 'secondary' ], [ '222', '226', 'secondary' ], [ '600', '600', 'primary' ] ]
        @artist.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

      it "should have a traversible list of releases" do
        @artist.releases.should be_instance_of(Array)
        @artist.releases[0].should be_instance_of(Discogs::Artist::Release)
      end

      it "should have an ID for the first release" do
        @artist.releases[0].id.should == "1805661"
      end

      it "should have a year for the first release" do
        @artist.releases[0].year.should == "1991"
      end

      it "should have a label for the third release" do
        @artist.releases[2].label.should == "Apollo"
      end

    end

  end

end
