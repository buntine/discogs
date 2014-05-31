# Core API wrapper class.

require 'hashie'
require 'json'
require 'net/http'
require 'stringio'
require 'uri'
require 'cgi'
require 'zlib'

require File.dirname(__FILE__) + "/authentication"

class Discogs::Wrapper

  include Authentication

  @@root_host = "http://api.discogs.com"

  attr_reader :app_name
  attr_accessor :access_token

  def initialize(app_name, access_token=nil)
    @app_name     = app_name
    @access_token = access_token
  end

  # Retrieves a release by ID.
  # @!macro [new] release_id
  #   @param id [Integer] release_id
  # @return [Object] the release with provided id
  def get_release(id)
    query_and_build "releases/#{id}"
  end

  # Retrieves a master release by ID.
  # @!macro [new] master_release_id
  #   @param id [Integer] master release id
  # @return [Object] the master release with provided id
  def get_master_release(id)
    query_and_build "masters/#{id}"
  end

  alias_method :get_master, :get_master_release

  # Retrieves a list of all Releases that are versions of this master. Accepts Pagination parameters.
  # @macro master_release_id
  # @!macro [new] uses_pagination
  #   @param pagination [Object] pagination parameters
  # @return [Object] the master release with release id, along with versions
  def get_master_release_versions(id, pagination={})
    query_and_build "masters/#{id}/versions", pagination
  end

  # Retrieves an artist by ID.
  # @!macro [new] artist_id
  #   @param id [Integer] artist id
  # @return [Object] the artist with provided id
  def get_artist(id)
    query_and_build "artists/#{id}"
  end

  # Returns a list of Releases and Masters associated with the artist. Accepts Pagination parameters.
  # @macro artist_id
  # @macro uses_pagination
  # @return [Object] the releases for artist with provided id
  def get_artists_releases(id, pagination={})
    query_and_build "artists/#{id}/releases", pagination
  end

  alias_method :get_artist_releases, :get_artists_releases

  # Retrieves a label by ID.
  # @!macro [new] label_id
  #   @param id [Integer] label id
  # @return [Object] the label with provided id
  def get_label(id)
    query_and_build "labels/#{id}"
  end

  # Returns a list of Releases associated with the label. Accepts Pagination parameters.
  # @macro label_id
  # @macro uses_pagination
  # @return [Object] the releases for label with provided id
  def get_labels_releases(id, pagination={})
    query_and_build "labels/#{id}/releases", pagination
  end

  alias_method :get_label_releases, :get_labels_releases

  # Retrieve a user by username.
  #
  # If authenticated as the requested user, the email key will be visible.
  #
  # If authenticated as the requested user or the user’s collection/wantlist is public,
  # the num_collection / num_wantlist keys will be visible.
  #
  # @!macro [new] username
  #   @param username [String] username
  # @return [Object] the user with provided username
  def get_user(username)
    query_and_build "users/#{username}"
  end

  # Edit a user’s profile data.
  #
  # Authentication as the user is required.
  # @macro username
  # @param [Hash] data data to update, with the optional keys:
  # @option data [String] :name The real name of the user.
  # @option data [String] :home_page The user's website.
  # @option data [String] :location The geographical location of the user.
  # @option data [String] :profile Biographical information about the user.
  def edit_user(username, data={})
    authenticated? do
      query_and_build "labels/#{id}/releases", {}, :post, data
    end
  end

  # Get a collection for a user by username
  #
  # Shortcut method for #get_user_folder_releases[#get_user_folder_releases-instance_method]
  #
  # @macro username
  # @macro uses_pagination
  # @return [Object] the user with provided username
  def get_user_collection(username, pagination={})
    get_user_folder_releases(username, 0)
  end

  # Retrieve a list of user-defined collection notes fields. These fields are available on every release in the collection.
  #
  # If the collection has been made private by its owner, authentication as the collection owner is required.
  #
  # If you are not authenticated as the collection owner, only fields with public set to true will be visible.
  #
  # @macro username
  # @return [Object] list of collection fields for the provided username
  def get_user_collection_fields(username)
    query_and_build "users/#{username}/collection/fields"
  end

  # Returns the list of releases in a user’s wantlist. Accepts Pagination parameters.
  #
  # Basic information about each release is provided, suitable for display in a list. For detailed information, make another API call to fetch the corresponding release.
  #
  # If the wantlist has been made private by its owner, you must be authenticated as the owner to view it.
  #
  # The notes field will be visible if you are authenticated as the wantlist owner.
  #
  # @macro username
  # @macro uses_pagination
  # @return [Object] wantlist for the provided username
  def get_user_wantlist(username, pagination={})
    query_and_build "users/#{username}/wants", pagination
  end

  alias_method :get_user_wants, :get_user_wantlist

  def get_user_want(username, id)
    query_and_build "users/#{username}/wants/#{id}"
  end

  # Add a release to a user’s wantlist.
  #
  # @note Authentication as the wantlist owner is required.
  #
  # @macro username
  # @macro release_id
  # @param [Hash] data optional parameters:
  # @option data [String] :notes User notes to associate with this release.
  # @option data [Integer] :rating User’s rating of this release, from 0 (unrated) to 5 (best). Defaults to 0.
  # @return [Object] new wantlist entry
  def add_release_to_user_wantlist(username, id, data={})
    authenticated? do
      query_and_build "users/#{username}/wants/#{id}", {}, :put, data
    end
  end

  # Edit the notes (or rating) on a release in a user’s wantlist.
  #
  # @note Authentication as the wantlist owner is required.
  #
  # @macro username
  # @macro release_id
  # @param data [Object] optional parameters:
  # @option data [String] :notes User notes to associate with this release.
  # @option data [Integer] :rating User’s rating of this release, from 0 (unrated) to 5 (best). Defaults to 0.
  # @return [Object] updated wantlist entry
  def edit_release_in_user_wantlist(username, id, data={})
    authenticated? do
      query_and_build "users/#{username}/wants/#{id}", {}, :post, data
    end
  end

  # Remove a release from a user's wantlist.
  #
  # @note Authentication as the wantlist owner is required.
  #
  # @macro username
  # @macro release_id
  # @return [Boolean]
  def delete_release_in_user_wantlist(username, id)
    authenticated? do
      query_and_build "users/#{username}/wants/#{id}", {}, :delete
    end
  end

  alias_method :delete_release_from_user_wantlist, :delete_release_in_user_wantlist

  def get_identity
    authenticated? do
      query_and_build "oauth/identity"
    end
  end

  def edit_user(username, data={})
    authenticated? do
      query_and_build "users/#{username}", {}, :post, data
    end
  end

  def add_release_to_user_folder(username, folder_id, release_id)
    authenticated? do
      query_and_build "users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}", {}, :post
    end
  end

  alias_method :add_instance_to_user_folder, :add_release_to_user_folder

  def edit_release_in_user_folder(username, folder_id, release_id, instance_id=1, data={})
    authenticated? do
      query_and_build "/users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}/instances/#{instance_id}"
    end
  end

  alias_method :edit_instance_in_user_folder, :edit_release_in_user_folder

  def delete_instance_in_user_folder(username, folder_id, release_id, instance_id)
    authenticated? do
      query_and_build "/users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}/instances/#{instance_id}", {},  :delete
    end
  end

  alias_method :delete_release_in_user_folder, :delete_instance_in_user_folder

  def edit_field_on_instance_in_user_folder(username, folder_id, release_id, instance_id, field_id, data={})
    authenticated? do
      query_and_build "/users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}/instances/#{instance_id}/fields/#{field_id}", {}, :post, data
    end
  end

  def get_user_folder_releases(username, id, params={})
    if id == 0 or authenticated?
      query_and_build "users/#{username}/collection/folders/#{id}/releases", params
    else
      raise_authentication_error
    end
  end

  def get_user_folder(username, id)
    if id == 0 or authenticated?
      query_and_build "users/#{username}/collection/folders/#{id}"
    else
      raise_authentication_error
    end
  end

  def get_user_folders(username)
    query_and_build "users/#{username}/collection/folders"
  end

  def create_user_folder(username, data={})
    authenticated? do
      query_and_build "users/#{username}/collection/folders", {}, :post, data
    end
  end

  alias_method :add_user_folder, :create_user_folder

  def edit_user_folder(username, id, data={})
    authenticated? do
      query_and_build "users/#{username}/collection/folders#{id}", {}, :post, data
    end
  end

  def delete_user_folder(username, id)
    authenticated? do
      query_and_build "users/#{username}/collection/folders#{id}", {}, :delete
    end
  end

  def get_user_inventory(username, params={})
    query_and_build "users/#{username}/inventory", params
  end

  def get_listing(id)
    query_and_build "marketplace/listings/#{id}"
  end

  def create_listing(data={})
    authenticated? do
      query_and_build "marketplace/listings", {}, :post, data
    end
  end

  def edit_listing(id, data={})
    authenticated? do
      query_and_build "marketplace/listings/#{id}", {}, :post, data
    end
  end

  def delete_listing(id)
    authenticated? do
      query_and_build "marketplace/listings/#{id}", {}, :delete
    end
  end

  def get_order(id)
    authenticated? do
      query_and_build "marketplace/orders/#{id}"
    end
  end

  def edit_order(id, data={})
    authenticated? do
      query_and_build "marketplace/orders/#{id}", {}, :post, data
    end
  end

  def list_orders(params={})
    authenticated? do
      query_and_build "marketplace/orders", params
    end
  end

  def list_order_messages(id, pagination={})
   authenticated? do
     query_and_build "marketplace/orders#{id}/messages", pagination
   end
  end

  alias_method :get_order_messages, :list_order_messages

  def create_order_message(id, data={})
    authenticated? do
      query_and_build "marketplace/orders/#{id}/messages", {}, :post, data
    end
  end

  def get_price_suggestions(id)
    authenticated? do
      query_and_build "marketplace/price_suggestions/#{id}"
    end
  end

  def get_fee(price, currency="USD")
    query_and_build "marketplace/fee/#{price}/#{currency}"
  end

  def get_image(filename)
    authenticated? do
      @access_token.get("/image/#{filename}").body
    end
  end

  def search(term, params={})
    parameters = {:q => term}.merge(params)

    query_and_build "database/search", parameters
  end

  def raw(url)
    uri    = URI.parse(url)
    params = CGI.parse(uri.query.to_s)

    query_and_build uri.path, params
  end

 private

  def query_and_build(path, params={}, method=:get, body=nil)
    parameters = {:f => "json"}.merge(params)
    data = query_api(path, params, method, body)
    hash = JSON.parse(data)

    Hashie::Mash.new(hash)
  end

  # Queries the API and handles the response.
  def query_api(path, params, method, body)
    response = make_request(path, params, method, body)

    raise_unknown_resource(path) if response.code == "404"
    raise_authentication_error(path) if response.code == "401"
    raise_internal_server_error if response.code == "500"

    # Unzip the response data, or just read it in directly
    # if the API responds without gzipping.
    response_body = nil
    begin
      inflated_data = Zlib::GzipReader.new(StringIO.new(response.body))
      response_body = inflated_data.read
    rescue Zlib::GzipFile::Error
      response_body = response.body
    end

    response_body
  end

  # Generates a HTTP request and returns the response.
  def make_request(path, params, method, body)
    uri           = build_uri(path, params)
    formatted     = "#{uri.path}?#{uri.query}"
    output_format = params.fetch(:f, "json")
    headers       = {"Accept"          => "application/#{output_format}",
                     "Accept-Encoding" => "gzip,deflate",
                     "User-Agent"      => @app_name}

    if authenticated?
      if [:post, :put].include?(method)
        headers["Content-Type"] = "application/json"
        @access_token.send(method, formatted, JSON(body), headers)
      else
        @access_token.send(method, formatted, headers)
      end
    else
      # All non-authenticated endpoints are GET.
      request = Net::HTTP::Get.new(formatted)

      headers.each do |h, v|
        request.add_field(h, v)
      end

      Net::HTTP.new(uri.host).start do |http|
        http.request(request)
      end
    end
  end

  def build_uri(path, params={})
    output_format = params.fetch(:f, "json")
    parameters    = {:f => output_format}.merge(params)
    querystring   = "?" + URI.encode_www_form(prepare_hash(parameters))

    URI.parse(File.join(@@root_host, URI.encode(sanitize_path(path, URI.escape(querystring)))))
  end

  # Stringifies keys and sorts.
  def prepare_hash(h)
    result = {}

    h.each do |k, v|
      result[k.to_s] = v
    end

    result.sort
  end

  def sanitize_path(*path_parts)
    clean_path = path_parts.map { |part| part.gsub(/\s/, '+') }
    clean_path.join
  end

  def raise_unknown_resource(path="")
    raise Discogs::UnknownResource, "Unknown Discogs resource: #{path}"
  end

  def raise_internal_server_error
    raise Discogs::InternalServerError, "The API server cannot complete the request"
  end

  def raise_authentication_error(path="")
    raise Discogs::AuthenticationError, "Authentication is required for this resource: #{path}"
  end

end
