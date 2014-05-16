Discogs::Wrapper
================

NOTE
----

  We are currently working on the next release of the API. It will implement all endpoints, pagination, have oAuth support, and use JSON exclusively.

  Expecting to finish mid-May, 2014.

ABOUT
-----
  A 100% Ruby wrapper of the Discogs.com API.

  Discogs::Wrapper abstracts all the nasty boilerplate code needed to interact with the Discogs API. It gives you direct access to the information you need.

  The master branch aims to give full support for version 2.0 of the API. If you need support for everything in version 1.0, see the api-v1 branch.

  Specifically:

  * Artists
  * Releases
  * MasterReleases
  * Labels
  * Searching (all of the above)

  Please, [see the Wiki](http://github.com/buntine/discogs/wiki) for helpful documentation.

  The Discogs API is [documented here](http://www.discogs.com/help/api).

INSTALLATION
------------
  You can install the library via Rubygems:

    $ sudo gem install discogs-wrapper

USAGE
-----
  To use this library, you must supply the name of your application. For example:

    require 'discogs'
    wrapper = Discogs::Wrapper.new("My awesome web app")

  Accessing information is easy:

    artist = wrapper.get_artist("Master's Hammer")
    release = wrapper.get_release("611973") # Supply an ID.
    label = wrapper.get_label("Monitor Records")
    search = wrapper.search("Necrovore")

    artist.name                         # => "Master's Hammer"
    artist.releases[0].title            # => "Finished"
    artist.releases[1].year             # => "1989"
    artist.releases[4].extraartists     # => [ "Arakain", "Debustrol" ]

    release.title                       # => "Ritual"
    release.labels[0].name              # => "Osmose Productions"
    release.formats[0].descriptions[0]  # => "LP"
    release.styles                      # => [ "Black Metal", "Death Metal" ]
    release.tracklist[1].title          # => "Pad modly"

    label.images[0].width               # => "220"
    label.releases.length               # => 22
    label.releases[3].artist            # => "Root"
    label.releases[7].catno             # => "MON007"

    search.total_results                # => 124
    search.total_pages                  # => 7
    search.current_page                 # => 1

    # Exact results
    search.exact[0].type                # => "artist"
    search.exact[0].title               # => "Necrovore"
    search.exact(:label)[0].title       # => "Necrovores Records"
    search.closest(:artist)             # => <Discogs::Search::Result:0x324ad3e2>

    # All results
    search.results[3].title             # => "Necrovore - Demo '87"
    search.results[3].summary           # => "First and only demo tape"
    search.results(:release)[0]         # => <Discogs::Search::Result:0x343de34a>

LICENSE
-----

See the LICENCE file. Copyright (c) Andrew Buntine
