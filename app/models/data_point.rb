class DataPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitted_at, type: Time
  field :details
  def self.zorg_it(opts={})
    data = Hash.new
    data[:key] = Figaro.env.RESCUETIME_TOKEN
    data[:format] = 'json'
    # data[:operation] = 'select'
    # data[:version] = '0'
    end_string = Time.now.strftime "%Y-%m-%d"
    start_string = 1.day.ago.strftime "%Y-%m-%d"
    data.merge!( {
      perspective: "interval",
      resolution_time: "hour",
      restrict_begin: end_string,
      restrict_end: end_string
    })
    data.merge! opts
    p "Calling rescuetime with:", data
    url = "https://www.rescuetime.com/anapi/data"
    json = Hashie::Mash.new JSON.parse(RestClient.post url, data)
  end
  def self.examine hashie
    zug = hashie.rows.map do |activity|
      pick = activity.values_at 0, 1, 3
      pick[1] = Time.at(pick[1]).utc.strftime "%Mm %Ss"
      pick
    end
    pp zug
  end
  def self.import_from_rescue_time hashie

  end
  def self.instantiate_from_rescuetime_hour
end
