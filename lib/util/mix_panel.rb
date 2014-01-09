module Util
  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new(Figaro.env.MIXPANEL_TOKEN)
  end
  class MixPanel

  end
  module_function :mixpanel
end
