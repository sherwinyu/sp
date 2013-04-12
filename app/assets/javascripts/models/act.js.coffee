Sysys.Act = DS.Model.extend
  description: DS.attr "string"
  start_time: DS.attr "date"
  end_time: DS.attr "date"
  detail: DS.attr "humon"

  # duration is stored as seconds and is a computed property
  duration: ((key, val)->
    if val?
      start = @get 'start_time' 
      end = moment(start)?.clone().add(val * 1000).toDate()
      @set 'end_time', end
    else
      ret = (@get('end_time') - @get('start_time')) / 1000
      if ret? then ret else  null
  ).property('start_time', 'end_time').volatile()



  ###
  start_time_pretty: (->
    @pretty_date('start_time')
    ).property('start_time')

  pretty_date: (date_key) ->
    date = @get(date_key)?.getDay()
    hours = @get(date_key)?.getHours()
    minutes = @get(date_key)?.getMinutes()
    "#{date} #{hours}:#{minutes}"
    ###

  pretty_duration: (->
    dur = @get('duration')
    moment.duration(dur*1000).humanize()
  ).property('duration')

  isActive: -> 
    current = new Date
    t1 = @get('startTime').getTime()  
    t2 = @get('endTime').getTime()

    return current < new Date(t2)
    
  timeRemainingMs: ->
    if @isActive()
      @get('endTime').getTime() - new Date().getTime()
    else
      0

  timeRemaining: (->
    d = new Date(@timeRemainingMs())
    "#{d.getUTCHours()}:#{d.getUTCMinutes()}:#{d.getUTCSeconds()}.#{d.getUTCMilliseconds()}"
  ).property('startTime', 'duration2').cacheable()

  defaultValues: ->
    @set 'start_time', new Date()  unless @get('start_time')?
    @set 'duration', 30*60 unless @get('end_time')?
    @set 'description', "new action" unless @get('description')?


  becameError: ->
    console.log('an error occured!')
    # Sysys.router.get('notificationsController').add('Oops', 'There was an error!', 'ERROR')
  didUpdate: ->
    console.log("updated!");
    # Sysys.router.get('notificationsController').addInfo('', 'Successfully updated.')
  didLoad: ->
    console.log 'loaded!'
  didCreate: ->
    console.log 'created!'
    # Sysys.router.get('notificationsController').addInfo('', 'Successfully created.')
  didCommit: ->
    console.log 'commited!'
  becameInvalid: (act) ->
    for k, v of act.errors
      console.log 'error!'
      # Sysys.router.get('notificationsController').addError(k, v)

Sysys.Act.reopenClass
