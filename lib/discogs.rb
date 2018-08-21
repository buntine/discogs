
## Discogs::Wrapper
##   Copyright Andrew Buntine
##   
##   This library provides full access to the Discogs.com API v2.0
##
##   Please file all bug reports at https://www.github.com/buntine/discogs.
##
##   Enjoy!

# Application namespace.
module Discogs; end

# Custom exceptions.
class Discogs::UnknownResource < StandardError; end
class Discogs::InternalServerError < StandardError; end
class Discogs::AuthenticationError < StandardError; end

# Loading sequence.
require File.dirname(__FILE__) + "/wrapper/wrapper"
