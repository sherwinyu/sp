class Act
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  field :duration,  type: Integer
  field :canonical_day, type: Date
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  auto_increment :seq_id

  # before_create :set_seq_id
  def set_seq_id
    # if self.id.class == BSON::ObjectId
    counter = Mongoid.database["counters"].find_and_modify(
      query: { _id:  "act" },
      update: { "$inc" => {count: 1} })
    self.seq_id = Integer(counter["count"])
    #end
  end

  embeds_one :detail

  validates_presence_of :description

end


=begin
  details:
    field name type string
    embeds_many children_details

details =
  name:

productivity

{ name: all details
  children: [
    { }
    { }
    { }
    { name: productivity, value: 100 }



}

productivity: 100
sleep:
  duration: 8.5
  time_asleep: 3am
  time_awake: 11.5pm
  tiredness_on_sleep: 4
  dreamed: true

workout:
  bench_press: [ {weight: 135, reps: 5}, {weight: 135, reps: 5}, {weight: 135, reps: 4, negatives: true} ]
  cardio: [ {weight: 135, reps: 5}, {weight: 135, reps: 5}, {weight: 135, reps: 4, negatives: true} ]
  feeling: 8

-->
  { name: workout
    details: [
      {
        name: bench_press
        children: [
          { name: bench_press set
            details:






THINGS TO TEST
  ember-data arrays
  ember-data codecs for 'polymorphic value'
  how to store arbitrarily complicated data?

  storing everything in the same model (Act.detail = DS.attr... something) --- works!
  having views descend from that model
    ember paths for non ember attrs?  arbitrary objects..

  enumerable (flat) object


  detail view.hbs:
  ===============

  {{#each in key val in json}}
    ifIsObject val
    ifIsArray val
    else
      key: value

  {{/each}}


Ember.EnumerableJSONObject
===
Besides asdfs


=end


