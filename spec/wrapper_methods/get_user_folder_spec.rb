require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
    @folder_id = 0
  end

  describe ".get_user_folder" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("user_folder"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("user_folder"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)

      @user_folder = @wrapper.get_user_folder(@user_name, @folder_id)
    end

    describe "when calling simple folder attributes" do

      it "should have a name" do
        expect(@user_folder.name).to eq("Uncategorized")
      end

      it "should have a count" do
        expect(@user_folder[:count]).to eq(20)
      end

      it "should not have a bogus attribute" do
        expect(@user_folder.bogus_attr).to be_nil
      end

      it "should raise error if attempting to list non-0 folder" do
        expect(lambda { @wrapper.get_user_folder(@user_name, 1) }).to raise_error(Discogs::AuthenticationError)
      end

    end

  end

end 
