
# Application namespace.
module Discogs; end

# Custom exceptions.
class Discogs::InvalidAPIKey < Exception; end

# Loading sequence.
require File.dirname(__FILE__) + "/wrapper/wrapper"
#require File.dirname(__FILE__) + "/wrapper/release"
