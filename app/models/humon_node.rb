class HumonNode < Hashie::Mash

  def mongoize
    self.to_hash
  end

  def self.mongoize field_object
    case field_object
    when HumonNode then field_object.mongoize
    else field_object
    end
  end

  def self.demongoize mongodb_payload
    case mongodb_payload
    when Hash then HumonNode.new mongodb_payload
    else mongodb_payload
    end
  end

end
