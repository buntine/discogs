require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_collection" do

    before do
      mock_httparty("user_collection")

      @user_collection = @wrapper.get_user_collection(@user_name)
    end

    describe "when calling simple collection attributes" do

      it "should have 5 releases per page" do
        expect(@user_collection.releases.length).to eq(5)
      end

      it "should have 309 releases total" do
        expect(@user_collection.pagination.items).to eq(309)
      end

      it "should not have a bogus attribute" do
        expect(@user_collection.bogus_attr).to be_nil
      end
        
    end

  end

end 
