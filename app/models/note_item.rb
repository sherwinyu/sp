class NoteItem
  include Mongoid::Document
  field :ts, type: Date
  field :body, type: String
  field :tags

  embedded_in :note
end
