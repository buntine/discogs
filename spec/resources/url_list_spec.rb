require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::URLList do

  it "should map to urls" do
    Discogs::URLList.element_names.should == [ :urls ]
  end

  it "should map to plural urls" do
    Discogs::URLList.plural_element_names.should == [ :urls ]
  end

  describe "when asking for list information" do

    before do
      data = File.read(File.join(File.dirname(__FILE__), "..", "samples", "valid_url_list.xml"))
      @urls = Discogs::URLList.new(data)
    end

    it "should return an array on build" do
      @urls.build!.should be_instance_of(Array)
    end

    it "should have access to the urls after build" do
      @urls.build!

      @urls[0].should == "http://www.someband.com"
      @urls[1].should == "http://www.mypage.com/~crazy/fanpage.html"
    end

    it "should return nil on unknown index" do
      @urls[9].should be_nil
    end
 
  end

end
