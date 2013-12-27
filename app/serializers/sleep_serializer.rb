class SleepSerializer < ActiveModel::Serializer
  attributes *%w[
    awake_at
    up_at
    melatonin_at
    computer_off_at
    lights_out_at

    awake_energy
    up_energy
    computer_off_energy
    lights_out_energy
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
