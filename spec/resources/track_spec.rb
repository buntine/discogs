require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Release::Track do

  it "should map to track" do
    Discogs::Release::Track.element_names.should == [ :track ]
  end

  it "should map to plural tracklist" do
    Discogs::Release::Track.plural_element_names.should == [ :tracklist ]
  end

  describe "when asking for track information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_track.xml"))
      @track = Discogs::Release::Track.new(data)
      @track.build!
    end

    it "should have a title attribute" do
      @track.title.should == "A dark forest spreads all around"
    end

    it "should have a duration attribute" do
      @track.duration.should == "7:31"
    end

    it "should have a position attribute" do
      @track.position.should == "2"
    end

    it "should have an array of artists" do
      @track.artists.should be_instance_of(Array)
    end

    it "should have an array of extra artists" do
      @track.extraartists.should be_instance_of(Array)
    end

    it "should have built each artist" do
      @track.artists[0].should be_instance_of(Discogs::Release::Track::Artist)

      @track.artists[0].name.should == "Master's Hammer"
    end
 
    it "should have built each extra artist" do
      @track.extraartists[0].should be_instance_of(Discogs::Release::Track::Artist)

      @track.extraartists[0].name.should == "Root"
      @track.extraartists[0].role.should == "Imagery"
    end

  end

end
