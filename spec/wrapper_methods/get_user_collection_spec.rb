require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_collection" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_user_collection_json)
      @http_response_as_file = mock(StringIO, :read => valid_user_collection_json)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @user_collection = @wrapper.get_user_collection(@user_name)
    end

    describe "when calling simple collection attributes" do

      it "should have a 50 releases per page" do
        @user_collection.releases.length == 50
      end

  	end

  end

end 
