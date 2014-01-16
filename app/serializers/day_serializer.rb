class DaySerializer < ActiveModel::Serializer
  attributes :id, :date, :note, :yesterday_id, :tomorrow_id
  has_one :sleep
  has_one :summary
  has_many :goals

  def id
    date.to_s
  end

  def yesterday_id
    object.yesterday.try :date
  end

  def tomorrow_id
    object.tomorrow.try :date
  end
end
