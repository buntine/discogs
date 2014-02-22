require 'spec_helper'

describe Discogs::Release::Artist do

  it "should map to artist" do
    Discogs::Release::Artist.element_names.should == [ :artist ]
  end

  it "should map to plural artists and extraartists" do
    Discogs::Release::Artist.plural_element_names.should == [ :artists, :extraartists ]
  end

  describe "when asking for release-artist information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_release_artist.xml"))
      @release_artist = Discogs::Release::Artist.new(data)
      @release_artist.build!
    end

    it "should have a name attribute" do
      @release_artist.name.should == "Master's Hammer"
    end

    it "should have a role attribute" do
      @release_artist.role.should == "Shrieks"
    end

    it "should have a join attribute" do
      @release_artist.join.should == "Relatives"
    end

    it "should have an anv attribute" do
      @release_artist.anv.should == "wtf?"
    end

    it "should have a tracks attribute" do
      @release_artist.tracks.should == "1,2,4"
    end
 
  end

end
