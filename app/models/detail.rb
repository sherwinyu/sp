class Detail
  include Mongoid::Document
  embedded_in :act
end
