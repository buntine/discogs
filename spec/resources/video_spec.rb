require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Video do

  it "should map to video" do
    Discogs::Video.element_names.should == [ :video ]
  end

  it "should map to plural videos" do
    Discogs::Video.plural_element_names.should == [ :videos ]
  end

  describe "when asking for video information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_video.xml"))
      @video = Discogs::Video.new(data)
      @video.build!
    end

    it "should have a duration attribute" do
      @video.duration.should == "334"
    end

    it "should have a embed attribute" do
      @video.embed.should == "true"
    end

    it "should have a description attribute" do
      @video.description.should == "The Persuader-Stockholm-Sodermalm"
    end
 
    it "should have a uri attribute" do
      @video.uri.should == "http://www.youtube.com/watch?v=QVdDhOnoR8k"
    end
 
    it "should have a title attribute" do
      @video.title.should == "The Persuader"
    end
 
  end

end
