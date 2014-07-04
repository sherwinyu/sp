class NoteItemSerializer < ActiveModel::Serializer
  attributes :body, :tags, :ts
end
