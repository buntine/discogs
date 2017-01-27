require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_folders" do

    before do
      mock_httparty("user_folders")

      @user_folders = @wrapper.get_user_folders(@user_name)
    end

    describe "when calling simple folders attributes" do

      it "should have 2 folders" do
        expect(@user_folders.folders.length).to eq(2)
      end

      it "should have a name for each folder" do
        expect(@user_folders.folders[0].name).to eq("All")
        expect(@user_folders.folders[1].name).to eq("Uncategorized")
      end

      it "should not have a bogus attribute" do
      	expect(@user_folders.bogus_attribute).to be_nil
      end

    end

  end

end 
