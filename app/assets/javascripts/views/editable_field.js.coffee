Sysys.EditableField = Ember.View.extend
  templateName: 'editable_field'
  tagName: 'span'
  rawValue: ''
  value: null

  doubleClick: ->
    @enterEdit()
    false

    # focusOut: ->
    # @exitEdit()
    # false

  keyUp: (evt) ->
    if evt.keyCode == 13
      @exitEdit()
    false

  enterEdit: ->
    @set('isEditing', true)
    @onEnterEdit()

  # to be overridden
  onEnterEdit: Em.K

  exitEdit: ->
    if (@validate())
      @set('isEditing', false)

  # display - a property for altering how the value is to be displayed
  display: (->
    @toDisplay()
  ).property('value')

  # a funciton to be called. can be overridden
  # returns: String to be disiplayed
  toDisplay: ->
    @get('value')

  # validate - a function called before commiting rawInput data to actual data.
  # Any parsing should be done here. Return false if input value is invalid, return true otherwise
  validate: ->
    @set('value', @get('rawValue'))
    true


Sysys.TextField = Ember.TextField.extend
  didInsertElement: ->
    if @get('value') != @get('initialValue')
      @$().val(@get('initialValue'))
    @$().focus()


Sysys.DetailsKeyView = Sysys.EditableField.extend
  # stores the value of the key
  
  details: null
  # @override
  value: (->
    details = @get 'details'
    key = details.keyForIndex @get 'index'
  ).property('index', 'details._keys.@each')

  validate: ->
    details = @get 'details'
    keyName = @get 'value'
    ret = details.renameKey keyName, @get('rawValue')

Sysys.DatePickerField = Sysys.EditableField.extend
  onEnterEdit: ->
    Ember.run => @rerender()
    @$('input').datepicker()

  toDisplay: ->
    f = "MMM D @ h:mm a"
    date = @get('value') # is a date
    moment(date).format(f)

  validate: ->
    mom = moment(@get('rawValue'))
    date = $('input').datepicker('getDate')
    if date
      @set('value', date)
      true
    else
      false
    ###
    if mom.isValid()
      @set('value', mom.toDate())
      true
    else
      false
      ###

Sysys.DurationField = Sysys.EditableField.extend
  value: null
  toDisplay: ->
    dur = @get('value')
    moment.duration(dur*1000).humanize()
  initialValue: "ladidadida"
  
  validate: ->
    raw = @get('rawValue') # entered in minutes, need to convert to seconds
    dur = parseInt(raw)
    if dur
      dur = dur * 60
      @set('value', dur)
      true
    else
      false

Sysys.DateTimePickerField = Ember.TextField.extend
  val: null
  valueChanged: (->
    @$().datetimepicker 'setDate', @get('val')
    ).observes('val')

  setValue: ->
    val = @$().datetimepicker 'getDate'
    @set 'val', val

  didInsertElement: ->
    @$().datetimepicker
      hourGrid: 3
      minuteGrid: 15
      stepMinute: 5
      defaultValue: @get('val')
      defaultDate: @get('val')
      onSelect: => @setValue()
      # debugger
    @$().datetimepicker "setDate",  @get('val')


