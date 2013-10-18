Sysys.RescueTimeDpView = Ember.View.extend
  templateName: 'rescue_time_dp'
  classNames: 'rtdp'

  fillStyle: (->
    x = @get('controller.productivityIndex') * 50
    r = Math.round((100 - x) / 200 * 255)
    g = Math.round(255 - r)
    b = Math.round(128 - Math.abs(x))
    colorStyle = "rgb(#{r}, #{g}, #{b})"
    "color: #{colorStyle}"
  ).property 'controller.productivityIndex'
