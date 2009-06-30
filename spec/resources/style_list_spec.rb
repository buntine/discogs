require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Release::StyleList do

  it "should map to styles" do
    Discogs::Release::StyleList.element_names.should == [ :styles ]
  end

  it "should map to plural styles" do
    Discogs::Release::StyleList.plural_element_names.should == [ :styles ]
  end

  describe "when asking for list information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_style_list.xml"))
      @styles = Discogs::Release::StyleList.new(data)
    end

    it "should return an array on build" do
      @styles.build!.should be_instance_of(Array)
    end

    it "should have access to the styles after build" do
      @styles.build!

      @styles[0].should == "Death Metal"
      @styles[1].should == "Thrash"
    end

    it "should return nil on unknown index" do
      @styles[9].should be_nil
    end
 
  end

end
