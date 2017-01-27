require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent", :user_token => "token")
    @search_term = "Winter Falls Over the Land"
    @search_type = "release"
  end

  describe "when asking for search result information" do

    before do
      @http_request = double(Net::HTTP)
      @http_response = double(Net::HTTPResponse)

      allow(@http_response).to receive_messages(:code => "200", :body => read_sample("search_results"))

      @http_response_as_file = double(StringIO)

      allow(@http_response_as_file).to receive_messages(:read => read_sample("search_results"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@http_response_as_file)
      expect(@http_request).to receive(:start).and_return(@http_response)
      expect(Net::HTTP).to receive(:new).and_return(@http_request)

      @search = @wrapper.search(@search_term, :type => @search_type)
    end

    describe "when handling exact results" do

      it "should have the results stored as an array" do
        expect(@search.results).to be_instance_of(Hashie::Array)
      end

      it "should have a type for the first result" do
        expect(@search.results[0].type).to eq("release")
      end

      it "should have a style array for the first result" do
        expect(@search.results[0].style).to be_instance_of(Hashie::Array)
        expect(@search.results[0].style[0]).to eq("Black Metal")
      end

      it "should have a type for the fourth result" do
        expect(@search.results[3].type).to eq("release")
      end

    end

    describe "when handling search results" do

      it "should have number of results per page attribute" do
        expect(@search.pagination.per_page).to eq(50)
      end

      it "should have number of pages attribute" do
        expect(@search.pagination.pages).to eq(1)
      end

    end

  end

end
