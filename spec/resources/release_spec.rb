require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Release do

  it "should map to release" do
    Discogs::Release.element_name.should == :release
  end

  it "should map to plural releases" do
    Discogs::Release.plural_element_names.should == [ :releases ]
  end

end
