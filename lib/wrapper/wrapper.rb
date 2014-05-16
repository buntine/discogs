# Core API wrapper class.

require 'hashie'
require 'json'
require 'net/http'
require 'pry'
require 'rexml/document'
require 'stringio'
require 'uri'
require 'zlib'

require File.dirname(__FILE__) + "/resource"

class Discogs::Wrapper

  @@root_host = "http://api.discogs.com"

  attr_reader :app_name

  def initialize(app_name=nil)
    @app_name = app_name
  end

  def get_release(id)
    query_and_build_json "releases/#{id}"
  end

  def get_master_release(id)
    query_and_build_json "masters/#{id}"
  end

  def get_artist(id)
    query_and_build_json "artists/#{id}"
  end

  def get_artists_releases(id)
  end

  def get_label(id)
    query_and_build_json "labels/#{id}"
  end

  def get_labels_releases(id)
  end

  def get_user(username)
    query_and_build_json "users/#{username}"
  end

  def edit_user(username, data={})
    # Auth required.
    # POST request.
  end

  def get_user_collection(username)
    get_user_folder_releases(username, 0)
  end

  def get_user_collection_fields(username)
  end

  def get_user_wantlist(username)
    query_and_build_json "users/#{username}/wants"
  end

  def get_user_identity(username)
    # Auth required.
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

  def get_user_folder_releases(username, folder_id)
    query_and_build_json "users/#{username}/collection/folders/#{folder_id}/releases"
  end

  def get_user_folder(username, folder_id)
    # Auth required, unless folder_id == 0
  end

  def get_user_folders(username)
    # Auth required, except for "All" folder.
  end

  def create_user_folder(username, folder_id, data={})
    # Auth required.
    # POST request.
  end

  def delete_user_folder(username, folder_id)
    # Auth required.
    # DELETE request.
  end

  def get_user_inventory(username)
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

  def get_image
  end

  def search(term, options={})
    opts = { :type => :all, :page => 1 }.merge(options)
    params = { :q => term, :type => opts[:type], :page => opts[:page] }

    data = query_api("search", params)
    resource = Discogs::Search.new(data)

    resource.build_with_resp!
  end

 private

  def query_and_build_json(path)
    data = query_api(path, {:f => "json"})
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
    uri           = build_uri(path, params)
    request       = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
    output_format = params.fetch(:f, "xml")

    request.add_field("Accept",          "application/#{output_format}")
    request.add_field("Accept-Encoding", "gzip,deflate")
    request.add_field("User-Agent",      @app_name)

    Net::HTTP.new(uri.host).start do |http|
      http.request(request)
    end
  end

  def build_uri(path, params={})
    output_format = params.fetch(:f, "xml")
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
    raise Discogs::InternalServerError, "The remote server cannot complete the request"
  end

end
