require File.dirname(__FILE__) + "/../spec_helper"

describe Discogs::Wrapper do

  before do
    @wrapper = Discogs::Wrapper.new("some_key")
    @artist_name = "Root"
  end

  describe "when asking for label information" do

    before do
      @http_request = mock(Net::HTTP)
      @http_response = mock(Net::HTTPResponse, :code => "200", :body => valid_label_xml)
      @http_response_as_file = mock(StringIO, :read => valid_label_xml)
      Zlib::GzipReader.should_receive(:new).and_return(@http_response_as_file)
      @http_request.should_receive(:start).and_return(@http_response)
      Net::HTTP.should_receive(:new).and_return(@http_request)

      @label = @wrapper.get_label(@label_name)
    end

    describe "when calling simple label attributes" do

      it "should have a name attribute" do
        @label.name.should == "Sombre Records"
      end
  
      it "should have a contact info attribute" do
        @label.contactinfo.should == "Unknown, Germany"
      end
  
      it "should have a profile attribute" do
        @label.profile.should == "Released some OK LPs"
      end
  
      it "should have a parent label attribute" do
        @label.parentlabel.should == "SuperSombre"
      end

      it "should have one or more URLs" do
        @label.urls.should be_instance_of(Array)
        @label.urls[0].should == "http://www.sombrerecords.com"
        @label.urls[1].should == "http://www.discogs.com/label/Sombre+Records"
      end
  
    end

    describe "when calling complex artist attributes" do
 
      it "should have a traversible list of images" do
        @label.images.should be_instance_of(Array)
        @label.images[0].should be_instance_of(Discogs::Image)
      end

      it "should have a traversible list of sub-labels" do
        @label.sublabels.should be_instance_of(Array)
        @label.sublabels[0].should == "SubSombre"
        @label.sublabels[1].should == "Sony BMG"
      end
 
      it "should have specifications for each image" do
        specs = [ [ '400', '300', 'primary' ], [ '450', '350', 'secondary' ] ]

        @label.images.each_with_index do |image, index|
          image.width.should == specs[index][0]
          image.height.should == specs[index][1]
          image.type.should == specs[index][2]
        end
      end

      it "should have a traversible list of releases" do
        @label.releases.should be_instance_of(Array)
        @label.releases[0].should be_instance_of(Discogs::Label::Release)
      end

      it "should have a catno for the first release" do
        @label.releases[0].catno.should == "SMB01"
      end

      it "should have an artist name for the second release" do
        @label.releases[1].artist.should == "Moonblood"
      end

    end

  end

end
