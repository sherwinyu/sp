class SleepSerializer < ActiveModel::Serializer
  attributes *%w[
    awake_at
    awake_energy
    up_at
    up_energy
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
