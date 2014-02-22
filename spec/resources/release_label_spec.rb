require 'spec_helper'

describe Discogs::Release::Label do

  it "should map to label" do
    Discogs::Release::Label.element_names.should == [ :label ]
  end

  it "should map to plural labels" do
    Discogs::Release::Label.plural_element_names.should == [ :labels ]
  end

  describe "when asking for release-label information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_release_label.xml"))
      @release_label = Discogs::Release::Label.new(data)
      @release_label.build!
    end

    it "should have a name attribute" do
      @release_label.name.should == "Toxic Diffusion"
    end

    it "should have a catno attribute" do
      @release_label.catno.should == "clp89"
    end
 
  end

end
