class LastFmImporter
  def self.url
    "http://ws.audioscrobbler.com/2.0/"
  end

  def self.time_start
    LastFmDp.latest.try(:at) || Time.current - 1.hour
  end

  def self.time_end
    Time.current
  end

  def self.api_params
    data = Hash.new
    data[:method] = "user.getrecenttracks"
    data[:user] = Figaro.env.LASTFM_USERNAME
    data[:api_key] = Figaro.env.LASTFM_API_KEY
    data[:format] = "json"

    #  Both `from` and `to` need to be specified to work
    data[:from] = time_start.to_i
    data[:to] = time_end.to_i
    data[:limit] = 200
    return data
  end
  def self.ourl
    "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=rj&api_key=86158cfaa9584d43627c28c54aa68410&format=json"
  end

=begin
      "@attr" => {
                "user" => "xhuwin",
                "page" => "1",
             "perPage" => "200",
          "totalPages" => "1",
               "total" => "1"
      }
=end
  def self.raw_query
    RestClient.log = Logger.new(STDOUT)
    p = api_params
    json = Hashie::Mash.new JSON.parse(RestClient.get url, params: p)
    return json
  end


  def self.import
    report = {}
    report[:start] = Time.at(api_params[:from])
    report[:end] = Time.at(api_params[:to])
    report[:existing_lfmdps] = 0
    report[:new_lfmdps] = 0

    last_fm_json = self.raw_query

    tracks = last_fm_json.recenttracks.track
    # We're currently assuming that there will never be more than one page of the results

    # If tracks were found
    if tracks
      # If more than one page was returned
      if last_fm_json["recenttracks"]["@attr"]["totalPages"].to_i > 1
        report[:more_than_one_page] = true
        Util::Log.warn "Last FM Import: more than one page returned", report
      end
    else
      report[:no_tracks_found] = true
      Util::Log.warn "Last FM Import: no tracks returned", report
    end

    if tracks
      tracks.each{ |track| self.instantiate_dp_from_payload(track, report) }
    end

    Util::Log.mixpanel.track "last_fm_import", report
    return report
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
  def self.instantiate_dp_from_payload(track, report=nil)

    # Skip songs that haven't been saved yet
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
      if report
        report[:existing_lfmdps] += 1
      end
      ap last_fm_params
      Util::Log.warn "Last Fm Import clash", last_fm_params
    else
      if report
        report[:new_lfmdps] += 1
      end
      puts "Importered:"
      ap last_fm_params
    end
    raise "Error" unless dp.save
  end

end
