class ActSerializer < ActiveModel::Serializer
  attributes :id, :description, :duration, :start_time, :end_time, :errors, :details
  def attributes
    hash = super
  end

  has_many :details
end
