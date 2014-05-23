require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = mock(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", @oauth_access_token)
    @release_id = "1"
  end

  describe ".get_price_suggestions" do

    before do
      @oauth_response = mock(OAuth::AccessToken, :code => "200", :body => read_sample("price_suggestions"))
      @oauth_response_as_file = mock(StringIO, :read => read_sample("price_suggestions"))
      Zlib::GzipReader.should_receive(:new).and_return(@oauth_response_as_file)
      @oauth_access_token.should_receive(:get).and_return(@oauth_response)

      @price_suggestions = @wrapper.get_price_suggestions(@release_id)
    end

    describe "when calling simple price suggestion attributes" do

      it "should have a block for Near Mint" do
        @price_suggestions["Near Mint (NM or M-)"].should_not be_nil
      end

      it "should have a price for Mint" do
        @price_suggestions["Mint (M)"].value.should == 14.319139100000001
      end

    end

  end

end 
