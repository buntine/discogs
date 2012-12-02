# Represents an artist in the Discogs API.

class Discogs::Artist < Discogs::Resource

  no_mapping

  attr_accessor :name,
                :realname,
                :images,
                :urls,
                :namevariations,
                :aliases,
                :members,
                :releases,
                :profile,
                :data_quality

  def main_releases
    filter_releases("Main")
  end

  def bootlegs
    filter_releases("UnofficialRelease")
  end

  def appearances
    filter_releases("Appearance")
  end

 private

  # Simple helper for filtering a particular role of release.
  def filter_releases(role)
    self.releases.find_all do |release|
      release.role == role
    end
  end

end
