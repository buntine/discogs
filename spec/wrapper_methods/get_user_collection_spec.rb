require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_collection" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("user_collection"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("user_collection"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)

      @user_collection = @wrapper.get_user_collection(@user_name)
    end

    describe "when calling simple collection attributes" do

      it "should have 5 releases per page" do
        expect(@user_collection.releases.length).to eq(5)
      end

      it "should have 309 releases total" do
        expect(@user_collection.pagination.items).to eq(309)
      end

      it "should not have a bogus attribute" do
        expect(@user_collection.bogus_attr).to be_nil
      end
        
    end

  end

end 
