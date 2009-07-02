require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Artist do

  it "should map to empty array" do
    Discogs::Artist.element_names.should == []
  end

  it "should map plural to empty array" do
    Discogs::Artist.plural_element_names.should == []
  end

  ## See ./spec/wrapper_methods/get_artist_spec.rb for extensive tests of this class.

end
