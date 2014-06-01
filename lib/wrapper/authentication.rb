require 'oauth'

module Authentication

  # Retrieves an OAuth request token from the Discogs server.
  # @!macro [new] app_key
  # @!macro [new] app_secret
  #   @param app_key [String] application id
  #   @param app_secret [String] application secret
  # @return [Hash] containing a :request_token that should be stored locally and a :authorize_url that the user must browse to.
  def get_request_token(app_key, app_secret, callback)
    consumer      = OAuth::Consumer.new(app_key, app_secret,
                      :authorize_url => "http://www.discogs.com/oauth/authorize",
                      :site          => "http://api.discogs.com")
    request_token = consumer.get_request_token(:oauth_callback => callback)

    {:request_token => request_token,
     :authorize_url => request_token.authorize_url(:oauth_callback => callback)}
  end

  # Retrieves an OAuth access token from the Discogs server.
  # @!macro [new] request_token
  # @!macro [new] verifier
  #   @param request_token [OAuth::RequestToken] request token
  #   @param verifier [String] verifier token
  # @return [OAuth::AccessToken] 
  def authenticate(request_token, verifier)
    @access_token = request_token.get_access_token(:oauth_verifier => verifier)
  end

  # Returns true if an OAuth access_token is present. If a username is given, the authenticated username must match it.
  # @!macro [new] username
  #   @param username [String] username
  # @return [Boolean]
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
