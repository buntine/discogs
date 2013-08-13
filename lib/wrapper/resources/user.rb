# Represents an user in the Discogs API.

class Discogs::User < Discogs::Resource

  no_mapping

  attr_accessor :username,
                :uri,
                :name

end
