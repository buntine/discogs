# Core API wrapper class.

require 'uri'
require 'net/http'

require File.dirname(__FILE__) + "/api_response"
require File.dirname(__FILE__) + "/resource"

class Discogs::Wrapper

  ROOT_HOST = "http://www.discogs.com"

  attr_reader :api_key, :requests

  def initialize(api_key=nil)
    @api_key = api_key
  end

  def get_release(id)
    release_data = query_api("release/#{id}")
    release = Discogs::Release.new(release_data)
    release.build!
  end

 private

  def query_api(path, params={})
    response = make_request(path, params)

    raise_unknown_resource(path) if response.code == "404"
    raise_invalid_api_key if response.code == "400"

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
