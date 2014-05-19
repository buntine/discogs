require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_folders" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("user_folders"))
      @http_response_as_file = mock(StringIO, :read => read_sample("user_folders"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @user_folders = @wrapper.get_user_folders(@user_name)
    end

    describe "when calling simple folders attributes" do

      it "should have 2 folders" do
        @user_folders.folders.length.should == 2
      end

      it "should have a name for each folder" do
        @user_folders.folders[0].name.should == "All"
        @user_folders.folders[1].name.should == "Uncategorized"
      end

      it "should not have a bogus attribute" do
      	@user_folders.bogus_attribute.should be_nil
      end

    end

  end

end 
