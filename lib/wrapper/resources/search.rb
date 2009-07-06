# Represents a search resultset in the Discogs API.

class Discogs::Search < Discogs::Resource

  no_mapping

  attr_accessor :exactresults,
                :searchresults,
                :start,
                :end,
                :numResults

  def total_results
    self.numResults.to_i
  end

end
