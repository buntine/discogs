require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Search::Result do

  it "should map to result" do
    Discogs::Search::Result.element_names.should == [ :result ]
  end

  it "should map to plural exactresults and searchresults" do
    Discogs::Search::Result.plural_element_names.should == [ :exactresults, :searchresults ]
  end

  describe "when asking for search result information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_search_result.xml"))
      @search_result = Discogs::Search::Result.new(data)
      @search_result.build!
    end

    it "should have a number attribute" do
      @search_result.num.should == "2"
    end

    it "should have a type attribute" do
      @search_result.type.should == "artist"
    end

    it "should have a title attribute" do
      @search_result.title.should == "Karin Slaughter"
    end

    it "should have a uri attribute" do
      @search_result.uri.should == "http://www.discogs.com/artist/Karin+Slaughter"
    end

    it "should have a summary attribute" do
      @search_result.summary.should == "Karin Slaughter Karin Slaughter"
    end

    it "should have a anv attribute" do
      @search_result.anv.should == "Slaughter"
    end

  end

end
