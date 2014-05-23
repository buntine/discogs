# Core API wrapper class.

require 'hashie'
require 'json'
require 'net/http'
require 'stringio'
require 'uri'
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

  def get_release(id)
    query_and_build "releases/#{id}"
  end

  def get_master_release(id)
    query_and_build "masters/#{id}"
  end

  alias_method :get_master, :get_master_release

  def get_master_release_versions(id)
    # TODO: Pagination.
    query_and_build "masters/#{id}/versions"
  end

  def get_artist(id)
    query_and_build "artists/#{id}"
  end

  def get_artists_releases(id)
    # TODO: Pagination.
    query_and_build "artists/#{id}/releases"
  end

  alias_method :get_artist_releases, :get_artists_releases

  def get_label(id)
    query_and_build "labels/#{id}"
  end

  def get_labels_releases(id)
    # TODO: Pagination.
    query_and_build "labels/#{id}/releases"
  end

  alias_method :get_label_releases, :get_labels_releases

  def get_user(username)
    query_and_build "users/#{username}"
  end

  def edit_user(username, data={})
    authenticated? do
      query_and_build "labels/#{id}/releases", {}, :post, data
    end
  end

  def get_user_collection(username)
    # TODO: Pagination.
    get_user_folder_releases(username, 0)
  end

  def get_user_collection_fields(username)
  end

  def get_user_wantlist(username)
    # TODO: Pagination.
    query_and_build "users/#{username}/wants"
  end

  alias_method :get_user_wants, :get_user_wantlist

  def get_user_want(username, id)
    query_and_build "users/#{username}/wants/#{id}"
  end

  def add_release_to_user_wantlist(username, id, data={})
    authenticated? do
      query_and_build "users/#{username}/wants/#{id}", {}, :put, data
    end
  end

  def edit_release_in_user_wantlist(username, id, data={})
    authenticated? do
      query_and_build "users/#{username}/wants/#{id}", {}, :post, data
    end
  end

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
    # Auth required.
    # DELETE request.
  end

  def edit_field_on_instance_in_user_folder(username, folder_id, release_id, instance_id, field_id)
    # Auth required.
    # POST request.
  end

  def get_user_folder_releases(username, id)
    # TODO: Pagination.
    # TODO: Accept sort parameters.
    if id == 0 or authenticated?
      query_and_build "users/#{username}/collection/folders/#{id}/releases"
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

  def get_user_inventory(username)
    # TODO: Accept status parameter.
    # TODO: Accept sort parameters.
    # TODO: Pagination.
    query_and_build "users/#{username}/inventory"
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
    # Auth required.
  end

  def edit_order(id)
    # Auth required.
    # POST request.
  end

  def list_orders
    # Auth required.
    # TODO: Pagination.
    # TODO: Accept status parameters.
    # TODO: Accept sort parameters.
  end

  def list_order_messages(id)
   # Auth required.
   # TODO: Pagination.
  end

  def create_order_message(id, data={})
   # Auth required.
   # POST request.
  end

  def get_price_suggestions(id)
    # Auth required.
  end

  def get_fee(price, currence="USD")
  end

  def get_image(filename)
    authenticated? do
      @access_token.get("/image/#{filename}").body
    end
  end

  def search(term, type=nil)
    # TODO: Pagination.
    params = {:q => term}

    if type
      params[:type] = type
    end

    query_and_build "database/search", params
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
