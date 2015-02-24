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
    _old_resolutions
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
