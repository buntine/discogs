require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Search do

  it "should map to empty array" do
    Discogs::Search.element_names.should == []
  end

  it "should map plural to empty array" do
    Discogs::Search.plural_element_names.should == []
  end

  ## See ./spec/wrapper_methods/search_spec.rb for extensive tests of this class.

end
