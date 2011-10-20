# Represents an artist's release in the Discogs API.

require File.dirname(__FILE__) + "/artist"

class Discogs::Artist::Release < Discogs::Resource

  attr_accessor :id,
                :status,
                :role,
                :title,
                :artist,
                :format,
                :year,
                :label,
                :thumb,
                :trackinfo,
                :main_release

  # Will return either "master" or "release".
  def release_type
    if original_content =~ /^\<(\w+)\s/
      $1
    else
      "release"
    end
  end

end
