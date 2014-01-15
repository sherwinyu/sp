# ActiveModel::Serializer::Association::
module ActiveModel
  class DefaultSerializer
    def as_json(options={})
      Util::Log.warn "default serializer called", object: @object.class
      return @object.as_json
    end
  end
end
