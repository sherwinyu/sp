class NoteSerializer < ActiveModel::Serializer
  attributes :id, :body
  def id
    object.id.to_s
  end
end
