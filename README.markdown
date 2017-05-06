Discogs::Wrapper
================

ABOUT
-----
  A Ruby wrapper of the Discogs.com API v2.0.

  Discogs::Wrapper abstracts all of the boilerplate code needed to interact with the Discogs API. It gives you direct access to the information you need. All methods return a ruby Hash wrapped in a [Hashie](https://github.com/intridea/hashie) object with the same structure as documented on the [Discogs API website](http://www.discogs.com/developers/index.html).

  The master branch aims to give full support for version 2.0 of the API. If you need support for everything in version 1.0, see the api-v1 branch.

  Specifically:

  * Artists
  * Releases
  * Master Releases
  * Labels
  * Images
  * Searching (all of the above)
  * Marketplace
  * User Inventories
  * Orders
  * Fee Calculations
  * Price Suggestions
  * User Profiles
  * Collections
  * Wantlists
  * oAuth
  * Pagination / Sorting


DOCUMENTATION
------------
  You can read the documentation at [this projects RDoc page](http://rdoc.info/github/buntine/discogs/master/frames).

  The Discogs API is [documented here](http://www.discogs.com/developers/index.html).


INSTALLATION
------------
  You can install the library via Rubygems:

    $ gem install discogs-wrapper

  Or, if you are using Bundler:

    gem "discogs-wrapper"


USAGE
-----
  To use this library, you must supply the name of your application. For example:

```ruby
wrapper = Discogs::Wrapper.new("My awesome web app")
```

  Accessing information is easy:

```ruby
artist          = wrapper.get_artist("329937")
artist_releases = wrapper.get_artist_releases("329937")
release         = wrapper.get_release("1529724")
label           = wrapper.get_label("29515")

# You must be authenticated in order to search. I provide a few ways to do this. See the AUTHENTICATION section below.
auth_wrapper = Discogs::Wrapper.new("My awesome web app", user_token: "my_user_token")
search       = auth_wrapper.search("Necrovore", :per_page => 10, :type => :artist)

artist.name                          # => "Manilla Road"
artist.members.count                 # => 4
artist.members.first.name            # => "Mark Shelton"
artist.profile                       # => "Heavy Metal band from ..."

artist_releases.releases.count       # => 35
artist_releases.releases.first.title # => "Invasion"

release.title                        # => "Medieval"
release.labels.first.name            # => "New Renaissance Records"
release.formats[0].descriptions[0]   # => "12\""
release.styles                       # => [ "Heavy Metal", "Doom Metal" ]
release.tracklist[1].title           # => "Death is Beauty"

label.name                           # => "Monitor (2)"
label.sublabels.count                # => 3

search.pagination.items              # => 2
search.results.first.title           # => "Necrovore"
search.results.first.type            # => "artist"
search.results.first.id              # => 691078
```

  Many of the API endpoints return further URLs that will yield specific data. To cater for this, the library provides a "raw" method that accepts a valid API URL. For example:

    sts_records       = wrapper.get_label(9800)
    sts_releases      = wrapper.raw(sts_records.releases_url)
    first_sts_release = wrapper.raw(sts_releases.releases[1].resource_url)

    first_sts_release.title  # => "I'll Nostra Tempo De La Vita / Having The Time Of Your Life"

  You can see all implemented methods on [this projects RDoc page](http://rdoc.info/github/buntine/discogs/master/frames).


SANITIZATION
------------
  The Discogs.com API uses the name "count" in several places, which is sanitized to "total" in this gem in order to prevent overriding the `count` attribute of `Hash`.

  For example:

```ruby
release.rating.count # => Returns number of keys in "rating" Hash.
release.rating.total # => Returns total number of ratings as per Discogs API response.
```


AUTHENTICATION
--------------
  Many of the API endpoints require the user to be authenticated via oAuth. The library provides support for this.

  For non user-facing apps (when you only want to authenticate as yourself), you can simply pass your user token (generated from your API dashboard) to the constructor. For example:

    wrapper = Discogs::Wrapper.new("Test OAuth", user_token: "my_user_token")
    results = wrapper.search("Nick Cave")

  For user-facing apps, I've provided [a simple Rails application](https://github.com/buntine/discogs-oauth) that demonstrates how to perform authenticated requests.

  Make sure you've created an "app" in your developer settings on the Discogs website. You will need your consumer key and consumer secret.

  Basically, you should preform the "oAuth dance" like so:

```ruby
# Add an action to initiate the process.
def authenticate
  @discogs     = Discogs::Wrapper.new("Test OAuth")
  request_data = @discogs.get_request_token("YOUR_APP_KEY", "YOUR_APP_SECRET", "http://127.0.0.1:3000/callback")

  session[:request_token] = request_data[:request_token]

  redirect_to request_data[:authorize_url]
end

# And an action that Discogs will redirect back to.
def callback
  @discogs      = Discogs::Wrapper.new("Test OAuth")
  request_token = session[:request_token]
  verifier      = params[:oauth_verifier]
  access_token  = @discogs.authenticate(request_token, verifier)

  session[:request_token] = nil
  session[:access_token]  = access_token

  @discogs.access_token = access_token

  # You can now perform authenticated requests.
end

# Once you have it, you can also pass your access_token into the constructor.
def another_action
  @discogs = Discogs::Wrapper.new("Test OAuth", access_token: session[:access_token])

  # You can now perform authenticated requests.
end
```


PAGINATION
----------
  All API endpoints that accept pagination, sorting or other parameters are supported.
 
  Page defaults to 1, page size defaults to 50.

```ruby
wrapper.get_artist_releases(345211, :page => 2, :per_page => 10)
```

  If other params are accepted, they can also be passed:

```ruby
wrapper.get_user_inventory("username", :page => 3, :sort => "price", :sort_order => "asc")
```


LICENSE
-----
  See the LICENCE file. Copyright (c) Andrew Buntine


CONTRIBUTORS
------------
  [Thank you for the support](https://github.com/buntine/discogs/graphs/contributors)
