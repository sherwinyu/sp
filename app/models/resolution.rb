class Resolution
  include Mongoid::Document
  include Mongoid::Timestamps

  # key is a (temporary) identifier used to uniquely identify a resolution
  field :key, type: String
  field :text, type: String
  field :group, type: String
  field :frequency, type: String
  field :type, type: String
  field :target_count, type: Integer
  field :completions, type: Array, default: -> { [] }

  validates_uniqueness_of :key
  validates_presence_of :key

  index({ key: 1 }, { unique: true, name: "resolution_key_index" })

  def as_j(opts={})
    ResolutionSerializer.new(self, opts).as_json
  end

  def add_completion(completion)

  end
end
