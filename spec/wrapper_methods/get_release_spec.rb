
require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @release_id = "1"
  end

  describe ".get_release" do

    before do
      mock_httparty("release")

      @release = @wrapper.get_release(@release_id)
    end

    describe "when calling simple release attributes" do

      it "should have a title attribute" do
        expect(@release.title).to eq("Stockholm")
      end

      it "should have an ID attribute" do
        expect(@release.id).to eq(1)
      end

      it "should have a master_id attribute" do
        expect(@release.master_id).to eq(5427)
      end

      it "should have a community/rating attribute" do
        expect(@release.community.rating).to be_instance_of(Hashie::Mash)
      end

      it "should have sanitized the rating count attribute" do
        expect(@release.community.rating.total).to eq(91) 
        expect(@release.community.rating.count).to eq(2 + 1) # Original method - count returns number of key/value pairs. Plus one to be removed after backwards-compatibility fix has been removed.
      end

      it "should have one or more extra artists" do
        expect(@release.extraartists).to be_instance_of(Hashie::Array)
        expect(@release.extraartists[0].id).to eq(239)
      end

      it "should have one or more tracks" do
        expect(@release.tracklist).to be_instance_of(Hashie::Array)
        expect(@release.tracklist[0].position).to eq("A")
      end

      it "should have one or more genres" do
        expect(@release.genres).to be_instance_of(Hashie::Array)
        expect(@release.genres[0]).to eq("Electronic")
      end

      it "should have one or more formats" do
        expect(@release.formats).to be_instance_of(Hashie::Array)
        expect(@release.formats[0].name).to eq("Vinyl")
      end

      it "should have one or more images" do
        expect(@release.images).to be_instance_of(Hashie::Array)
        expect(@release.images[0].type).to eq("primary")
      end

    end

    describe "when calling complex release attributes" do

      it "should have specifications for each image" do
        specs = [ [ 600, 600, 'primary' ], [ 600, 600, 'secondary' ], [ 600, 600, 'secondary' ], [ 600, 600, 'secondary' ] ]
        @release.images.each_with_index do |image, index|
          expect(image.width).to eq(specs[index][0])
          expect(image.height).to eq(specs[index][1])
          expect(image.type).to eq(specs[index][2])
        end
      end

      it "should have specifications for each video" do
        specs = [ [ 380, true, 'http://www.youtube.com/watch?v=5rA8CTKKEP4' ], [ 335, true, 'http://www.youtube.com/watch?v=QVdDhOnoR8k' ],
                  [ 290, true, 'http://www.youtube.com/watch?v=AHuQWcylaU4' ], [ 175, true, 'http://www.youtube.com/watch?v=sLZvvJVir5g' ],
                  [ 324, true, 'http://www.youtube.com/watch?v=js_g1qtPmL0' ], [ 289, true, 'http://www.youtube.com/watch?v=hy47qgyJeG0' ] ]
        @release.videos.each_with_index do |video, index|
          expect(video.duration).to eq(specs[index][0])
          expect(video.embed).to eq(specs[index][1])
          expect(video.uri).to eq(specs[index][2])
        end
      end

      it "should have a traversible list of styles" do
        expect(@release.styles).to be_instance_of(Hashie::Array)
        expect(@release.styles[0]).to eq("Deep House")
      end

      it "should have a traversible list of labels" do
        expect(@release.styles).to be_instance_of(Hashie::Array)
        expect(@release.labels[0].catno).to eq("SK032")
        expect(@release.labels[0].name).to eq("Svek")
      end

      it "should have a name and quantity for the first format" do
        expect(@release.formats).to be_instance_of(Hashie::Array)
        expect(@release.formats[0].name).to eq("Vinyl")
        expect(@release.formats[0].qty).to eq("2")
      end

      it "should have a role associated to the first extra artist" do
        expect(@release.extraartists[0].role).to eq("Music By [All Tracks By]")
      end

      it "should have no artist associated to the third track" do
        expect(@release.tracklist[2].artists).to be_nil
      end

    end

  end

end
