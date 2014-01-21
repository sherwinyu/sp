class LastFmDp < DataPoint
  # TODO(syu): convert to entities?
  # field :at, type: Time
  field :artist, type: String
  field :name, type: String
  field :album, type: String

  def as_json
    DataPointSerializer.new(self).as_json['data_point']
  end

  def details
    {
      artist: artist,
      name: name,
      album: album,
    }.as_json
  end
end
