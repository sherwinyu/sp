class DataPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitted_at, type: Time
  field :details

  def self.find args
    if args.to_i.to_s == args
      args = args.to_i
      return self.all[args]
    else
      super(args)
    end
  end

end
