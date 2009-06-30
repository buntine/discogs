require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::GenericList do

  it "should map to all generic lists" do
    Discogs::GenericList.element_names.should be_instance_of(Array)

    Discogs::GenericList.element_names.include?(:aliases).should be_true
    Discogs::GenericList.element_names.include?(:urls).should be_true
  end

  it "should map to plural lists" do
    Discogs::GenericList.plural_element_names.should == [ :lists ]
  end

  describe "when asking for description information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_description_list.xml"))
      @descriptions = Discogs::GenericList.new(data)
    end

    it "should return an array on build" do
      @descriptions.build!.should be_instance_of(Array)
    end

    it "should have access to the items after build" do
      @descriptions.build!

      @descriptions[0].should == "Album"
      @descriptions[1].should == "LP"
      @descriptions[2].should == "33 rpm"
    end

    it "should return nil on unknown index" do
      @descriptions[9].should be_nil
    end
 
  end

  describe "when asking for genre information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_genre_list.xml"))
      @genres = Discogs::GenericList.new(data)
    end

    it "should return an array on build" do
      @genres.build!.should be_instance_of(Array)
    end

    it "should have access to the items after build" do
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
