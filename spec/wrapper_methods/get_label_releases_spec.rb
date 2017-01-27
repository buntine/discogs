require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @label_id = "9800"
  end

  describe ".get_labels_releases" do

    before do
      mock_httparty("label_releases")

      @label_releases = @wrapper.get_label_releases(@label_id)
    end

    describe "when calling simple releases attributes" do

      it "should have 8 releases per page" do
        expect(@label_releases.releases.length).to eq(8)
      end

      it "should have 8 releases total" do
        expect(@label_releases.pagination.items).to eq(8)
      end

      it "should have a first release with a Cat No" do
        expect(@label_releases.releases.first.catno).to eq("SSS 001")
      end

      it "should have a first release with a status" do
        expect(@label_releases.releases.first.status).to eq("Accepted")
      end

      it "should not have a bogus attribute" do
        expect(@label_releases.bogus_attribute).to be_nil
      end

    end

  end

end 
