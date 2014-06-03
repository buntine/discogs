require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @search_term = "Winter Falls Over the Land"
    @search_type = "release"
  end

  describe "when handling an advanced search" do

    it "should properly encode the request URI" do
      encoded_uri = "/database/search?f=json&q=Release+Title+artist%3AArtist+Name&type=release"
      get = Net::HTTP::Get.new(encoded_uri)
      Net::HTTP::Get.should_receive(:new).with(encoded_uri).and_return(get)

      @wrapper.search("Release Title artist:Artist Name", :type => @search_type)
    end

  end

  describe "when handling a search including whitespace" do

    it "should properly encode spaces in the request URI" do
      encoded_uri = "/database/search?f=json&q=One+Two"
      get = Net::HTTP::Get.new(encoded_uri)
      Net::HTTP::Get.should_receive(:new).with(encoded_uri).and_return(get)

      @wrapper.search("One Two")
    end

  end

  describe "when asking for search result information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("search_results"))
      @http_response_as_file = mock(StringIO, :read => read_sample("search_results"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @search = @wrapper.search(@search_term, :type => @search_type)
    end

    describe "when handling exact results" do

      it "should have the results stored as an array" do
        @search.results.should be_instance_of(Array)
      end

      it "should have a type for the first result" do
        @search.results[0].type.should == "release"
      end

      it "should have a style array for the first result" do
        @search.results[0].style.should be_instance_of(Array)
        @search.results[0].style[0].should == "Black Metal"
      end

      it "should have a type for the fourth result" do
        @search.results[3].type.should == "release"
      end

    end

    describe "when handling search results" do

      it "should have number of results per page attribute" do
        @search.pagination.per_page.should == 50
      end

      it "should have number of pages attribute" do
        @search.pagination.pages.should == 1
      end

    end

  end

end
