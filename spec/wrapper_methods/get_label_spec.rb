require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @label_id = 1000
  end

  describe "when asking for label information" do

    before do
      mock_httparty("label")

      @label = @wrapper.get_label(@label_id)
    end

    describe "when calling simple label attributes" do

      it "should have a name attribute" do
        expect(@label.name).to eq("Warner Bros. Records")
      end
  
      it "should have a releases_url attribute" do
        expect(@label.releases_url).to match(/labels\/1000\/releases/)
      end
  
      it "should have a profile attribute" do
        expect(@label.profile).to match(/Founded in 1958/)
      end
  
      it "should have a parent label attribute" do
        expect(@label.parent_label.name).to eq("Warner Music Group")
      end

      it "should have one or more URLs" do
        expect(@label.urls).to be_instance_of(Hashie::Array)
        expect(@label.urls[0]).to eq("http://www.warnerbrosrecords.com/")
        expect(@label.urls[1]).to eq("http://www.facebook.com/WarnerBrosRecords")
      end
  
    end

    describe "when calling complex artist attributes" do
 
      it "should have a traversible list of images" do
        expect(@label.images).to be_instance_of(Hashie::Array)
      end

      it "should have a traversible list of sub-labels" do
        expect(@label.sublabels).to be_instance_of(Hashie::Array)
        expect(@label.sublabels[0].name).to eq("1017 Brick Squad Records")
      end
 
      it "should have specifications for each image" do
        specs = [ [ 600, 780, 'primary' ], [ 533, 698, 'secondary' ], [ 600, 600, 'secondary' ],
                  [ 532, 532, 'secondary' ], [ 175, 192, 'secondary' ], [ 200, 94, 'secondary' ],
                  [ 500, 493, 'secondary' ] ]

        @label.images.each_with_index do |image, index|
          expect(image.width).to eq(specs[index][0])
          expect(image.height).to eq(specs[index][1])
          expect(image.type).to eq(specs[index][2])
        end
      end

    end

  end

end
