class SummarySerializer < ActiveModel::Serializer
  attributes *%w[
    best
    worst
    funny
    insight
  ]


  def attributes
    hash =  super
    puts "\n\n"
    ap object
    ap hash
    puts "\n\n"
    hash
  end
  def filter(keys)
    keys.reject!{|key| object[key].nil?}
  end
end
