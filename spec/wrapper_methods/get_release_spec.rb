
require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @release_id = "1"
  end

  describe ".get_release" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("release"))
      @http_response_as_file = mock(StringIO, :read => read_sample("release"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @release = @wrapper.get_release(@release_id)
    end

    describe "when calling simple release attributes" do

      it "should have a title attribute" do
        @release.title.should == "Stockholm"
      end
  
      it "should have an ID attribute" do
        @release.id.should == 1
      end

      it "should have a master_id attribute" do
        @release.master_id.should == 5427
      end

      it "should have one or more extra artists" do
        @release.extraartists.should be_instance_of(Array)
        @release.extraartists[0].id.should == 239
      end

      it "should have one or more tracks" do
        @release.tracklist.should be_instance_of(Array)
        @release.tracklist[0].position.should == "A"
      end
 
      it "should have one or more genres" do
        @release.genres.should be_instance_of(Array)
        @release.genres[0].should == "Electronic"
      end

      it "should have one or more formats" do
        @release.formats.should be_instance_of(Array)
        @release.formats[0].name.should == "Vinyl"
      end

      it "should have one or more images" do
        @release.images.should be_instance_of(Array)
        @release.images[0].type.should == "primary"
      end

    end

    describe "when calling complex release attributes" do

      it "should have specifications for each image" do
        specs = [ [ 600, 600, 'primary' ], [ 600, 600, 'secondary' ], [ 600, 600, 'secondary' ], [ 600, 600, 'secondary' ] ]
        @release.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

      it "should have specifications for each video" do
        specs = [ [ 380, true, 'http://www.youtube.com/watch?v=5rA8CTKKEP4' ], [ 335, true, 'http://www.youtube.com/watch?v=QVdDhOnoR8k' ],
                  [ 290, true, 'http://www.youtube.com/watch?v=AHuQWcylaU4' ], [ 175, true, 'http://www.youtube.com/watch?v=sLZvvJVir5g' ],
                  [ 324, true, 'http://www.youtube.com/watch?v=js_g1qtPmL0' ], [ 289, true, 'http://www.youtube.com/watch?v=hy47qgyJeG0' ] ]
        @release.videos.each_with_index do |video, index|
          video.duration.should == specs[index][0]
          video.embed.should == specs[index][1]
          video.uri.should == specs[index][2]
        end
      end

      it "should have a traversible list of styles" do
        @release.styles.should be_instance_of(Array)
        @release.styles[0].should == "Deep House"
      end

      it "should have a traversible list of labels" do
        @release.styles.should be_instance_of(Array)
        @release.labels[0].catno.should == "SK032"
        @release.labels[0].name.should == "Svek"
      end

      it "should have a name and quantity for the first format" do
        @release.formats.should be_instance_of(Array)
        @release.formats[0].name.should == "Vinyl"
        @release.formats[0].qty.should == "2"
      end

      it "should have a role associated to the first extra artist" do
        @release.extraartists[0].role.should == "Music By [All Tracks By]"
      end

      it "should have no artist associated to the third track" do
        @release.tracklist[2].artists.should be_nil
      end

    end

  end

end 
