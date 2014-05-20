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

  def initialize(app_name, access_token)
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
    # Auth required.
    # POST request.
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
    # Auth required.
    # POST request.
  end

  def edit_release_in_user_wantlist(username, id, data={})
    # Auth required.
    # POST request.
  end

  def delete_release_in_user_wantlist(username, id)
    # Auth required.
    # DELETE request.
  end

  def get_user_identity
    if authenticated?
      query_and_build "oauth/identity"
    else
      raise_authentication_error
    end
  end

  def edit_user(username, data={})
    # Auth required.
    # POST request.
  end

  def add_release_to_user_folder(username, folder_id, release_id)
    # Auth required.
    # POST request.
  end

  def edit_release_in_user_folder(username, folder_id, release_id, instance_id, data={})
    # Auth required.
    # POST request.
  end

  def delete_instance_in_user_folder(username, folder_id, release_id, instance_id)
    # Auth required.
    # DELETE request.
  end

  def get_user_folder_releases(username, id)
    # TODO: Pagination.
    # TODO: Accept sort parameters.
    query_and_build "users/#{username}/collection/folders/#{id}/releases"
  end

  def get_user_folder(username, id)
    # Auth required, unless id == 0
    query_and_build "users/#{username}/collection/folders/#{id}"
  end

  def get_user_folders(username)
    # Auth required, except for "All" folder.
    query_and_build "users/#{username}/collection/folders"
  end

  def create_user_folder(username, id, data={})
    # Auth required.
    # POST request.
  end

  def delete_user_folder(username, id)
    # Auth required.
    # DELETE request.
  end

  def get_user_inventory(username)
    # TODO: Pagination.
  end

  def get_listing(id)
  end

  def get_order(id)
    # Auth required.
  end

  def get_price_suggestions(id)
    # Auth required.
  end

  def get_fee(price, currence="USD")
  end

  def get_image(filename)
    if authenticated?
      @access_token.get("/image/#{filename}").body
    else
      raise_authentication_error
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

  def query_and_build(path, params={})
    parameters = {:f => "json"}.merge(params)
    data = query_api(path, params)
    hash = JSON.parse(data)

    Hashie::Mash.new(hash)
  end

  # Queries the API and handles the response.
  def query_api(path, params={})
    response = make_request(path, params)

    raise_unknown_resource(path) if response.code == "404"
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
  def make_request(path, params={})
    uri       = build_uri(path, params)
    formatted = "#{uri.path}?#{uri.query}"

    if @access_token
      @access_token.get(formatted)
    else
      request       = Net::HTTP::Get.new(formatted)
      output_format = params.fetch(:f, "json")

      request.add_field("Accept",          "application/#{output_format}")
      request.add_field("Accept-Encoding", "gzip,deflate")
      request.add_field("User-Agent",      @app_name)

      Net::HTTP.new(uri.host).start do |http|
        http.request(request)
      end
    end
  end

  def build_uri(path, params={})
    output_format = params.fetch(:f, "json")
    parameters    = {:f => output_format}.merge(params)
    querystring   = "?" + URI.encode_www_form(parameters.sort)

    URI.parse(File.join(@@root_host, URI.encode(sanitize_path(path, URI.escape(querystring)))))
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
