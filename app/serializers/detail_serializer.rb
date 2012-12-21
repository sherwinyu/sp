class DetailSerializer < ActiveModel::Serializer
  attributes :id
  def attributes
    hash = super
    binding.pry
    object.attributes.except("_id").merge! hash
  end
end
