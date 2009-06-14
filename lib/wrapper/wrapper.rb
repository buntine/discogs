# Core API wrapper class
class Discogs::Wrapper

  ROOT_URL = "http://www.discogs.com"

  attr_reader :api_key, :requests

  def initialize(api_key=nil)
    @api_key = api_key
  end

  def get_release(id)
    release_data = make_request("releases/#{id}")
    release_data.valid? or raise_invalid_api_key
      
    release = Discogs::Release.new
    release.build!(release_data)
  end

 private

  def make_request(path, params={})
    parameters = { :f => "xml", :api_key => @api_key }.merge(params)
    querystring = "?" + parameters.map { |key, value| "#{key}=#{value}" }.join("&")

    url = File.join(ROOT_URL, path + querystring)

    # Strip <resp> element.
    # The build! method should (hopefully!) traverse the XML data and recursively build the object (and sub objects).
    # Known ttributes should be defined as assessors, and method_missing should catch all unknowns...
    # Elements which exist as objects (<label> == Discogs::Label) should be initialized and then built with said markup.
    # Pluralisations (+s, +list) of known objects should be set as arrays and then all children should be built into objects and have "build!" called with their respective markup.
    # Known Element classes should have an optional "map_to" class method that marries an xml element name to the object (Discog::Artist::MemberList will map to "members"). It will default to self.class.downcase.
    # Any class can overload "build!" method and return something useful. This will be handy if the markup should be parsed into something war (e.g: artist -> memberlist -> [name, name, name])
  end

  def raise_invalid_api_key
    raise Discogs::InvalidAPIKey "Invalid API key: #{@api_key}"
  end

end
