require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::DescriptionList do

  it "should map to descriptions" do
    Discogs::DescriptionList.element_names.should == [ :descriptions ]
  end

  it "should map to plural descriptions" do
    Discogs::DescriptionList.plural_element_names.should == [ :descriptions ]
  end

  describe "when asking for list information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_description_list.xml"))
      @descriptions = Discogs::DescriptionList.new(data)
    end

    it "should return an array on build" do
      @descriptions.build!.should be_instance_of(Array)
    end

    it "should have access to the descriptions after build" do
      @descriptions.build!

      @descriptions[0].should == "Album"
      @descriptions[1].should == "LP"
      @descriptions[2].should == "33 rpm"
    end

    it "should return nil on unknown index" do
      @descriptions[9].should be_nil
    end
 
  end

end
