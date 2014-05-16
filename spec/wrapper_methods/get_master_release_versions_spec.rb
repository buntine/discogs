require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @master_id = "9800"
  end

  describe ".get_master_release_versions" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_master_release_versions_json)
      @http_response_as_file = mock(StringIO, :read => valid_master_release_versions_json)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @master_versions = @wrapper.get_master_release_versions(@master_id)
    end

    describe "when calling simple master release versions attributes" do

      it "should have 3 versions per page" do
        @master_versions.versions.length.should == 3
      end

      it "should have 3 versions total" do
        @master_versions.pagination.items.should == 3
      end

      it "should have a first version with a label" do
        @master_versions.versions.first.label.should == "Panton"
      end

      it "should have a first release with a released field" do
        @master_versions.versions.first.released.should == "1982"
      end

      it "should not have a bogus attribute" do
      	@master_versions.bogus_attribute.should be_nil
      end

    end

  end

end 
