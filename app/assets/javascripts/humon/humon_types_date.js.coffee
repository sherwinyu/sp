
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
  ret =
    valid: mmt.isValid()
    date: mmt.toDate()

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
    'ddd, MMM D': (string, format) ->
      momentFormat string, format

    'ddd, MMM D, YYYY': (string, format)->
      momentFormat string, format

    'ddd, MMM DD, YYYY': (string,format)->
      momentFormat string, format

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
    ret = false
    try
      # if it's a date object
      ret ||= (typeof json is "object" && json.constructor == Date)

      ret ||= @_matchesAsStringDate json

      # if it's a JS formatted date
      ret ||= (new Date(json)).toString() == json

      # if it's an ISO date
      ret ||= (new Date(json.substring 0, 19))
               .toISOString().substring( 0, 19) == json.substring(0, 19)
    catch error
      console.log error.toString()
      ret = false
    finally
      !!ret
  inferFromJson: (json) ->

    return {match: match, val: ret}

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
    # TODO(syu): make it work for dateMatchers
    val =
      if json == "now"
        new Date()
      else if json instanceof Date
        json
      else
        new Date(json)
