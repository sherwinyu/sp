class Summary
  include Mongoid::Document
  embedded_in :day


  field :best, type: String
  field :worst, type: String
  field :funny, type: String
  field :insight, type: String

  def as_json
    SummarySerializer.new(self).as_json
  end

end
