class DataPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitted_at, type: Time
  field :details
  def self.zorg_it
    data = Hash.new
    data[:key] = Figaro.env.RESCUETIME_TOKEN
    data[:format] = 'json'
    # data[:operation] = 'select'
    # data[:version] = '0'
    data.merge!( {
      perspective: "interval",
      resolution_time: "hour",
      restrict_begin: "2013-09-01",
      restrict_end: "2013-09-03"
    })
    url = "https://www.rescuetime.com/anapi/data"
    json = JSON.parse(RestClient.post url, data)
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
