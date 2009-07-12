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

  def current_page
    (start.to_i / page_size) + 1
  end

  def exact(filter=nil)
    filter_results(filter, self.exactresults)
  end

  def results(filter=nil)
    filter_results(filter, self.searchresults)
  end

 private

  # An easy way for filtering a particular "type" of result (Artist, Release, etc)
  def filter_results(filter, results)
    if filter.nil?
      results
    else
      results.find_all do |result|
        result.type == filter.to_s
      end
    end
  end

  def page_size
    self.end.to_i - (self.start.to_i - 1)
  end

end
