class Summary
  include Mongoid::Document
  embedded_in :day


  field :best, type: String
  field :worst, type: String
  field :happiness, type: String
  field :funny, type: String
  field :insight, type: String

  def as_json
    Util::Log.warn "Summary#as_json called (via default serializer)"
    ap Kernel.caller.first 10
    super
  end

end
