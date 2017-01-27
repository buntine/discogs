require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @artist_id = "313929"
  end

  describe ".get_artists_releases" do

    before do
      mock_httparty("artist_releases")

      @artist_releases = @wrapper.get_artist_releases(@artist_id)
    end

    describe "when calling simple releases attributes" do

      it "should have 37 releases per page" do
        expect(@artist_releases.releases.length).to eq(37)
      end

      it "should have 37 releases total" do
        expect(@artist_releases.pagination.items).to eq(37)
      end

      it "should have a first release with a title" do
        expect(@artist_releases.releases.first.title).to eq("Frost And Fire")
      end

      it "should have a first release with a type" do
        expect(@artist_releases.releases.first.type).to eq("master")
      end

      it "should not have a bogus attribute" do
        expect(@artist_releases.bogus_attr).to be_nil
      end

    end

  end

end 
