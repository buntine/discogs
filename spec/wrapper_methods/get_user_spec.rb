require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "abuntine"
  end

  describe ".get_user" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("user"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("user"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)

      @user = @wrapper.get_user(@user_name)
    end

    describe "when calling simple user attributes" do

      it "should have a rank" do
        expect(@user.rank).to eq(1.0)
      end

      it "should have a username" do
        expect(@user.username).to eq("abuntine")
      end

      it "should have a uri" do
        expect(@user.uri).to eq("http://www.discogs.com/user/abuntine")
      end

      it "should not have a bogus attribute" do
      	expect(@user.bogus_attribute).to be_nil
      end

    end

  end

end 
