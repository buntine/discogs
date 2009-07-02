require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Label do

  it "should map to empty array" do
    Discogs::Label.element_names.should == []
  end

  it "should map plural to empty array" do
    Discogs::Label.plural_element_names.should == []
  end

  ## See ./spec/wrapper_methods/get_label_spec.rb for extensive tests of this class.

end
