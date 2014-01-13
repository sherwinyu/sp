class LastFmDp < DataPoint
  # TODO(syu): convert to entities?
  field :at, type: Time
  field :artist, type: String
  field :name, type: String
  field :album, type: String
end
