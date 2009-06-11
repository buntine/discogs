# Core API wrapper class
class Discogs::Wrapper

  attr_reader :api_key

  def initialize(api_key=nil)
    @api_key = api_key
  end

end
