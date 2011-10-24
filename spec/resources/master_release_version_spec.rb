require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::MasterRelease::Version do

  it "should map to version" do
    Discogs::MasterRelease::Version.element_names.should == [ :version ]
  end

  it "should map to plural versions" do
    Discogs::MasterRelease::Version.plural_element_names.should == [ :versions ]
  end

  describe "when asking for master-release-version information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_master_release_version.xml"))
      @version = Discogs::MasterRelease::Version.new(data)
      @version.build!
    end

    it "should have an ID attribute" do
      @version.id.should == "1025"
    end
 
    it "should have a status attribute" do
      @version.status.should == "Accepted"
    end

    it "should have a title attribute" do
      @version.title.should == "Silentintroduction"
    end
 
    it "should have a label attribute" do
      @version.label.should == "Planet E"
    end

    it "should have a catno attribute" do
      @version.catno.should == "PE65234"
    end

    it "should have a country attribute" do
      @version.country.should == "US"
    end

    it "should have a released attribute" do
      @version.released.should == "1997-11-00"
    end
 
    it "should have a thumb attribute" do
      @version.thumb.should == "http://api.discogs.com/image/R-150-1025-1316440394.jpeg"
    end

  end

end
