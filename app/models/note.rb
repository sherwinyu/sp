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

Note Model
  maybe note model should just have a lot of optional params
    like is_pomodoro?
  Pomodoro start

  Where do we declare goals and estimates?

  NoteItem: Pomodoro start


Note(): Cleaning up CSS reference
  = references NoteItem(objective){body: Clean up CSS}
  NoteItem(reference


TextIndex on NoteItem.body
TextIndex on Note.note_items.body


KILLER FEATURES
  Error (log an error)
  Problem (log an higher level issue)
  Attempts (log attempts at the problem)

=end



class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  embeds_many :note_items
end
