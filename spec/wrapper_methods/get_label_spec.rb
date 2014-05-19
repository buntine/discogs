require 'spec_helper'

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_user_agent")
    @label_id = 1000
  end

  describe "when asking for label information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => read_sample("label"))
      @http_response_as_file = mock(StringIO, :read => read_sample("label"))
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @label = @wrapper.get_label(@label_id)
    end

    describe "when calling simple label attributes" do

      it "should have a name attribute" do
        @label.name.should == "Warner Bros. Records"
      end
  
      it "should have a releases_url attribute" do
        @label.releases_url.should =~ /labels\/1000\/releases/
      end
  
      it "should have a profile attribute" do
        @label.profile.should =~ /Founded in 1958/
      end
  
      it "should have a parent label attribute" do
        @label.parent_label.name.should == "Warner Music Group"
      end

      it "should have one or more URLs" do
        @label.urls.should be_instance_of(Array)
        @label.urls[0].should == "http://www.warnerbrosrecords.com/"
        @label.urls[1].should == "http://www.facebook.com/WarnerBrosRecords"
      end
  
    end

    describe "when calling complex artist attributes" do
 
      it "should have a traversible list of images" do
        @label.images.should be_instance_of(Array)
      end

      it "should have a traversible list of sub-labels" do
        @label.sublabels.should be_instance_of(Array)
        @label.sublabels[0].name.should == "1017 Brick Squad Records"
      end
 
      it "should have specifications for each image" do
        specs = [ [ 600, 780, 'primary' ], [ 533, 698, 'secondary' ], [ 600, 600, 'secondary' ],
                  [ 532, 532, 'secondary' ], [ 175, 192, 'secondary' ], [ 200, 94, 'secondary' ],
                  [ 500, 493, 'secondary' ] ]

        @label.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

    end

  end

end
