require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @label_id = "9800"
  end

  describe ".get_labels_releases" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("label_releases"))
      @http_response_as_file = mock(StringIO, :read => read_sample("label_releases"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @label_releases = @wrapper.get_label_releases(@label_id)
    end

    describe "when calling simple releases attributes" do

      it "should have 8 releases per page" do
        @label_releases.releases.length.should == 8
      end

      it "should have 8 releases total" do
        @label_releases.pagination.items.should == 8
      end

      it "should have a first release with a Cat No" do
        @label_releases.releases.first.catno.should == "SSS 001"
      end

      it "should have a first release with a status" do
        @label_releases.releases.first.status.should == "Accepted"
      end

      it "should not have a bogus attribute" do
      	@label_releases.bogus_attribute.should be_nil
      end

    end

  end

end 
