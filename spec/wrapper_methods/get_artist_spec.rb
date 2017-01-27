require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @artist_id = 313929 # Cirith Ungol
  end

  describe ".get_artist" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("artist"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("artist"))

      allow(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      allow(@http_request).to receive(:start).and_return(@http_response)
      allow(Net::HTTP).to receive(:new).and_return(@http_request)

      @artist = @wrapper.get_artist(@artist_id)
    end

    describe "when calling simple artist attributes" do

      it "should have a name attribute" do
        @artist.name.should == "Cirith Ungol"
      end

      it "should have an id attribute" do
        @artist.id.should == @artist_id
      end
  
      it "should have a profile attribute" do
        @artist.profile[0..15].should == "Heavy metal band"
      end

      it "should have a data_quality attribute" do
        @artist.data_quality.should == "Correct"
      end

      it "should have one or more members" do
        @artist.members.should be_instance_of(Hashie::Array)
        @artist.members[0].name.should == "Greg Lindstrom"
      end

      it "should have a releases_url attribute" do
        @artist.releases_url.should =~ /artists\/313929\/releases/
      end

    end

    describe "when calling complex artist attributes" do

      it "should have a traversible list of URLs" do
        @artist.urls.should be_instance_of(Hashie::Array)
        @artist.urls[0].should == "http://www.truemetal.org/cirithungol"
        @artist.urls[1].should == "http://www.myspace.com/cirithungol"
      end

      it "should have a traversible list of images" do
        @artist.images.should be_instance_of(Hashie::Array)
      end

      it "should have specifications for each image" do
        specs = [ [ 360, 288, 'secondary' ], [ 170, 176, 'secondary' ] ]
        @artist.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

    end

  end

end
