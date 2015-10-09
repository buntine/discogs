require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_folders" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("user_folders"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("user_folders"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)


      @user_folders = @wrapper.get_user_folders(@user_name)
    end

    describe "when calling simple folders attributes" do

      it "should have 2 folders" do
        expect(@user_folders.folders.length).to eq(2)
      end

      it "should have a name for each folder" do
        expect(@user_folders.folders[0].name).to eq("All")
        expect(@user_folders.folders[1].name).to eq("Uncategorized")
      end

      it "should not have a bogus attribute" do
      	expect(@user_folders.bogus_attribute).to be_nil
      end

    end

  end

end 
