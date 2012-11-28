require 'spec_helper'

describe Discogs::Release::Format do

  it "should map to format" do
    Discogs::Release::Format.element_names.should == [ :format ]
  end

  it "should map to plural formats" do
    Discogs::Release::Format.plural_element_names.should == [ :formats ]
  end

  describe "when asking for format information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_format.xml"))
      @format = Discogs::Release::Format.new(data)
      @format.build!
    end

    it "should have a name attribute" do
      @format.name.should == "CD"
    end

    it "should have a quantity attribute" do
      @format.qty.should == "1"
    end

    it "should have an array of descriptions" do
      @format.descriptions.should be_instance_of(Array)
    end

    it "should have built each description" do
      @format.descriptions[0].should == "Album"
      @format.descriptions[1].should == "Digipak"
      @format.descriptions[9].should be_nil
    end

  end

end
