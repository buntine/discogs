require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
    @folder_id = 0
  end

  describe ".get_user_folder" do

    before do
      mock_httparty("user_folder")

      @user_folder = @wrapper.get_user_folder(@user_name, @folder_id)
    end

    describe "when calling simple folder attributes" do

      it "should have a name" do
        expect(@user_folder.name).to eq("Uncategorized")
      end

      it "should have sanitized count" do
        expect(@user_folder.total).to eq(20)
        expect(@user_folder.count).to eq(4 + 1) # Plus one to be removed after backwards-compatibility fix has been removed.
      end

      it "should have a backwards-compatible count" do
        expect(@user_folder[:count]).to eq(20)
      end

      it "should not have a bogus attribute" do
        expect(@user_folder.bogus_attr).to be_nil
      end

      it "should raise error if attempting to list non-0 folder" do
        expect(lambda { @wrapper.get_user_folder(@user_name, 1) }).to raise_error(Discogs::AuthenticationError)
      end

    end

  end

end 
