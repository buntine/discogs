require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = mock(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", @oauth_access_token)
    @listing_id = 41578240
  end

  describe ".get_listing" do

    before do
      @oauth_response = mock(OAuth::AccessToken, :code => "200", :body => read_sample("listing"))
      @oauth_response_as_file = mock(StringIO, :read => read_sample("listing"))
      Zlib::GzipReader.should_receive(:new).and_return(@oauth_response_as_file)
      @oauth_access_token.should_receive(:get).and_return(@oauth_response)

      @listing = @wrapper.get_listing(@listing_id)
    end

    describe "when calling simple listing attributes" do

      it "should have a username" do
        @listing.status.should == "For Sale"
      end

      it "should have a weight" do
        @listing.weight.should == 239.0
      end

      it "should have a seller" do
        @listing.seller.username.should == "EmpireDVDs"
      end

    end

  end

end 
