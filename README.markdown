Discogs::Wrapper
================

NOTE
----
  We are currently working on the next release of the API. It will implement all endpoints, pagination, have oAuth support, and use JSON exclusively.

  Expecting to finish late-May, 2014.

ABOUT
-----
  A 100% Ruby wrapper of the Discogs.com API.

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
    search          = wrapper.search("Necrovore", :per_page => 10, :type => :artist)

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

  Many of the API endpoints return further URLs that will yield specific data. To cater for this, the library provides a "raw" method that accepts a valid API URL. For example:

    sts_records       = wrapper.get_label(9800)
    sts_releases      = wrapper.raw(sts_records.releases_url)
    first_sts_release = wrapper.raw(sts_releases.releases[1].resource_url)

    first_sts_release.title  # => "I'll Nostra Tempo De La Vita / Having The Time Of Your Life"

AUTHENTICATION
--------------
  Many of the API endpoints require the user to be authenticated via oAuth. The library provides support for this.

  - Try, fail
  - oAuth dance
  - Redirect, get access token
  - Try, succeed.

PAGINATION
----------
  Demonstrate pagination parameters.

LICENSE
-----
  See the LICENCE file. Copyright (c) Andrew Buntine

CONTRIBUTORS
------------
  List all contributors.
