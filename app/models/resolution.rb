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

  def validate_key
    fail unless Resolution.where(key: self.key).count == 0
    fail unless Resolution.where(key: self.key).first == self
  end
  # validates_uniqueness_of :key
  # validates_presence_of :key

  index({ key: 1 }, { unique: true, name: "resolution_key_index" })

  def as_j(opts={})
    ResolutionSerializer.new(self, opts).as_json
  end

  def add_completion(completion_params)
    if validate_completion completion_params
      completion = compute_completion_hash_from_params completion_params
      self.completions << completion
      completion
    else
      nil
    end
  end

  ##
  # Returns true if the completions specified by completion_params are valid, false otherwise
  # If validation fails, they are added to the erros hash.
  def validate_completion(completion_params)
    compute_completion_hash_from_params(completion_params)
    true
  rescue => e
    errors.add :completions, "Invalid completion '#{completion_params}': #{e.message}"
    false
  end

  def completions_in_range(range)
    self.completions.select {|completion| range.cover? completion['ts']}
  end


  private

  def compute_completion_hash_from_params(completion_params)
    ts = Time.zone.parse completion_params[:ts]
    date = Date.strptime completion_params[:day]
    day = Day.find_by date: date
    completion = {
      ts: ts,
      comment: completion_params[:comment]
    }
    completion[:day_id] = day.id if day
    completion
  end

end
