require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Artist::AliasList do

  it "should map to aliases" do
    Discogs::Artist::AliasList.element_names.should == [ :aliases ]
  end

  it "should map to plural aliases" do
    Discogs::Artist::AliasList.plural_element_names.should == [ :aliases ]
  end

  describe "when asking for list information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_alias_list.xml"))
      @aliases = Discogs::Artist::AliasList.new(data)
    end

    it "should return an array on build" do
      @aliases.build!.should be_instance_of(Array)
    end

    it "should have access to the aliases after build" do
      @aliases.build!

      @aliases[0].should == "Bunts"
      @aliases[1].should == "Buntzdoom"
      @aliases[2].should == "The cripwalker previously known as Baby Kakes"
    end

    it "should return nil on unknown index" do
      @aliases[9].should be_nil
    end
 
  end

end
