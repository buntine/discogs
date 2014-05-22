require 'oauth'

module Authentication

  def get_request_token(app_key, app_secret, callback)
    consumer      = OAuth::Consumer.new(app_key, app_secret,
                      :authorize_url => "http://www.discogs.com/oauth/authorize",
                      :site          => "http://api.discogs.com")
    request_token = consumer.get_request_token(:oauth_callback => callback)

    {:request_token => request_token,
     :authorize_url => request_token.authorize_url(:oauth_callback => callback)}
  end

  def authenticate(request_token, verifier)
    request_token.get_access_token(:oauth_verifier => verifier)
  end

  def authenticated?(username=nil, &block)
    auth = if username
      @access_token and authenticated_username == username
    else
      !!@access_token
    end

    if block_given?
      auth ? yield : raise_authentication_error
    else
      auth
    end
  end

 private

  def authenticated_username
    data = get_identity
    data.username
  end

end
