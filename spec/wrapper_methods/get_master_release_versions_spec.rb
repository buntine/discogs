require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @master_id = "9800"
  end

  describe ".get_master_release_versions" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("master_release_versions"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("master_release_versions"))

      allow(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      allow(@http_request).to receive(:start).and_return(@http_response)
      allow(Net::HTTP).to receive(:new).and_return(@http_request)

      @master_versions = @wrapper.get_master_release_versions(@master_id)
    end

    describe "when calling simple master release versions attributes" do

      it "should have 3 versions per page" do
        expect(@master_versions.versions.length).to eq(3)
      end

      it "should have 3 versions total" do
        expect(@master_versions.pagination.items).to eq(3)
      end

      it "should have a first version with a label" do
        expect(@master_versions.versions.first.label).to eq("Panton")
      end

      it "should have a first release with a released field" do
        expect(@master_versions.versions.first.released).to eq("1982")
      end

      it "should not have a bogus attribute" do
        expect(@master_versions.bogus_attribute).to be_nil
      end

    end

  end

end 
