class SummarySerializer < ActiveModel::Serializer
  attributes *%w[
    best
    worst
    happiness
    funny
    insight
    meditation
    work
    uploaded_photos
    anki
    coded
    coded_in_am
    mindfulness
    in_bed_by_1130
    chns_sentence
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
