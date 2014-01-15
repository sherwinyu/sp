class LastFmImporter
  def self.url
    "http://ws.audioscrobbler.com/2.0/"
  end

  def self.api_params
    data = Hash.new
    data[:method] = "user.getrecenttracks"
    data[:user] = "xhuwin"
    data[:api_key] = "ea1576ad4d340a32e801c4f94c43c5f8"
    data[:format] = "json"
    data
  end
  def self.ourl
    "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=rj&api_key=86158cfaa9584d43627c28c54aa68410&format=json"
  end
  def self.raw_query
    RestClient.log = Logger.new(STDOUT)
    p = api_params
    json = Hashie::Mash.new JSON.parse(RestClient.get url, params: p)
  end
  def self.import
    last_fm_json = self.raw_query
    tracks = last_fm_json.recenttracks.track
    tracks.each{ |track| self.instantiate_dp_from_payload track }

    report = {}

    # rtrs = rescue_time_json.rows.map{ |row| instantiate_rescue_time_raw_from_row row, report }
    # rtdps = instantiate_rtdps_from_rtrs rtrs, report
    # return rtdps, report
  end

  ##
  #
  # @param track JSON track
  #   -
  #
  #       "artist" => {
  #       "#text" => "Childish Gambino",
  #        "mbid" => "7fb57fba-a6ef-44c2-abab-2fa3bdee607e"
  #   },
  #         "name" => "R.I.P. (ft. Bun B) {prod. Childish Gambino}",
  #   "streamable" => "0",
  #         "mbid" => "",
  #        "album" => {
  #       "#text" => "R O Y A L T Y",
  #        "mbid" => ""
  #   },
  #          "url" => "http://www.last.fm/music/Childish+Gambino/_/R.I.P.+(ft.+Bun+B)+%7Bprod.+Childish+Gambino%7D",
  #        "image" => [
  #       [0] {
  #           "#text" => "http://userserve-ak.last.fm/serve/34s/79694515.png",
  #            "size" => "small"
  #       },
  #       [1] {
  #           "#text" => "http://userserve-ak.last.fm/serve/64s/79694515.png",
  #            "size" => "medium"
  #       },
  #       [2] {
  #           "#text" => "http://userserve-ak.last.fm/serve/126/79694515.png",
  #            "size" => "large"
  #       },
  #       [3] {
  #           "#text" => "http://userserve-ak.last.fm/serve/300x300/79694515.png",
  #            "size" => "extralarge"
  #       }
  #   ],
  #         "date" => {
  #       "#text" => "13 Jan 2014, 16:52",
  #         "uts" => "1389631960"
  #   }
  def self.instantiate_dp_from_payload track
    return unless track.try(:date)
    puts track.date.uts
    last_fm_params = {
      at: Time.at(track.date.uts.to_i),
      artist: track.artist["#text"],
      name: track.name,
      album: track.album["#text"]
      }
    dp = LastFmDp.find_or_initialize_by last_fm_params
    if dp.persisted?
      puts "Last Fm Clash!"
      ap last_fm_params
      Util::Log.warn "Last Fm Import clash", last_fm_params
    end
    raise "Error" unless dp.save
  end

end
