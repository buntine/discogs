
## Discogs::Wrapper
##   Copyright Andrew Buntine
##   
##   This library provides full access to the Discogs.com API v2.0
##
##   Please file all bug reports at http://www.github.com/buntine/discogs, or
##   email me at info@andrewbuntine.com.
##
##   Enjoy!

# Application namespace.
module Discogs; end

# Custom exceptions.
class Discogs::UnknownResource < Exception; end
class Discogs::InternalServerError < Exception; end
class Discogs::AuthenticationError < Exception; end

# Loading sequence.
require File.dirname(__FILE__) + "/wrapper/wrapper"
