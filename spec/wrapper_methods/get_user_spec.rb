require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "abuntine"
  end

  describe ".get_user" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("user"))
      @http_response_as_file = mock(StringIO, :read => read_sample("user"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @user = @wrapper.get_user(@user_name)
    end

    describe "when calling simple user attributes" do

      it "should have a rank" do
        @user.rank.should == 1.0
      end

      it "should have a username" do
        @user.username.should == "abuntine"
      end

      it "should have a uri" do
        @user.uri.should == "http://www.discogs.com/user/abuntine"
      end

      it "should not have a bogus attribute" do
      	@user.bogus_attribute.should be_nil
      end

    end

  end

end 
