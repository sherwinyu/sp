describe "Notification system", ->
  beforeEach ->
    @params = 
      title: "generic title"
      text: "notificaiton text"
      type: "INFO"
      
    @notification = Sysys.Notification.create @params

  describe "Notification model", ->

    it "should have default values", ->
      @newNotification = Sysys.Notification.create()
      expect(@newNotification.get('type')).toBe(Sysys.Notification.INFO)

    it "should have the proper attributes"

  describe "NotificationsController", ->
    
    beforeEach ->
      @notificationsController = Sysys.NotificationsController.create(
        content: [@notification]
      )
    afterEach -> 
      @notificationsController = null

    describe "add", ->
      it "should push a notification object into content", ->
        spy = sinon.spy(Sysys.Notification, "create")
        expect(@notificationsController.get('length')).toBe(1)
        @notificationsController.add('sample title', 'sample text', 'INFO')
        expect(@notificationsController.get('length')).toBe(2)
        expect(@notificationsController.objectAt(1)).toEqual(spy.returnValues[0])
        Sysys.Notification.create.restore()

    describe "remove", ->
      it "should reomve a notification from content", ->
        expect(@notificationsController.get('length')).toBe(1)
        @notificationsController.remove

describe "notification view", ->
  beforeEach ->
    @params = 
      title: "generic title"
      text: "notificaiton text"
      type: "INFO"
      
    @remove = sinon.spy()
    controller = { remove: @remove }

    @notification = Sysys.Notification.create @params
    @notificationView = Sysys.NotificationView.create( content: @notification, controller: controller)
    Ember.run =>
      @notificationView.append()

  afterEach ->
    Ember.run =>
      @notificationView.remove()
    @notificationView = null
    @notification = null

  it "should be inserted into the dom", ->
    expect(@notificationView.state).toBe('inDOM')

  it "should have a close button", ->
    expect(@notificationView.$('a.close')).toExist()

  it "should trigger remove when close button is clicked", ->
    @notificationView.$('a.close').trigger('click')
    expect(@remove).toHaveBeenCalledOnce()
    expect(@remove).toHaveBeenCalledWith(@notificationView.content)

  describe "bindings", ->
    it "should style based on notification type", ->
      $view = @notificationView.$()
      @notificationView.content.set('type', Sysys.Notification.INFO)
      expect($view).toHaveClass('alert-success')
      expect($view).not.toHaveClass('alert-error')
      @notificationView.content.set('type', Sysys.Notification.ERROR)
      expect($view).toHaveClass('alert-error')
      expect($view).not.toHaveClass('alert-success')
      @notificationView.content.set('type', Sysys.Notification.WARNING)
      expect($view).toHaveClass('alert')
      expect($view).not.toHaveClass('alert-error')
      expect($view).not.toHaveClass('alert-success')
