class NoteSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_many :note_items

  def id
    object.id.to_s
  end
end
