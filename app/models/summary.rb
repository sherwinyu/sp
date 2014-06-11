class Summary
  include Mongoid::Document
  embedded_in :day


  field :best, type: String
  field :worst, type: String
  field :happiness, type: Integer
  field :funny, type: String
  field :insight, type: String
  field :meditation, type: Hash

  def as_json
    Util::Log.warn "Summary#as_json called (via default serializer)"
    ap Kernel.caller.first 10
    super
  end

end
