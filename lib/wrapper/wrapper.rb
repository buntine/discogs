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
  #   @param release_id [Integer] release id
  # @return [Hash] the release with provided release_id
  def get_release(release_id)
    query_and_build "releases/#{release_id}"
  end

  # Retrieves a master release by ID.
  # @!macro [new] master_release_id
  #   @param master_release_id [Integer] master release id
  # @return [Hash] the master release with provided master_release_id
  def get_master_release(master_release_id)
    query_and_build "masters/#{id}"
  end

  alias_method :get_master, :get_master_release

  # Retrieves a list of all Releases that are versions of this master. Accepts Pagination parameters.
  # @macro master_release_id
  # @!macro [new] uses_pagination
  #   @param pagination [Hash] pagination parameters
  # @return [Hash] the master release with the provided master_release_id, along with versions
  def get_master_release_versions(master_release_id, pagination={})
    query_and_build "masters/#{master_release_id}/versions", pagination
  end

  # Retrieves an artist by ID.
  # @!macro [new] artist_id
  #   @param artist_id [Integer] artist id
  # @return [Hash] the artist with provided artist_id
  def get_artist(artist_id)
    query_and_build "artists/#{artist_id}"
  end

  # Returns a list of Releases and Masters associated with the artist. Accepts Pagination parameters.
  # @macro artist_id
  # @macro uses_pagination
  # @return [Hash] the releases for artist with provided artist_id
  def get_artists_releases(artist_id, pagination={})
    query_and_build "artists/#{artist_id}/releases", pagination
  end

  alias_method :get_artist_releases, :get_artists_releases

  # Retrieves a label by ID.
  # @!macro [new] label_id
  #   @param label_id [Integer] label id
  # @return [Hash] the label with provided id
  def get_label(label_id)
    query_and_build "labels/#{label_id}"
  end

  # Returns a list of Releases associated with the label. Accepts Pagination parameters.
  # @macro label_id
  # @macro uses_pagination
  # @return [Hash] the releases for label with provided id
  def get_labels_releases(label_id, pagination={})
    query_and_build "labels/#{label_id}/releases", pagination
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
  # @return [Hash] the user with provided username
  def get_user(username)
    query_and_build "users/#{username}"
  end

  # Get a collection for a user by username
  #
  # Shortcut method for #get_user_folder_releases[#get_user_folder_releases-instance_method]
  #
  # @macro username
  # @macro uses_pagination
  # @return [Hash] the user with provided username
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
  # @return [Hash] list of collection fields for the provided username
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
  # @return [Hash] wantlist for the provided username
  def get_user_wantlist(username, pagination={})
    query_and_build "users/#{username}/wants", pagination
  end

  alias_method :get_user_wants, :get_user_wantlist

  def get_user_want(username, id)
    query_and_build "users/#{username}/wants/#{id}"
  end

  # Add a release to a user’s wantlist.
  #
  # @!macro [new] need_auth
  #   @note Authentication as the owner is required.
  #
  # @macro username
  # @macro release_id
  # @param [Hash] data optional parameters:
  # @option data [String] :notes User notes to associate with this release.
  # @option data [Integer] :rating User’s rating of this release, from 0 (unrated) to 5 (best). Defaults to 0.
  # @return [Hash] new wantlist entry
  def add_release_to_user_wantlist(username, release_id, data={})
    authenticated? do
      query_and_build "users/#{username}/wants/#{release_id}", {}, :put, data
    end
  end

  # Edit the notes (or rating) on a release in a user’s wantlist.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro release_id
  # @param data [Hash] optional parameters:
  # @option data [String] :notes User notes to associate with this release.
  # @option data [Integer] :rating User’s rating of this release, from 0 (unrated) to 5 (best). Defaults to 0.
  # @return [Hash] updated wantlist entry
  def edit_release_in_user_wantlist(username, release_id, data={})
    authenticated? do
      query_and_build "users/#{username}/wants/#{release_id}", {}, :post, data
    end
  end

  # Remove a release from a user's wantlist.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro release_id
  # @return [Boolean]
  def delete_release_in_user_wantlist(username, release_id)
    authenticated? do
      query_and_build "users/#{username}/wants/#{release_id}", {}, :delete
    end
  end

  alias_method :delete_release_from_user_wantlist, :delete_release_in_user_wantlist

  # Retrieve basic information about the authenticated user.
  #
  # You can use this resource to find out who you’re authenticated as, and it also doubles as a good sanity check to ensure that you’re using OAuth correctly.
  #
  # For more detailed information, make another request for the user’s Profile.
  #
  # @macro need_auth
  # @return [Hash] authenticated user information
  def get_identity
    authenticated? do
      query_and_build "oauth/identity"
    end
  end

  # Edit a user’s profile data.
  #
  # @macro need_auth
  #
  # @macro username
  # @param [Hash] data data to update, with the optional keys:
  # @option data [String] :name The real name of the user.
  # @option data [String] :home_page The user's website.
  # @option data [String] :location The geographical location of the user.
  # @option data [String] :profile Biographical information about the user.
  def edit_user(username, data={})
    authenticated? do
      query_and_build "users/#{username}", {}, :post, data
    end
  end

  # Add a release to a folder in a user’s collection.
  #
  # @macro need_auth
  #
  # The folder_id must be non-zero – you can use 1 for “Uncategorized”.
  #
  # @macro username
  # @!macro [new] folder_id
  #   @param folder_id [Integer] folder id
  # @macro release_id
  # @return [Hash] new instance metadata
  def add_release_to_user_folder(username, folder_id, release_id)
    authenticated? do
      query_and_build "users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}", {}, :post
    end
  end

  alias_method :add_instance_to_user_folder, :add_release_to_user_folder

  # Change the rating on a release and/or move the instance to another folder.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro folder_id
  # @macro release_id
  # @!macro [new] instance_id
  #   @param instance_id [Integer] instance id
  # @param [Hash] data optional parameters
  # @option data [Integer] :rating User’s rating of this release, from 0 (unrated) to 5 (best).
  # @option data [Integer] :folder_id The ID of the folder to move the release into.
  # @return [Boolean]
  def edit_release_in_user_folder(username, folder_id, release_id, instance_id=1, data={})
    authenticated? do
      query_and_build "/users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}/instances/#{instance_id}"
    end
  end

  alias_method :edit_instance_in_user_folder, :edit_release_in_user_folder

  # Remove an instance of a release from a user’s collection folder.
  #
  # To move the release to the “Uncategorized” folder instead, use the POST method.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro folder_id
  # @macro release_id
  # @macro instance_id
  # @return [Boolean]
  def delete_instance_in_user_folder(username, folder_id, release_id, instance_id)
    authenticated? do
      query_and_build "/users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}/instances/#{instance_id}", {},  :delete
    end
  end

  alias_method :delete_release_in_user_folder, :delete_instance_in_user_folder

  # Change the value of a notes field on a particular instance.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro folder_id
  # @macro release_id
  # @macro instance_id
  # @!macro [new] field_id
  #   @param field_id [Integer] field id
  # @option data [String] :value The new value of the field. If the field’s type is dropdown, the value must match one of the values in the field’s list of options.
  def edit_field_on_instance_in_user_folder(username, folder_id, release_id, instance_id, field_id, data={})
    authenticated? do
      query_and_build "/users/#{username}/collection/folders/#{folder_id}/releases/#{release_id}/instances/#{instance_id}/fields/#{field_id}", {}, :post, data
    end
  end

  # Returns the list of releases in a folder in a user’s collection. Accepts Pagination parameters.
  #
  # Basic information about each release is provided, suitable for display in a list. For detailed information, make another API call to fetch the corresponding release.
  #
  # If folder_id is not 0, or the collection has been made private by its owner, authentication as the collection owner is required.
  #
  # If you are not authenticated as the collection owner, only public notes fields will be visible.
  #
  # @macro username
  # @macro folder_id
  # @param [Hash] params optional parameters
  # @option params [String] :sort Sort items by this field. One of:
  #   * +label+
  #   * +artist+
  #   * +title+
  #   * +catno+
  #   * +format+
  #   * +rating+
  #   * +added+
  #   * +year+
  # @option params [String] :sort_order Sort items in a particular order. One of:
  #   * +asc+
  #   * +desc+
  def get_user_folder_releases(username, folder_id, params={})
    if id == 0 or authenticated?
      query_and_build "users/#{username}/collection/folders/#{id}/releases", params
    else
      raise_authentication_error
    end
  end

  # Retrieve metadata about a folder in a user’s collection.
  #
  # If folder_id is not 0, authentication as the collection owner is required.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro folder_id
  # @return [Hash] folder with folder_id
  def get_user_folder(username, folder_id)
    if id == 0 or authenticated?
      query_and_build "users/#{username}/collection/folders/#{folder_id}"
    else
      raise_authentication_error
    end
  end

  # Retrieve a list of folders in a user’s collection.
  #
  # If the collection has been made private by its owner, authentication as the collection owner is required.
  #
  # If you are not authenticated as the collection owner, only folder ID 0 (the “All” folder) will be visible.
  #
  # @macro username
  # @return [Hash] folder listing
  def get_user_folders(username)
    query_and_build "users/#{username}/collection/folders"
  end

  # Create a new folder in a user’s collection.
  #
  # @macro need_auth
  #
  # @macro username
  # @param [Hash] data folder parameters
  # @option data [String] :name The name of the newly-created folder (Required).
  # @return [Hash] new folder metadata
  def create_user_folder(username, data={})
    authenticated? do
      query_and_build "users/#{username}/collection/folders", {}, :post, data
    end
  end

  alias_method :add_user_folder, :create_user_folder

  # Edit a folder’s metadata. Folders 0 and 1 cannot be renamed.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro folder_id
  # @param [Hash] data folder parameters
  # @option data [String] :name The name of the folder (Required).
  # @return [Hash] updated folder metadata
  def edit_user_folder(username, folder_id, data={})
    authenticated? do
      query_and_build "users/#{username}/collection/folders#{folder_id}", {}, :post, data
    end
  end

  # Delete a folder from a user’s collection. A folder must be empty before it can be deleted.
  #
  # @macro need_auth
  #
  # @macro username
  # @macro folder_id
  # @return [Boolean]
  def delete_user_folder(username, folder_id)
    authenticated? do
      query_and_build "users/#{username}/collection/folders#{folder_id}", {}, :delete
    end
  end

  def get_user_inventory(username, params={})
    query_and_build "users/#{username}/inventory", params
  end

  def get_listing(id)
    query_and_build "marketplace/listings/#{id}"
  end

  #
  #
  # @macro need_auth
  #
  def create_listing(data={})
    authenticated? do
      query_and_build "marketplace/listings", {}, :post, data
    end
  end

  #
  #
  # @macro need_auth
  #
  def edit_listing(id, data={})
    authenticated? do
      query_and_build "marketplace/listings/#{id}", {}, :post, data
    end
  end

  #
  #
  # @macro need_auth
  #
  def delete_listing(id)
    authenticated? do
      query_and_build "marketplace/listings/#{id}", {}, :delete
    end
  end

  #
  #
  # @macro need_auth
  #
  def get_order(id)
    authenticated? do
      query_and_build "marketplace/orders/#{id}"
    end
  end

  #
  #
  # @macro need_auth
  #
  def edit_order(id, data={})
    authenticated? do
      query_and_build "marketplace/orders/#{id}", {}, :post, data
    end
  end

  #
  #
  # @macro need_auth
  #
  def list_orders(params={})
    authenticated? do
      query_and_build "marketplace/orders", params
    end
  end

  #
  #
  # @macro need_auth
  #
  def list_order_messages(id, pagination={})
   authenticated? do
     query_and_build "marketplace/orders#{id}/messages", pagination
   end
  end

  alias_method :get_order_messages, :list_order_messages

  #
  #
  # @macro need_auth
  #
  def create_order_message(id, data={})
    authenticated? do
      query_and_build "marketplace/orders/#{id}/messages", {}, :post, data
    end
  end

  #
  #
  # @macro need_auth
  #
  def get_price_suggestions(id)
    authenticated? do
      query_and_build "marketplace/price_suggestions/#{id}"
    end
  end

  def get_fee(price, currency="USD")
    query_and_build "marketplace/fee/#{price}/#{currency}"
  end

  #
  #
  # @macro need_auth
  #
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
