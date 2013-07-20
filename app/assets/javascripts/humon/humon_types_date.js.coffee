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
  iconClass: "icon-calendar"
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

  # _inferFromJson -- attempts to convert a json value to this type
  #   param json json: the candidate json object
  #   return: if successful, a value of this type
  #           if unsuccessful, a falsy value
  #
  # Note: _inferFromJson returns the value if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # registration order
  #
  # TODO(syu): update and generalize to work for all humon types and include it in
  # the standard suite. AKA make it work for booleans: return a hash {matchesType, value}
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
      console.error error.toString()
      ret = false
    finally
      ret
  # matchesAgainstJson -- checks a json value to see if it could be this type
  #   param json json: the candidate json
  #   returns: a boolean, true if it could be this value, false if not
  # This just takes @_inferFromJson and coerces the return value to a boolean.
  # Context: called by HumonTypes.resolveType while iterating over all registered types
  matchesAgainstJson: (json) ->
    !!@_inferFromJson(json)

  templateStrings:
    month: (node) -> node.get('nodeVal').getMonth()
    day: (node) -> node.get('nodeVal').getDay()
    hour: (node) -> node.get('nodeVal').getHours()
    abbreviated: (node) -> humanized(node.get('nodeVal'))
    asString: (node) -> asString(node.get('nodeVal'))
    relative: (node) -> relative(node.get('nodeVal'))
    verbose: (node) -> verbose(node.get('nodeVal'))

  precommitNodeVal: (string, node) ->
  inferType: (json)->
  defaultNodeVal: ->
    new Date()

  # hnv2j -- humon node val to json. Converts from nodeVal of this type to json
  # Context: called by HumonUtils.humonNode2json, which is in turn called by the Store
  # in preparation for serializing this to
  hnv2j: (nodeVal) ->
    nodeVal.toString() #TODO(syu): can we just keep this a node? Will the .ajax call serialize it properly?

  # j2hnv -- json to humon nodeVal. Converts from json value to a nodeVal of this type
  # Context: called by HumonUtils.j2hn when setting the nodeVal for literal nodes
  # Note: this is different from HumonUtils.j2hn, which outputs **humon node objects**.
  # j2hnv outputs humon node `nodeVal`s
  j2hnv: (json) ->
    val = @_inferFromJson(json)
