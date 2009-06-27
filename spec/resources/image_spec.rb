require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Image do

  it "should map to image" do
    Discogs::Image.element_name.should == :image
  end

  it "should map to plural images" do
    Discogs::Image.plural_element_names.should == [ :images ]
  end

  describe "when asking for image information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_image.xml"))
      @image = Discogs::Image.new(data)
      @image.build!
    end

    it "should have a type attribute" do
      @image.type.should == "primary"
    end

    it "should have a width attribute" do
      @image.width.should == "600"
    end

    it "should have a height attribute" do
      @image.height.should == "595"
    end
 
    it "should have a uri attribute" do
      @image.uri.should == "http://www.discogs.com/image/R-666-1222413500.jpeg"
    end
 
    it "should have a uri150 attribute" do
      @image.uri150.should == "http://www.discogs.com/image/R-150-666-1222413500.jpeg"
    end
 
  end

end
