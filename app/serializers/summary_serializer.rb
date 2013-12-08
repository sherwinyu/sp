class SummarySerializer < ActiveModel::Serializer
  attributes *%w[
    best
    worst
    funny
    insight
  ]
end
