require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @user_name = "mintfloss"
  end

  describe ".get_user_wantlist" do

    before do
      mock_httparty("user_wantlist")

      @user_wantlist = @wrapper.get_user_wantlist(@user_name)
    end

    describe "when calling simple wantlist attributes" do

      it "should have 5 wants per page" do
        expect(@user_wantlist.wants.length).to eq(5)
      end

      it "should have 77 wants total" do
        expect(@user_wantlist.pagination.items).to eq(77)
      end

      it "should have a want with a zero rating" do
        expect(@user_wantlist.wants.first.rating).to eq(0)
      end

      it "should have a want with some basic information" do
        expect(@user_wantlist.wants.first.basic_information.title).to eq("18 Jahre Sein / Mach Keine Wellen")
      end

      it "should not have a bogus attribute" do
        expect(@user_wantlist.bogus_attr).to be_nil
      end

    end

  end

end 
