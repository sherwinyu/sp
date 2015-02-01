class Resolution
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :group, type: String
  field :frequency, type: String
  field :type, type: String
  field :count, type: Integer
  field :completions, type: Array, default: -> { [] }

  def as_j(opts={})
    ResolutionSerializer.new(self, opts).as_json
  end
end
