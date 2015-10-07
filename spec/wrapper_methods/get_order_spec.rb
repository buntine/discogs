require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @order_id = "1-1"
  end

  describe ".get_order" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("order"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("order"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:get).and_return(@oauth_response)

      @order = @wrapper.get_order(@order_id)
    end

    describe "when calling simple order attributes" do

      it "should have a status" do
        expect(@order.status).to eq("New Order")
      end

      it "should have a fee" do
        expect(@order.fee.value).to eq(2.52)
      end

    end

  end

end 
