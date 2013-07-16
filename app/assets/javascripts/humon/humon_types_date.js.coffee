
verbose = (date) ->
  mmt = moment(date)
  mmt.format('LLLL')

asString = (date) ->
  "#{humanized(date)} (#{relative(date)})"
  humanized(date)

humanized = (date) ->
  mmt = moment(date)
  if mmt.isSame(new Date(), 'year')
    mmt.format("ddd, MMM D")
  else
    mmt.format("ddd, MMM D, YYYY")

relative = (date) ->
  mmt = moment(date)
  mmt.fromNow()

# param date Date
# returns: a Date
tomorrow = (date) ->
  mmt = moment(date)
  if mmt.hour() > 3
    mmt.add days: 1
  mmt.startOf('day')
  mmt.toDate()

momentFormat = (string, format) ->
  mmt = moment(string, format)

momentFormatAndValidate = (string, format) ->
  date = momentFormat(string, format).toDate()
  valid = Date.parse(string).equals date
  {valid: valid, date: date}


HumonTypes.register "date",
  name: "date"
  templateName: "humon_node_date"
  _regexTransforms:
    "^now$": (string) -> new Date()
    "^tomorrow$": (string) ->
      tomorrow(new Date())
    "^tmrw$": (string)->
      tomorrow(new Date())

  _momentFormatTransforms:
    'ddd MMM D': (string, format) ->
      momentFormatAndValidate string, format

    'ddd MMM D YYYY': (string, format)->
      momentFormatAndValidate string, format

  _precomitMatchers: [
  ]

  _inferAsRegex: (string) ->
    return false if string.constructor != String
    for matcher, transform of @_regexTransforms
      if (new RegExp(matcher)).test string
        return @_regexTransforms[matcher](string)

  _inferAsMomentFormat: (string) ->
    return false if string.constructor != String
    for format, transform of @_momentFormatTransforms
      {valid, date} = @_momentFormatTransforms[format](string, format)
      if valid
        return date
    false

  _inferViaDateParse: (string) ->
    return false if string.constructor != String
    Date.parse(string) || false

  _inferFromJson: (json) ->
    ret = false
    try
      # if it's a date object
      ret ||= (typeof json is "object" && json.constructor == Date)

      ret ||= @_inferAsRegex json
      ret ||= @_inferAsMomentFormat json
      ret ||= @_inferViaDateParse json

      # if it's a JS formatted date
      ret ||= (new Date(json)).toString() == json

      # if it's an ISO date
      # ret ||= (new Date(json.substring 0, 19))
      # .toISOString().substring( 0, 19) == json.substring(0, 19)
    catch error
      console.log error.toString()
      ret = false
    finally
      ret
  # matchesAgainstJson -- checks a json value to see if it could be this type
  #   param json json: the candidate json
  #   returns: a boolean, true if it could be this value, false if not
  #
  # Context: called by HumonTypes.resolveType while iterating over all registered types
  #
  # Note: matchesAgainstJson should return true if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # registration order
  matchesAgainstJson: (json) ->
    !!@_inferFromJson(json)

  templateStrings: (node) ->
    # Em.assert node.isDate ## TODO(syu): what exactly does isDate mean?
    nodeVal = node.get('nodeVal')
    ret =
      month: nodeVal.getMonth()
      day: nodeVal.getDay()
      hour: nodeVal.getHours()
      abbreviated: humanized(nodeVal)
      asString: asString(nodeVal)
      relative: relative(nodeVal)
      verbose: verbose(nodeVal)
    ret

  precommitNodeVal: (string, node) ->
  inferType: (json)->
  defaultNodeVal: ->
    new Date()

  hnv2j: (node) ->
    node.toString() #TODO(syu): can we just keep this a node? Will the .ajax call serialize it properly?

  j2hnv: (json) ->
    val = @_inferFromJson(json)
