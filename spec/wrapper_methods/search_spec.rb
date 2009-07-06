require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_key")
    @search_term = "slaughter"
  end

  describe "when asking for search result information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_search_xml)
      @http_response_as_file = mock(StringIO, :read => valid_search_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_session = mock("HTTP Session")
      @http_session.should_receive(:request).and_return(@http_response)
      @http_request.should_receive(:start).and_yield(@http_session)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @search = @wrapper.search(@search_term)
    end

    describe "when handling exact results" do

      it "should have the exact results stored as an array" do
        @search.exactresults.should be_instance_of(Array)
      end

      it "should be stored as result objects" do
        @search.exactresults.each do |result|
          result.should be_instance_of(Discogs::Search::Result)
        end
      end

      it "should have a incrementing num for each exact result" do
        @search.exactresults.each_with_index do |result, index|
          result.num.should == (index + 1).to_s
        end
      end

      it "should have a type for the first result" do
        @search.exactresults[0].type.should == "artist"
      end

      it "should have an anv for the fifth result" do
        @search.exactresults[5].anv.should == "Slaughter"
      end

    end

    describe "when handling search results" do

      it "should have a start attribute" do
        @search.start.should == "1"
      end

      it "should have an end attribute" do
        @search.end.should == "20"
      end

      it "should have number of results attribute" do
        @search.total_results.should == 1846
      end

      it "should have the search results stored as an array" do
        @search.searchresults.should be_instance_of(Array)
      end

      it "should be stored as result objects" do
        @search.searchresults.each do |result|
          result.should be_instance_of(Discogs::Search::Result)
        end
      end

      it "should have a incrementing num for each search result" do
        @search.searchresults.each_with_index do |result, index|
          result.num.should == (index + 1).to_s
        end
      end

      it "should have a type for the third result" do
        @search.searchresults[2].type.should == "label"
      end

      it "should have a title for the fourth result" do
        @search.searchresults[3].title.should == "Satanic Slaughter"
      end

      it "should have a summary for the sixth result" do
        @search.searchresults[5].summary.should == "Gary Slaughter"
      end

    end
 
  end

end
