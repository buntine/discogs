Discogs::Wrapper
================

ABOUT
-----
  A 100% Ruby wrapper of the Discogs.com API. No dependencies, no extra gems. :)

  Discogs::Wrapper abstracts all the nasty boilerplate code needed to interact with the Discogs API. It gives you direct access to the information you need.

  The master branch aims to give full support for version 2.0 of the API. If you need support for everything in version 1.0, see the api-v1 branch.

  Specifically:

  * Artists
  * Releases
  * Labels
  * Searching (all of the above)

  Please, [see the Wiki](http://github.com/buntine/discogs/wiki) for helpful documentation.

  The Discogs API is [documented here](http://www.discogs.com/help/api).

INSTALLATION
------------
  You can install the library via Rubygems:

    $ gem sources -a http://gems.github.com
    $ sudo gem install buntine-discogs

USAGE
-----
  To use this library, you must supply a valid Discogs API key.

    require 'discogs'
    wrapper = Discogs::Wrapper.new("my_api_key")

  Accessing information is easy:

    artist = wrapper.get_artist("Master's Hammer")
    release = wrapper.get_release("611973") # Supply an ID.
    label = wrapper.get_label("Monitor Records")
    search_results = wrapper.search("Necrovore")

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
-------

<a rel="license" href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by/3.0/80x15.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Discogs::Wrapper</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/buntine/discogs" property="cc:attributionName" rel="cc:attributionURL">Andrew Buntine</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="http://www.discogs.com/help/api" rel="dct:source">www.discogs.com</a>.
