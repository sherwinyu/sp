class SummarySerializer < ActiveModel::Serializer
  attributes *%w[
    best
    worst
    funny
    insight
  ]
  def filter(keys)
    keys.reject!{|key| object[key].nil?}
  end
end
