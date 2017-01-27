require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent", :user_token => "token")
    @search_term = "Winter Falls Over the Land"
    @search_type = "release"
  end

  describe "when asking for search result information" do

    before do
      mock_httparty("search_results")

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
