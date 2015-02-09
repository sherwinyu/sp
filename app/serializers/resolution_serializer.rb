class ResolutionSerializer < ActiveModel::Serializer
  attributes :id, :text, :group, :frequency, :type, :current_count, :target_count, :completions

  def id
    object.id.to_s
  end

  def current_count
    object.completions.try :length
  end

end
