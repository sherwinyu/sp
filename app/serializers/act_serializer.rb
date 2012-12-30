class ActSerializer < ActiveModel::Serializer
  attributes :id, :description, :duration, :start_time, :end_time, :errors, :detail
  def attributes
    hash = super
  end
  has_one :detail
end
