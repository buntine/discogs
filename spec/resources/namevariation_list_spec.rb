require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Artist::NameVariationList do

  it "should map to namevariations" do
    Discogs::Artist::NameVariationList.element_name.should == :namevariations
  end

  it "should map to plural namevariations" do
    Discogs::Artist::NameVariationList.plural_element_names.should == [ :namevariations ]
  end

  describe "when asking for list information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_namevariation_list.xml"))
      @namevariations = Discogs::Artist::NameVariationList.new(data)
    end

    it "should return an array on build" do
      @namevariations.build!.should be_instance_of(Array)
    end

    it "should have access to the name variations after build" do
      @namevariations.build!

      @namevariations[0].should == "Andre"
      @namevariations[1].should == "Andy"
      @namevariations[2].should == "Anda Loodle Pop"
    end

    it "should return nil on unknown index" do
      @namevariations[9].should be_nil
    end
 
  end

end
