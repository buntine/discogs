require 'spec_helper'

describe Discogs::MasterRelease do

  it "should map to empty array" do
    Discogs::Release.element_names.should == []
  end

  it "should map plural to empty array" do
    Discogs::Release.plural_element_names.should == []
  end

  ## See ./spec/wrapper_methods/get_master_release_spec.rb for extensive tests of this class.

end
