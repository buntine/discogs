require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Label::Release do

  it "should map to release" do
    Discogs::Label::Release.element_names.should == [ :release ]
  end

  it "should map to plural releases" do
    Discogs::Label::Release.plural_element_names.should == [ :releases ]
  end

  describe "when asking for label-release information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_label_release.xml"))
      @label_release = Discogs::Label::Release.new(data)
      @label_release.build!
    end

    it "should have a ID attribute" do
      @label_release.id.should == "116322"
    end

    it "should have a status attribute" do
      @label_release.status.should == "Accepted"
    end

    it "should have a catno attribute" do
      @label_release.catno.should == "SMB09"
    end

    it "should have an artist attribute" do
      @label_release.artist.should == "Morrior"
    end

    it "should have a title attribute" do
      @label_release.title.should == "Death Metal Session"
    end

    it "should have a format attribute" do
      @label_release.format.should == "12\""
    end
 
    it "should have a year attribute" do
      @label_release.year.should == "1991"
    end
 
    it "should have a trackinfo attribute" do
      @label_release.trackinfo.should == "Side A, track 4"
    end
 
  end

end
