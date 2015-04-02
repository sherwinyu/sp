class Summary
  include Mongoid::Document
  embedded_in :day

  field :best, type: String
  field :worst, type: String
  field :happiness, type: Integer
  field :funny, type: String
  field :insight, type: String
  field :uploaded_photos, type: Boolean

  field :coded, type: Boolean
  field :coded_in_am, type: Boolean
  field :mindfulness, type: Boolean
  field :in_bed_by_1130, type: Boolean
  field :chns_sentence, type: Boolean

  field :meditation, type: Hash
  field :anki, type: Hash
  field :work, type: Hash

  def as_json
    Util::Log.warn "Summary#as_json called (via default serializer)"
    ap Kernel.caller.first 10
    super
  end

  def resolutions
    # _old_resolutions
    _resolutions_via_completions
  end

  def _resolutions_via_completions
    day_start = self.day.start_at
    day_end = self.day.tomorrow.try(:start_at) || day_start + 1.day
    range = day_start..day_end
    mapped = _old_resolutions.map do |resolution_key, v|
      resolution = Resolution.find_by key: resolution_key
      completed = !!resolution.completions_in_range(range).first
      [resolution_key, completed]
    end
    Hash[mapped]
  end

  def _old_resolutions
    {
      coded: coded,
      coded_in_am: coded_in_am,
      mindfulness: mindfulness,
      in_bed_by_1130: in_bed_by_1130,
      chns_sentence: chns_sentence
    }
  end

end
