class DetailSerializer < ActiveModel::Serializer
  def attributes
    hash = super
    hash = {}
    object.attributes.except("_id").merge! hash
  end
end
