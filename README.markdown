Discogs::Wrapper
================

NOTE
----
  We are currently working on the next release of the API. It will implement all endpoints, pagination, have oAuth support, and use JSON exclusively.

  Expecting to finish late-May, 2014.

ABOUT
-----
  A 100% Ruby wrapper of the Discogs.com API.

  Discogs::Wrapper abstracts all of the boilerplate code needed to interact with the Discogs API. It gives you direct access to the information you need.

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


  The Discogs API is [documented here](http://www.discogs.com/developers/index.html).

INSTALLATION
------------
  You can install the library via Rubygems:

    $ gem install discogs-wrapper

  Or within your Gemfile:

    gem "discogs-wrapper"

USAGE
-----
  To use this library, you must supply the name of your application. For example:

    require 'discogs'
    wrapper = Discogs::Wrapper.new("My awesome web app")

  Accessing information is easy:

    artist          = wrapper.get_artist("329937")
    artist_releases = wrapper.get_artist_releases("329937")
    release         = wrapper.get_release("1529724")
    label           = wrapper.get_label("29515")
    search          = wrapper.search("Necrovore", :per_page => 10)

    artist.name                         # => "Manilla Road"
    artist.members.count                # => 7
    artist.profile                      # => "Heavy Metal band from ..."

    release.title                       # => "Ritual"
    release.labels[0].name              # => "Osmose Productions"
    release.formats[0].descriptions[0]  # => "LP"
    release.styles                      # => [ "Black Metal", "Death Metal" ]
    release.tracklist[1].title          # => "Pad modly"

    label.name                          # => "Monitor Records"

    search.total_results                # => 124
    search.total_pages                  # => 7
    search.current_page                 # => 1

AUTHENTICATION
--------------
  Many of the API endpoints require the user to be authenticated via oAuth. The library provides support for this.

  - Try, fail
  - oAuth dance
  - Redirect, get access token
  - Try, succeed.

LICENSE
-----

See the LICENCE file. Copyright (c) Andrew Buntine
