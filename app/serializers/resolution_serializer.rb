class ResolutionSerializer < ActiveModel::Serializer
  attributes :id, :text, :group, :frequency, :type, :current_count, :target_count, :completions

  def id
    object.id.to_s
  end

  def current_count
    object.completions.try :length
  end

  def completions
    object.completions.map do |completion|
      if completion['ts'].present?
        completion[:date] = Util::DateTime.dt_to_expd_date completion['ts'].to_datetime
      end
      completion
    end
  end

end
