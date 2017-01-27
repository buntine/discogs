require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "abuntine"
  end

  describe ".get_user" do

    before do
      mock_httparty("user")

      @user = @wrapper.get_user(@user_name)
    end

    describe "when calling simple user attributes" do

      it "should have a rank" do
        expect(@user.rank).to eq(1.0)
      end

      it "should have a username" do
        expect(@user.username).to eq("abuntine")
      end

      it "should have a uri" do
        expect(@user.uri).to eq("http://www.discogs.com/user/abuntine")
      end

      it "should not have a bogus attribute" do
        expect(@user.bogus_attribute).to be_nil
      end

    end

  end

end 
