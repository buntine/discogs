require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @label_id = "9800"
  end

  describe ".get_labels_releases" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)
      
      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("label_releases"))

      @http_response_as_file = double(StringIO)
      
      allow(@http_response_as_file).to receive_messages(:read => read_sample("label_releases"))

      allow(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      allow(@http_request).to receive(:start).and_return(@http_response)
      allow(Net::HTTP).to receive(:new).and_return(@http_request)

      @label_releases = @wrapper.get_label_releases(@label_id)
    end

    describe "when calling simple releases attributes" do

      it "should have 8 releases per page" do
        expect(@label_releases.releases.length).to eq(8)
      end

      it "should have 8 releases total" do
        expect(@label_releases.pagination.items).to eq(8)
      end

      it "should have a first release with a Cat No" do
        expect(@label_releases.releases.first.catno).to eq("SSS 001")
      end

      it "should have a first release with a status" do
        expect(@label_releases.releases.first.status).to eq("Accepted")
      end

      it "should not have a bogus attribute" do
        expect(@label_releases.bogus_attribute).to be_nil
      end

    end

  end

end 
