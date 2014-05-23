require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = mock(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", @oauth_access_token)
    @order_id = "1-1"
  end

  describe ".get_order" do

    before do
      @oauth_response = mock(OAuth::AccessToken, :code => "200", :body => read_sample("order"))
      @oauth_response_as_file = mock(StringIO, :read => read_sample("order"))
      Zlib::GzipReader.should_receive(:new).and_return(@oauth_response_as_file)
      @oauth_access_token.should_receive(:get).and_return(@oauth_response)

      @order = @wrapper.get_order(@order_id)
    end

    describe "when calling simple order attributes" do

      it "should have a status" do
        @order.status.should == "New Order"
      end

      it "should have a fee" do
        @order.fee.value.should == 2.52
      end

    end

  end

end 
