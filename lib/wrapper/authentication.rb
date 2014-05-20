require "oauth"

module Authentication

  def get_request_token(app_key, app_secret, callback)
    consumer = OAuth::Consumer.new(app_key, app_secret,
                 :authorize_url => "http://www.discogs.com/oauth/authorize",
                 :site          => "http://api.discogs.com")

    {:request_token => consumer.get_request_token(:oauth_callback => callback),
     :authorize_url => @request_token.authorize_url(:oauth_callback => @callback_url)}
  end

  def authenticate(request_token, verifier)
    @access_token = request_token.get_access_token(:oauth_verifier => verifier)
    data          = query_and_build_json("oauth/identity")
    @user         = data.username

    true
  end

  def authenticated?(username=nil)
    if username
      @access_token and @user == username
    else
      !!@access_token
    end
  end

end
