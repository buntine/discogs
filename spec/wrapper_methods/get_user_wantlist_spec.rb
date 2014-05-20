require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_wantlist" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("user_wantlist"))
      @http_response_as_file = mock(StringIO, :read => read_sample("user_wantlist"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @user_wantlist = @wrapper.get_user_wantlist(@user_name)
    end

    describe "when calling simple wantlist attributes" do

      it "should have 5 wants per page" do
        @user_wantlist.wants.length.should == 5
      end

      it "should have 77 wants total" do
        @user_wantlist.pagination.items.should == 77
      end

      it "should have a want with a zero rating" do
        @user_wantlist.wants.first.rating.should == 0
      end

      it "should have a want with some basic information" do
        @user_wantlist.wants.first.basic_information.title.should == "18 Jahre Sein / Mach Keine Wellen"
      end

      it "should not have a bogus attribute" do
        @user_wantlist.bogus_attr.should be_nil
      end

    end

  end

end 
