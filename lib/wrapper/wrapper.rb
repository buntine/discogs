# Core API wrapper class.

require 'uri'
require 'net/http'

require File.dirname(__FILE__) + "/api_response"
#require File.dirname(__FILE__) + "/release"

class Discogs::Wrapper

  ROOT_HOST = "http://www.discogs.com"

  attr_reader :api_key, :requests

  def initialize(api_key=nil)
    @api_key = api_key
  end

  def get_release(id)
    release_data = query_api("release/#{id}")
    release_data.valid? or raise_invalid_api_key
      
    release = Discogs::Release.new
    release.build!(release_data)
  end

 private

  def query_api(path, params={})
  # Strip <resp> element.
    # The build! method should (hopefully!) traverse the XML data and recursively build the object (and sub objects).
    # Known ttributes should be defined as assessors, and method_missing should catch all unknowns...
    # Elements which exist as objects (<label> == Discogs::Label) should be initialized and then built with said markup.
    # Pluralisations (+s, +list) of known objects should be set as arrays and then all children should be built into objects and have "build!" called with their respective markup.
    # Known Element classes should have an optional "map_to" class method that marries an xml element name to the object (Discog::Artist::MemberList will map to "members"). It will default to self.class.downcase.
    # Any class can overload "build!" method and return something useful. This will be handy if the markup should be parsed into something war (e.g: artist -> memberlist -> [name, name, name])
  
    response = make_request(path, params)

    if response.code == "404"
      raise_unknown_resource(path)
    end

    Discogs::APIResponse.prepare(response.body)
  end

  def make_request(path, params={})
    uri = build_uri(path, params)

    request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    request.add_field("Accept-Encoding", "gzip,deflate")

    response = Net::HTTP.new(uri.host).start do |http|
      http.request(request)
    end
  end

  def build_uri(path, params={})
    parameters = { :f => "xml", :api_key => @api_key }.merge(params)
    querystring = "?" + parameters.map { |key, value| "#{key}=#{value}" }.join("&")

    URI.parse(File.join(ROOT_HOST, path + querystring))
  end

  def raise_invalid_api_key
    raise Discogs::InvalidAPIKey, "Invalid API key: #{@api_key}"
  end

  def raise_unknown_resource(path='')
    raise Discogs::UnknownResource, "Unknown Discogs resource: #{path}"
  end

end
