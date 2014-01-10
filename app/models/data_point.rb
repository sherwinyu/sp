class DataPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitted_at, type: Time
  field :started_at, type: Time
  field :ended_at, type: Time
  field :details
  scope :recent, desc(:started_at).limit(10)

  after_save :flush_cache

  def flush_cache
    Rails.cache.delete([self.class.name, "recent"])
  end

  def self.cached_recent
    Rails.cache.fetch [name, "recent"] do
      recent.to_a
    end
  end

  def self.find args
    if args.to_i.to_s == args
      args = args.to_i
      return self.order_by(:created_at.asc)[args]
    else
      super(args)
    end
  end
end
