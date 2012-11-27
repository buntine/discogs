require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @artist_name = "Root"
  end

  describe "when asking for artist information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_artist_xml)
      @http_response_as_file = mock(StringIO, :read => valid_artist_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
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

      it "should have one or more members" do
        @artist.members.should be_instance_of(Array)
        @artist.members[0].should == "Big Boss"
      end

      it "should be able to filter non-main releases" do
        @artist.main_releases.should be_instance_of(Array)
        @artist.main_releases.length.should == 4
      end

      it "should be able to filter non-bootleg releases" do
        @artist.bootlegs.should be_instance_of(Array)
        @artist.bootlegs.length.should == 1
      end

      it "should be able to filter non-main releases" do
        @artist.appearances.should be_instance_of(Array)
        @artist.appearances.length.should == 1
      end

    end

    describe "when calling complex artist attributes" do

      it "should have a traversible list of URLs" do
        @artist.urls.should be_instance_of(Array)
        @artist.urls[0].should == "http://www.root.net"
        @artist.urls[1].should == "http://www.rootan.com"
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
        @artist.releases.length.should == 6
        @artist.releases[0].should be_instance_of(Discogs::Artist::Release)
      end

      it "should have an ID for the first release" do
        @artist.releases[0].id.should == "1805661"
      end

      it "should have a type for the first release" do
        @artist.releases[0].release_type.should == "release"
      end

      it "should have a type for the second release" do
        @artist.releases[1].release_type.should == "master"
      end

      it "should have a main release for the second release" do
        @artist.releases[1].main_release.should == "12345"
      end

      it "should have a thumb for the second release" do
        @artist.releases[1].thumb.should == "http://images"
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
