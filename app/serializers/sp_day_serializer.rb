class SpDaySerializer < ActiveModel::Serializer
  attributes :id, :date, :note, :yesterday_id, :tomorrow_id
  has_one :sleep

  def yesterday_id
    object.yesterday.try :id
  end

  def tomorrow_id
    object.tomorrow.try(:id)
  end
end
