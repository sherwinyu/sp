# To be a singleton class
class Option
  include Mongoid::Document
  field :current_timezone

  def self.opts
    self.first_or_create
  end

  ##
  # Represents the timezone for FUTURE events (e.g., current timezone).
  # Defaults to US/Eastern
  #
  # @return [String]
  def self.current_timezone
    opts.current_timezone or fail "No current timezone found!"
  end

  def self.current_timezone=(arg)
    opts.update_attribute :current_timezone, arg
  end

  def self.list_available_timezones
    ActiveSupport::TimeZone::MAPPING.values
  end

end

