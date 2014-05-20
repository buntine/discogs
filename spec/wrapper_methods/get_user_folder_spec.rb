require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
    @folder_id = 0
  end

  describe ".get_user_folder" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("user_folder"))
      @http_response_as_file = mock(StringIO, :read => read_sample("user_folder"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @user_folder = @wrapper.get_user_folder(@user_name, @folder_id)
    end

    describe "when calling simple folder attributes" do

      it "should have a name" do
        @user_folder.name.should == "Uncategorized"
      end

      it "should have a count" do
        @user_folder[:count].should == 20
      end

      it "should not have a bogus attribute" do
        @user_folder.bogus_attr.should be_nil
      end

      it "should raise error if attempting to list non-0 folder" do
        lambda { @wrapper.get_user_folder(@user_name, 1) }.should raise_error(Discogs::AuthenticationError)
      end

    end

  end

end 
