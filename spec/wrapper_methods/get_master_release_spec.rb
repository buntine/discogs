
require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @master_release_id = "9800"
  end

  describe ".get_master_release" do

    before do
      mock_httparty("master_release")

      @master_release = @wrapper.get_master_release(@master_release_id)
    end

    describe "when calling simple master release attributes" do

      it "should have an ID attribute" do
        expect(@master_release.id).to eq(9800)
      end

      it "should have a main_release attribute" do
        expect(@master_release.main_release).to eq(5160870)
      end

      it "should have one or more tracks" do
        expect(@master_release.tracklist).to be_instance_of(Hashie::Array)
        expect(@master_release.tracklist[0].duration).to eq("2:56")
      end
 
      it "should have one or more genres" do
        expect(@master_release.genres).to be_instance_of(Hashie::Array)
        expect(@master_release.genres[0]).to eq("Rock")
      end

      it "should have a versions_url" do
        expect(@master_release.versions_url).to match(/masters\/9800\/versions/)
      end

      it "should have one or more images" do
        expect(@master_release.images).to be_instance_of(Hashie::Array)
      end

    end

    describe "when calling complex master_release attributes" do

      it "should have specifications for each image" do
        specs = [ [ 600, 607, 'primary' ], [ 600, 604, 'secondary' ], [ 600, 598, 'secondary' ], [ 600, 601, 'secondary' ] ]
        @master_release.images.each_with_index do |image, index|
          expect(image.width).to eq(specs[index][0])
          expect(image.height).to eq(specs[index][1])
          expect(image.type).to eq(specs[index][2])
        end
      end

      it "should have a traversible list of styles" do
        expect(@master_release.styles).to be_instance_of(Hashie::Array)
        expect(@master_release.styles[0]).to eq("Prog Rock")
      end

      it "should have an extra artist associated to the second track" do
        expect(@master_release.tracklist[1].extraartists).to be_instance_of(Hashie::Array)
        expect(@master_release.tracklist[1].extraartists[0].role).to eq("Lead Vocals")
      end

    end

  end

end 
