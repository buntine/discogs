require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "abuntine"
  end

  describe ".get_user_inventory" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("user_inventory"))
      @http_response_as_file = mock(StringIO, :read => read_sample("user_inventory"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @user_inventory = @wrapper.get_user_inventory(@user_name)
    end

    describe "when calling simple inventory attributes" do

      it "should have 1 listing in total" do
        @user_inventory.listings.length.should == 1
      end

      it "should have a For Sale listing" do
        @user_inventory.listings[0].status.should == "For Sale"
      end

      it "should have a price for the first listing" do
        @user_inventory.listings[0].price.value.should == 23.0
      end

      it "should not have a bogus attribute" do
        @user_inventory.bogus_attr.should be_nil
      end
        
    end

  end

end 
