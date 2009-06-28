require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Release::GenreList do

  it "should map to genres" do
    Discogs::Release::GenreList.element_name.should == :genres
  end

  it "should map to plural genres" do
    Discogs::Release::GenreList.plural_element_names.should == [ :genres ]
  end

  describe "when asking for list information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_genre_list.xml"))
      @genres = Discogs::Release::GenreList.new(data)
    end

    it "should return an array on build" do
      @genres.build!.should be_instance_of(Array)
    end

    it "should have access to the genres after build" do
      @genres.build!

      @genres[0].should == "Heavy Metal"
      @genres[1].should == "Neofolk"
      @genres[2].should == "Medieval folk"
    end

    it "should return nil on unknown index" do
      @genres[9].should be_nil
    end
 
  end

end
