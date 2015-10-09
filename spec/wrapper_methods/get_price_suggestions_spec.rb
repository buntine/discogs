require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @release_id = "1"
  end

  describe ".get_price_suggestions" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("price_suggestions"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("price_suggestions"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:get).and_return(@oauth_response)

      @price_suggestions = @wrapper.get_price_suggestions(@release_id)
    end

    describe "when calling simple price suggestion attributes" do

      it "should have a block for Near Mint" do
        expect(@price_suggestions["Near Mint (NM or M-)"]).to_not be_nil
      end

      it "should have a price for Mint" do
        expect(@price_suggestions["Mint (M)"].value).to eq(14.319139100000001)
      end

    end

  end

end 
