class DetailSerializer < ActiveModel::Serializer
  attributes :id
  def attributes
    hash = super
    object.attributes.except("_id").merge! hash
  end
end
