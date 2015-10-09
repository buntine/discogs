require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "abuntine"
  end

  describe ".get_user_inventory" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("user_inventory"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("user_inventory"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)

      @user_inventory = @wrapper.get_user_inventory(@user_name)
    end

    describe "when calling simple inventory attributes" do

      it "should have 1 listing in total" do
        expect(@user_inventory.listings.length).to eq(1)
      end

      it "should have a For Sale listing" do
        expect(@user_inventory.listings[0].status).to eq("For Sale")
      end

      it "should have a price for the first listing" do
        expect(@user_inventory.listings[0].price.value).to eq(23.0)
      end

      it "should not have a bogus attribute" do
        expect(@user_inventory.bogus_attr).to be_nil
      end
        
    end

  end

end 
