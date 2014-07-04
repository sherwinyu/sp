class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  embeds_many :note_items
end
