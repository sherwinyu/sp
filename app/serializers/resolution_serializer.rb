class ResolutionSerializer < ActiveModel::Serializer
  attributes :id, :text, :group, :frequency, :type, :count, :completions

  def id
    object.id.to_s
  end

end
