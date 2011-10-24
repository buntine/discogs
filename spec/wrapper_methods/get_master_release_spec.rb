require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @master_release_id = "666666"
  end

  describe "when asking for master_release information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_master_release_xml)
      @http_response_as_file = mock(StringIO, :read => valid_master_release_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @master_release = @wrapper.get_master_release(@master_release_id)
    end

    describe "when calling simple master_release attributes" do

      it "should have an ID attribute" do
        @master_release.id.should == "6119"
      end

      it "should have a main_release attribute" do
        @master_release.main_release.should == "1025"
      end

      it "should have one or more tracks" do
        @master_release.tracklist.should be_instance_of(Array)
        @master_release.tracklist[0].should be_instance_of(Discogs::MasterRelease::Track)
      end
 
      it "should have one or more genres" do
        @master_release.genres.should be_instance_of(Array)
        @master_release.genres[0].should == "Electronic"
      end

      it "should have one or more versions" do
        @master_release.versions.should be_instance_of(Array)
        @master_release.versions[0].should be_instance_of(Discogs::MasterRelease::Version)
      end

      it "should have one or more images" do
        @master_release.images.should be_instance_of(Array)
        @master_release.images[0].should be_instance_of(Discogs::Image)
      end

    end

    describe "when calling complex master_release attributes" do

      it "should have a duration for the first track" do
        @master_release.tracklist[0].duration.should == "4:42"
      end

      it "should have specifications for each image" do
        specs = [ [ '600', '590', 'primary' ], [ '600', '594', 'secondary' ], [ '600', '297', 'secondary' ], [ '600', '601', 'secondary' ], [ '600', '600', 'secondary' ] ]
        @master_release.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

      it "should have attributes for each version" do
        specs = [ [ '1025', 'US', '2x12", Album' ], [ '4179', 'US', 'CD, Album' ], [ '416774', 'US', '12"' ] ]
        @master_release.versions.each_with_index do |version, index|
          version.id.should == specs[index][0]
          version.country.should == specs[index][1]
          version.format.should == specs[index][2]
        end
      end

      it "should have a traversible list of styles" do
        @master_release.styles.should be_instance_of(Array)
        @master_release.styles[0].should == "Deep House"
      end

      it "should have an artist associated to the second track" do
        @master_release.tracklist[1].artists.should be_instance_of(Array)
        @master_release.tracklist[1].artists[0].should be_instance_of(Discogs::MasterRelease::Track::Artist)
        @master_release.tracklist[1].artists[0].name.should == "Arakain"
      end

      it "should have an extra artist associated to the second track" do
        @master_release.tracklist[1].extraartists.should be_instance_of(Array)
        @master_release.tracklist[1].extraartists[0].should be_instance_of(Discogs::MasterRelease::Track::Artist)
        @master_release.tracklist[1].extraartists[0].name.should == "Debustrol"
        @master_release.tracklist[1].extraartists[0].role.should == "Sadism"
      end

      it "should have no artist associated to the third track" do
        @master_release.tracklist[2].artists.should be_nil
      end

    end

  end

end
