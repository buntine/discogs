require 'spec_helper'

describe Discogs::Release do

  it "should map to empty array" do
    Discogs::Release.element_names.should == []
  end

  it "should map plural to empty array" do
    Discogs::Release.plural_element_names.should == []
  end

  ## See ./spec/wrapper_methods/get_release_spec.rb for extensive tests of this class.

end
