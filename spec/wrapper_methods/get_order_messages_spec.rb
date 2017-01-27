require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @oauth_access_token = double(OAuth::AccessToken)
    @wrapper = Discogs::Wrapper.new("some_user_agent", :access_token => @oauth_access_token)

    @order_id = "1-1"
  end

  describe ".get_order_messages" do

    before do
      @oauth_response = double(OAuth::AccessToken)
      
      allow(@oauth_response).to receive_messages(:code => "200", :body => read_sample("order_messages"))

      @oauth_response_as_file = double(StringIO)
      
      allow(@oauth_response_as_file).to receive_messages(:read => read_sample("order_messages"))

      expect(Zlib::GzipReader).to receive(:new).and_return(@oauth_response_as_file)
      expect(@oauth_access_token).to receive(:get).and_return(@oauth_response)

      @order_messages = @wrapper.get_order_messages(@order_id)
    end

    describe "when calling simple order messages attributes" do

      it "should have an array of messages" do
        expect(@order_messages.messages).to be_instance_of(Hashie::Array)
      end

      it "should have a username for the first message" do
        expect(@order_messages.messages[0].from.username).to eq("example_seller")
      end

    end

  end

end 
