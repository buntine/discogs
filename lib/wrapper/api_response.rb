# A wrapper around REXML::Document for handling API responses.

require 'rexml/document'
require 'zlib'
require 'stringio'

class Discogs::APIResponse < REXML::Document

  # Inflates the compressed response before loading it into the document.
  def self.prepare(compressed_data)
    inflated_data = Zlib::GzipReader.new(StringIO.new(compressed_data))
    new(inflated_data.read)
  end

  def valid?
    @valid ||= (self.root.attributes['stat'] == 'ok')
  end

  # Number of requests in the last 24 hour period (for this IP).
  def requests
    @requests ||= self.root.attributes['requests']
  end

end
