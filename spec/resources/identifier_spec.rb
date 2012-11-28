require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Release::Format do

  it "should map to identifier" do
    Discogs::Release::Identifier.element_names.should == [ :identifier ]
  end

  it "should map to plural formats" do
    Discogs::Release::Identifier.plural_element_names.should == [ :identifiers ]
  end

  describe "when asking for format information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_identifier.xml"))
      @identifier = Discogs::Release::Identifier.new(data)
      @identifier.build!
    end

    it "should have a type attribute" do
      @identifier.type.should == "Barcode"
    end

    it "should have a value attribute" do
      @identifier.value.should == "827170385962"
    end

    it "should have an description attribute" do
      @identifier.description.should == "Runout Side A"
    end


  end

end
