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
    release.build_with(release_data)
  end

 private

  def make_request(path, params={})
    parameters = { :f => "xml", :api_key => @api_key }.merge(params)
    querystring = "?" + parameters.map { |key, value| "#{key}=#{value}" }.join("&")

    url = File.join(ROOT_URL, path + querystring)
  end

  def raise_invalid_api_key
    raise Discogs::InvalidAPIKey "Invalid API key: #{@api_key}"
  end

end
