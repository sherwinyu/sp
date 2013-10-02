class RescueTimeRaw
  include Mongoid::Document
  include Mongoid::Timestamps
  field :synced_at, type: Time
  field :rt_date
  field :rt_time_spent
  field :rt_number_of_people, type: Integer
  field :rt_activity, type: String
  field :rt_category, type: String
  field :rt_productivity, type: Integer



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
  def self.import
    h = self.zorg_it
    h.rows.each do |row|
      rtr = RescueTimeRaw.create(
        synced_at: Time.now,
        rt_date: row[0],
        rt_time_spent: row[1],
        rt_number_of_people: row[2],
        rt_activity: row[3],
        rt_category: row[4],
        rt_productivity: row[5]
      )
    end

     #headers: ["Date", "Time Spent (seconds)", "Number of People",
    #"Activity", "Category", "Productivity"]
  end

  def time
    Time.parse rt_date rescue nil
  end

  def date
    Date.parse rt_date
  end

  def hour
    time.hour
  end

  def pretty_hour
    t1 = time
    t2 = time + 1.hour
    "#{t1.hour}:00-#{t2.hour}:00"
  end

  def duration
    rt_time_spent.seconds
  end

  def pretty_duration
    Time.at(duration).utc.strftime "%Mm %Ss"
  end

  def activity
    rt_activity
  end

  def name
    rt_activity
  end

  def productivity
    rt_productivity
  end

  def category
    rt_category
  end
end
