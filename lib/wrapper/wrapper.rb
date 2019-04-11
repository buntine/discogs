# Core API wrapper class.

require 'hashie'
require 'json'
require 'httparty'
require 'stringio'
require 'uri'
require 'cgi'
require 'zlib'

require File.dirname(__FILE__) + "/authentication"

class Discogs::Wrapper

  include Authentication

  @@root_host = "https://api.discogs.com"

  attr_reader :app_name
  attr_accessor :access_token, :user_token

  def initialize(app_name, auth_opts={})
    @app_name     = app_name

    # Allow for backwards-compatibility with v2.0.0
    if auth_opts.is_a?(Hash)
      @access_token = auth_opts[:access_token]
      @user_token   = auth_opts[:user_token]
    else
      @access_token = auth_opts
    end
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
    query_and_build "masters/#{master_release_id}"
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
    get_user_folder_releases(username, 0, pagination)
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

  # Returns a specific release in a user’s wantlist by release id.
  #
  # If the wantlist has been made private by its owner, you must be authenticated as the owner to view it.
  #
  # The notes field will be visible if you are authenticated as the wantlist owner.
  #
  # @macro username
  # @macro release_id
  # @return [Hash] wantlist for the provided username
  def get_user_want(username, release_id)
    query_and_build "users/#{username}/wants/#{release_id}"
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
    if folder_id == 0 or authenticated?
      query_and_build "users/#{username}/collection/folders/#{folder_id}/releases", params
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
    if folder_id == 0 or authenticated?
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

  # Returns the list of listings in a user’s inventory. Accepts Pagination parameters.
  #
  # Basic information about each listing and the corresponding release is provided, suitable for display in a list. For detailed information about the release, make another API call to fetch the corresponding Release.
  #
  # If you are not authenticated as the inventory owner, only items that have a status of For Sale will be visible.
  #
  # If you are authenticated as the inventory owner you will get additional +weight+, +format_quantity+, and +external_id+ keys.
  #
  # @macro username
  # @param [Hash] params sort/order/pagination parameters
  # @option params [String] :status Only show items with this status
  # @option params [String] :sort Sort items by this field. One of:
  #   * +listed+
  #   * +price+
  #   * +item+ (i.e. the title of the release)
  #   * +artist+
  #   * +label+
  #   * +catno+
  #   * +audio+
  #   * +status+ (when authenticated as inventory owner)
  # @option params [String] :sort_order Sort items in a particular order. One of:
  #   * +asc+
  #   * +desc+
  # @return [Hash] listing in user's inventory
  def get_user_inventory(username, params={})
    query_and_build "users/#{username}/inventory", params
  end

  # View the data associated with a listing.
  #
  # If the authorized user is the listing owner the listing will include the +weight+, +format_quantity+, and +external_id+ keys.
  #
  # @!macro [new] listing_id
  #   @param listing_id [Integer] listing id
  # @return [Hash] listing with listing_id
  def get_listing(listing_id)
    query_and_build "marketplace/listings/#{listing_id}"
  end

  # Create a Marketplace listing.
  #
  # @macro need_auth
  #
  # @!macro [new] listing_params
  #   @param [Hash] data parameters for listing
  #   @option data [Integer (Required)] :release_id The ID of the release that this listing represents.
  #   @option data [String (Optional)] :condition The physical condition of the item. Must *EXACTLY* match one of:
  #     * +Mint (M)+
  #     * +Near Mint (NM or NM-)+
  #     * +Very Good Plus (VG+)+
  #     * +Very Good (VG)+
  #     * +Good Plus (G+)+
  #     * +Good (G)+
  #     * +Fair (F)+
  #     * +Poor (P)+
  #   @option data [String (Optional)] :sleeve_condition (+Not Graded+) The physical condition of the item's sleeve, case, or container. Must *EXACTLY* match one of:
  #     * +Mint (M)+
  #     * +Near Mint (NM or NM-)+
  #     * +Very Good Plus (VG+)+
  #     * +Very Good (VG)+
  #     * +Good Plus (G+)+
  #     * +Good (G)+
  #     * +Fair (F)+
  #     * +Poor (P)+
  #     * +Generic+
  #     * +Not Graded+
  #     * +No Cover+
  #   @option data [Float (Required)] :price The price of the item (in the seller's currency).
  #   @option data [String (Optional)] :comments Any remarks about the item that will be displayed to buyers.
  #   @option data [Boolean (Optional)] :allow_offers (false) Whether or not to allow buyers to make offers on the item. Defaults to +false+.
  #   @option data [String (Optional)] :status (+For Sale+) The status of the listing. Defaults to For Sale. Must *EXACTLY* match one of:
  #     * +For Sale+ - the listing is ready to be shown on the Marketplace
  #     * +Draft+ - the listing is not ready for public display
  #   @option data [String (Optional)] :external_id  A freeform field that can be used for the seller’s own reference. Information stored here will not be displayed to anyone other than the seller. This field is called “Private Comments” on the Discogs website.
  #   @option data [Float (Optional)] :weight The weight, in grams, of this listing, for the purpose of calculating shipping.
  #   @option data [Integer (Optional)] :format_quantity The number of items this listing counts as, for the purpose of calculating shipping. This field is called “Counts As” on the Discogs website.
  #   @return [Hash] listing metadata
  def create_listing(data={})
    authenticated? do
      query_and_build "marketplace/listings", {}, :post, data
    end
  end

  # Edit the data associated with a listing.
  #
  # If the listing’s status is not +For Sale+, +Draft+, or +Expired+, it cannot be modified – only deleted. To re-list a Sold listing, a new listing must be created.
  #
  # @macro need_auth
  #
  # @macro listing_id
  # @macro listing_params
  # @return [Boolean]
  def edit_listing(listing_id, data={})
    authenticated? do
      query_and_build "marketplace/listings/#{listing_id}", {}, :post, data
    end
  end

  # Permanently remove a listing from the Marketplace.
  #
  # @macro need_auth
  #
  # @macro listing_id
  # @return [Boolean]
  def delete_listing(listing_id)
    authenticated? do
      query_and_build "marketplace/listings/#{listing_id}", {}, :delete
    end
  end

  # View the data associated with an order.
  #
  # @macro need_auth
  #
  # @!macro [new] order_id
  #   @param order_id [Integer] order id
  # @return [Hash] order information
  def get_order(order_id)
    authenticated? do
      query_and_build "marketplace/orders/#{order_id}"
    end
  end

  # Edit the data associated with an order.
  #
  # The conditions under which an order is permitted to transition from one status to another are best summarized by a state diagram.
  #
  # http://www.discogs.com/developers/_images/order_state_transitions.png
  #
  # Rather than implementing this logic in your application, the response contains a next_status key – an array of valid next statuses for this order, which you can display to the user in (for example) a dropdown control. This also renders your application more resilient to any future changes in the order status logic.
  #
  # Changing the order status using this resource will always message the buyer with:
  #
  #   Seller changed status from Old Status to New Status
  #
  # and does not provide a facility for including a custom message along with the change. For more fine-grained control, use the Add a new message resource, which allows you to simultaneously add a message and change the order status.
  #
  # If the order status is neither +cancelled+, +Payment Received+, nor +Shipped+, you can change the shipping. Doing so will send an invoice to the buyer and set the order status to Invoice Sent. (For that reason, you cannot set the shipping and the order status in the same request.)
  #
  # @macro need_auth
  #
  # @macro order_id
  # @param [Hash] data order parameters
  # @option data [String (Optional)] :status The new status of the order. Must *EXACTLY* match one of:
  #   * +New Order+
  #   * +Buyer Contacted+
  #   * +Invoice Sent+
  #   * +Payment Pending+
  #   * +Payment Received+
  #   * +Shipped+
  #   * +Cancelled (Non-Paying Buyer)+
  #   * +Cancelled (Item Unavailable)+
  #   * +Cancelled (Per Buyer's Request)+
  #   * the order's current status
  #     - Furthermore, the new status must be present in the order’s next_status list. For more information about order statuses, see #edit_order[#edit_order-instance_method].
  # @option data [Float (Optional)] :shipping The order shipping amount.
  #
  #   As a side-effect of setting this value, the buyer is invoiced and the order status is set to +Invoice Sent+. For more information, see #edit_order[#edit_order-instance_method].
  # @return [Hash] order information
  def edit_order(order_id, data={})
    authenticated? do
      query_and_build "marketplace/orders/#{order_id}", {}, :post, data
    end
  end

  # Returns a list of the authenticated user’s orders. Accepts Pagination parameters.
  #
  # @macro need_auth
  #
  # @param [Hash] params status, sort, sort_order, and pagination parameters
  # @option params [String (Optional)] :status The new status of the order. Must *EXACTLY* match one of:
  #   * +All+
  #   * +New Order+
  #   * +Buyer Contacted+
  #   * +Invoice Sent+
  #   * +Payment Pending+
  #   * +Payment Received+
  #   * +Shipped+
  #   * +Merged+
  #   * +Order Changed+
  #   * +Cancelled+
  #   * +Cancelled (Non-Paying Buyer)+
  #   * +Cancelled (Item Unavailable)+
  #   * +Cancelled (Per Buyer's Request)+
  # @option params [String (Optional)] :sort Sort items with this field. Must *EXACTLY* match one of:
  #   * +id+
  #   * +buyer+
  #   * +created+
  #   * +status+
  #   * +last_activity+
  # @option params [String (Optional)] :sort_order Sort items in a particular order. Must *EXACTLY* match one of:
  #   * +asc+
  #   * +desc+
  # @option params [Hash (Optional)] :pagination Pagination parameters
  # @return [Hash] list of orders meeting specified criteria
  def list_orders(params={})
    authenticated? do
      query_and_build "marketplace/orders", params
    end
  end

  # Returns a list of the order’s messages with the most recent first. Accepts Pagination parameters.
  #
  # @macro need_auth
  #
  # @macro order_id
  # @macro uses_pagination
  # @return [Hash] messages for order
  def list_order_messages(order_id, pagination={})
   authenticated? do
     query_and_build "marketplace/orders/#{order_id}/messages", pagination
   end
  end

  alias_method :get_order_messages, :list_order_messages

  # Adds a new message to the order’s message log.
  #
  # When posting a new message, you can simultaneously change the order status. If you do, the message will automatically be prepended with:
  #   Seller changed status from Old Status to New Status\n\n
  # While message and status are each optional, one or both must be present.
  #
  # @macro need_auth
  #
  # @macro order_id
  # @param [Hash] data new message metadata
  # @option data [String (Optional)] :message The body of the message to send to the buyer.
  # @option data [String (Optional)] :status The new status of the corresponding order.
  #   * For more information about order statuses, see #edit_order[#edit_order-instance_method]
  # @return [Hash] created message metadata
  def create_order_message(order_id, data={})
    authenticated? do
      query_and_build "marketplace/orders/#{order_id}/messages", {}, :post, data
    end
  end

  # Retrieve price suggestions for the provided Release ID. If no suggestions are available, an empty object will be returned.
  #
  # Authentication is required, and the user needs to have filled out their seller settings. Suggested prices will be denominated in the user’s selling currency.
  #
  # @macro need_auth
  #
  # @macro release_id
  # @return [Hash] price suggestions information
  def get_price_suggestions(release_id)
    authenticated? do
      query_and_build "marketplace/price_suggestions/#{release_id}"
    end
  end

  # Calculate the fee for the provided price and currency.
  #
  # @param [Float] price price of item
  # @param [String (Optional)] currency currency to return the fee in. Must *EXACTLY* match one of:
  #   * +USD+
  #   * +GBP+
  #   * +EUR+
  #   * +CAD+
  #   * +AUD+
  #   * +JPY+
  def get_fee(price, currency="USD")
    query_and_build "marketplace/fee/#{price}/#{currency}"
  end

  # Retrieve an image by filename.
  #
  # It’s unlikely that you’ll ever have to construct an image URL; images keys on other resources use fully-qualified URLs, including hostname and protocol.
  #
  # @macro need_auth
  #
  # @param [String (Required)] filename the name of the image file
  # @return [Binary] binary image file
  def get_image(filename)
    authenticated? do
      if user_facing?
        @access_token.get("/images/#{filename}").body
      else
        query_api("images/#{filename}")
      end
    end
  end

  # Perform a search.
  #
  # @macro need_auth
  #
  # @param [String (Required)] term to search.
  # @return [Hash] search results
  def search(term, params={})
    authenticated? do
      parameters = {:q => term}.merge(params)
      query_and_build "database/search", parameters
    end
  end

  # Fetch response from API using a fully-qualified URL.
  #
  # @param [String (Required)] API endpoint
  # @return [Hash] API response
  def raw(url)
    uri    = URI.parse(url)
    params = CGI.parse(uri.query.to_s)

    query_and_build uri.path, params
  end

 private

  def query_and_build(path, params={}, method=:get, body=nil)
    parameters = {:f => "json"}.merge(params)
    data = query_api(path, params, method, body)

    if data != ""
      hash = JSON.parse(data)
      Hashie::Mash.new(sanitize_hash(hash))
    else
      Hashie::Mash.new
    end
  end

  # Queries the API and handles the response.
  def query_api(path, params={}, method=:get, body=nil)
    response = make_request(path, params, method, body)

    raise_unknown_resource(path) if response.code == "404"
    raise_authentication_error(path) if response.code == "401"
    raise_internal_server_error if response.code == "500"

    # Unzip the response data, or just read it in directly
    # if the API responds without gzipping.
    response_body = nil
    begin
      inflated_data = Zlib::GzipReader.new(StringIO.new(response.body.to_s))
      response_body = inflated_data.read
    rescue Zlib::GzipFile::Error
      response_body = response.body
    end

    response_body.to_s
  end

  # Generates a HTTP request and returns the response.
  def make_request(path, params, method, body)
    full_params   = params.merge(auth_params)
    uri           = build_uri(path, full_params)
    formatted     = "#{uri.path}?#{uri.query}"
    output_format = full_params.fetch(:f, "json")
    headers       = {"Accept"          => "application/#{output_format}",
                     "Accept-Encoding" => "gzip,deflate",
                     "User-Agent"      => @app_name}

    if any_authentication?
      if [:post, :put].include?(method)
        headers["Content-Type"] = headers["Accept"]

        if user_facing?
          @access_token.send(method, formatted, JSON(body), headers)
        else
          HTTParty.send(method, uri, {headers: headers, body: JSON(body)})
        end
      else
        if user_facing?
          @access_token.send(method, formatted, headers)
        else
          HTTParty.send(method, uri, headers: headers)
        end
      end
    else
      # All non-authenticated endpoints are GET.
      HTTParty.get(uri, headers: headers)
    end
  end

  def build_uri(path, params={})
    output_format = params.fetch(:f, "json")
    parameters    = {:f => output_format}.merge(params)
    querystring   = "?" + URI.encode_www_form(prepare_hash(parameters))

    URI.parse(File.join(@@root_host, [URI.escape(path), querystring].join))
  end

  # Stringifies keys and sorts.
  def prepare_hash(h)
    result = Hash[
      h.map do |k, v|
        [k.to_s, v]
      end
    ]

    result.sort
  end

  # Replaces known conflicting keys with safe names in a nested hash structure.
  def sanitize_hash(hash)
    conflicts = {"count" => "total"}
    result = {}

    for k, v in hash
      safe_name = conflicts[k]

      if safe_name
        # BC: Temporary set original key for backwards-compatibility.
        warn "[DEPRECATED]: The key '#{k}' has been replaced with '#{safe_name}'. When accessing, please use the latter. This message will be removed in the next major release."
        result[k] = v
        # End BC

        result[safe_name] = v
        k = safe_name
      else
        result[k] = v
      end

      if v.is_a?(Hash)
        result[k] = sanitize_hash(result[k])
      end
    end

    result
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
