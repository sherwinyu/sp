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

=begin
  method_name = options[:method] || :sender_to_recipient

  # template_name = options[:template] || "#{__method__}_#{referral.client.key}"
  # options[:template] ||= options[:template] || method_name

  data = Multimap.new

  mail = ReferralMailer.send method_name, referral, options
  data[:from] = mail.from
  data[:to] = mail.to

  data[:subject] = mail.subject #"Hello"
  data[:text] = mail.text_part.body # "Testing some Mailgun awesomness!"
  data[:html] = mail.html_part.body # "<html>HTML version of the body</html>"
  data['o:campaign']='newliving'
  data['o:testmode'] = true if Rails.env.testing? || Rails.env.development?
  data
end

def self.mailgun_deliver data_hash
  domain = Figaro.env.mailgun_api_domain
  url = "https://api:#{Figaro.env.MAILGUN_API_KEY}@api.mailgun.net/v2/#{domain}/messages"
  logger.info url
  logger.info data_hash.inspect
  logger.info RestClient.post url, data_hash
end
=end
end
