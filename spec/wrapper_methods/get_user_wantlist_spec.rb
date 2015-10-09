require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_wantlist" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("user_wantlist"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("user_wantlist"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)

      @user_wantlist = @wrapper.get_user_wantlist(@user_name)
    end

    describe "when calling simple wantlist attributes" do

      it "should have 5 wants per page" do
        expect(@user_wantlist.wants.length).to eq(5)
      end

      it "should have 77 wants total" do
        expect(@user_wantlist.pagination.items).to eq(77)
      end

      it "should have a want with a zero rating" do
        expect(@user_wantlist.wants.first.rating).to eq(0)
      end

      it "should have a want with some basic information" do
        expect(@user_wantlist.wants.first.basic_information.title).to eq("18 Jahre Sein / Mach Keine Wellen")
      end

      it "should not have a bogus attribute" do
        expect(@user_wantlist.bogus_attr).to be_nil
      end

    end

  end

end 
