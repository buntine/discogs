require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @release_id = "666666"
  end

  describe "when asking for release information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_release_xml)
      @http_response_as_file = mock(StringIO, :read => valid_release_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @release = @wrapper.get_release(@release_id)
    end

    describe "when calling simple release attributes" do

      it "should have a title attribute" do
        @release.title.should == "Into the Abyss"
      end
  
      it "should have an ID attribute" do
        @release.id.should == "666666"
      end

      it "should have a master_id attribute" do
        @release.master_id.should == "6111"
      end

      it "should have one or more extra artists" do
        @release.extraartists.should be_instance_of(Array)
        @release.extraartists[0].should be_instance_of(Discogs::Release::Artist)
      end

      it "should have one or more tracks" do
        @release.tracklist.should be_instance_of(Array)
        @release.tracklist[0].should be_instance_of(Discogs::Release::Track)
      end
 
      it "should have one or more genres" do
        @release.genres.should be_instance_of(Array)
        @release.genres[0].should == "Heavy Metal"
      end

      it "should have one or more formats" do
        @release.formats.should be_instance_of(Array)
        @release.formats[0].should be_instance_of(Discogs::Release::Format)
      end

      it "should have one or more images" do
        @release.images.should be_instance_of(Array)
        @release.images[0].should be_instance_of(Discogs::Image)
      end

      it "should have one or more videos" do
        @release.videos.should be_instance_of(Array)
        @release.videos[0].should be_instance_of(Discogs::Video)
      end


    end

    describe "when calling complex release attributes" do

      it "should have a duration for the first track" do
        @release.tracklist[0].duration.should == "8:11"
      end

      it "should have specifications for each image" do
        specs = [ [ '600', '595', 'primary' ], [ '600', '593', 'secondary' ], [ '600', '539', 'secondary' ], [ '600', '452', 'secondary' ], [ '600', '567', 'secondary' ] ]
        @release.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

      it "should have specifications for each video" do
        specs = [ [ '334', 'true', 'http://www.youtube.com/watch?v=QVdDhOnoR8k' ], [ '350', 'true', 'http://www.youtube.com/watch?v=QVdDhOnoR7k' ] ]
        @release.videos.each_with_index do |video, index|
          video.duration.should == specs[index][0]
          video.embed.should == specs[index][1]
          video.uri.should == specs[index][2]
        end
      end

      it "should have a traversible list of styles" do
        @release.styles.should be_instance_of(Array)
        @release.styles[0].should == "Black Metal"
        @release.styles[1].should == "Thrash"
      end

      it "should have a traversible list of labels" do
        @release.styles.should be_instance_of(Array)
        @release.labels[0].should be_instance_of(Discogs::Release::Label)
        @release.labels[0].catno.should == "Death9"
        @release.labels[0].name.should == "Culted"
      end

      it "should have a name and quantity for the first format" do
        @release.formats[0].name.should == "CD"
        @release.formats[0].qty.should == "1"
      end

      it "should have an array of descriptions for the first format" do
        @release.formats[0].descriptions.should be_instance_of(Array)
        @release.formats[0].descriptions[0].should == "Album"
      end

      it "should have an artist associated to the second track" do
        @release.tracklist[1].artists.should be_instance_of(Array)
        @release.tracklist[1].artists[0].should be_instance_of(Discogs::Release::Track::Artist)
        @release.tracklist[1].artists[0].name.should == "Arakain"
      end

      it "should have an extra artist associated to the second track" do
        @release.tracklist[1].extraartists.should be_instance_of(Array)
        @release.tracklist[1].extraartists[0].should be_instance_of(Discogs::Release::Track::Artist)
        @release.tracklist[1].extraartists[0].name.should == "Debustrol"
        @release.tracklist[1].extraartists[0].role.should == "Sadism"
      end

      it "should have a role associated to the first extra artist" do
        @release.extraartists[0].role.should == "Lyrics By"
      end

      it "should have no artist associated to the third track" do
        @release.tracklist[2].artists.should be_nil
      end

    end

  end

end
