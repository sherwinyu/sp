class SummarySerializer < ActiveModel::Serializer
  attributes *%w[
    best
    worst
    happiness
    funny
    insight
    meditation
    work
    coded
    uploaded_photos
    anki
  ]
  def attributes
    hash = super
    puts "\n\n"
    puts "Object:"
    ap object
    puts "Hash:"
    ap hash
    puts "\n\n"
    hash
  end
  def filter(keys)
    keys.reject{|key| object[key].nil?}
  end
end
