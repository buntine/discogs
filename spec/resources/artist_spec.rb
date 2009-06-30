require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Artist do

  it "should map to artist" do
    Discogs::Artist.element_names.should == [ :artist ]
  end

  it "should map to plural artists" do
    Discogs::Artist.plural_element_names.should == [ :artists ]
  end

  ## See ./spec/wrapper_methods/get_artist_spec.rb for extensive tests of this class.

end
