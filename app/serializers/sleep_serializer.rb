class SleepSerializer < ActiveModel::Serializer
  attributes *%w[
    awake_at
    awake_energy
    up_at
    up_energy
  ]
  def filter(keys)
    keys.reject!{|key| object[key].nil?}
  end
end
