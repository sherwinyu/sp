# Approximately represents one unit of work
# One pomodoro
=begin
  Note
    NoteItem
    NoteItem
    NoteItem

  Adding warg to warg
    Error(NoteItem)
      = Body: "Error blarblarblarblarblar"
      = Tags: {error: 1, ruby: 1}

So while using the editor:

Note(Goal): finish front end for Note
  NoteItem(objective)
    = Body: Clean up CSS
    = Type: "Objective"
    = Tags: {estimate: 25min}
  NoteItem(objective)
    = Body: Clean up CSS
    = Tags: (objective)

Note(): Cleaning up CSS reference
  = references NoteItem(objective){body: Clean up CSS}
  NoteItem(reference






=end
SearchIndex on NoteItem.body



class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  embeds_many :note_items
end
