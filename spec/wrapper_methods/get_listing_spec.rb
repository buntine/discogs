require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @listing_id = 41578240
  end

  describe ".get_listing" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("listing"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("listing"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:get).and_return(@oauth_response)

      @listing = @wrapper.get_listing(@listing_id)
    end

    describe "when calling simple listing attributes" do

      it "should have a username" do
        expect(@listing.status).to eq("For Sale")
      end

      it "should have a weight" do
        expect(@listing.weight).to eq(239.0)
      end

      it "should have a seller" do
        expect(@listing.seller.username).to eq("EmpireDVDs")
      end

    end

  end

end 
