
require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @master_release_id = "9800"
  end

  describe ".get_master_release" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("master_release"))
      @http_response_as_file = mock(StringIO, :read => read_sample("master_release"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @master_release = @wrapper.get_master_release(@master_release_id)
    end

    describe "when calling simple master release attributes" do

      it "should have an ID attribute" do
        @master_release.id.should == 9800
      end

      it "should have a main_release attribute" do
        @master_release.main_release.should == 5160870
      end

      it "should have one or more tracks" do
        @master_release.tracklist.should be_instance_of(Array)
        @master_release.tracklist[0].duration.should == "2:56"
      end
 
      it "should have one or more genres" do
        @master_release.genres.should be_instance_of(Array)
        @master_release.genres[0].should == "Rock"
      end

      it "should have a versions_url" do
        @master_release.versions_url.should =~ /masters\/9800\/versions/
      end

      it "should have one or more images" do
        @master_release.images.should be_instance_of(Array)
      end

    end

    describe "when calling complex master_release attributes" do

      it "should have specifications for each image" do
        specs = [ [ 600, 607, 'primary' ], [ 600, 604, 'secondary' ], [ 600, 598, 'secondary' ], [ 600, 601, 'secondary' ] ]
        @master_release.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

      it "should have a traversible list of styles" do
        @master_release.styles.should be_instance_of(Array)
        @master_release.styles[0].should == "Prog Rock"
      end

      it "should have an extra artist associated to the second track" do
        @master_release.tracklist[1].extraartists.should be_instance_of(Array)
        @master_release.tracklist[1].extraartists[0].role.should == "Lead Vocals"
      end

    end

  end

end 
