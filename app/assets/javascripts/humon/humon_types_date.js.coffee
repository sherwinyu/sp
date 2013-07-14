HumonTypes.register "date",
  name: "date"
  templateName: "humon_node_date"
  _dateMatchers: [
    /^now$/,
    /^tomorrow$/,
    /^tmrw$/,
  ]
  _inferenceMatchers: [
    /^!date/,
    /^!now/,
  ]
  _precomitMatchers: [
  ]

  templateStrings: (node) ->
    # Em.assert node.isDate ## TODO(syu): what exactly does isDate mean?
    nodeVal = node.get('nodeVal')
    ret =
      month: nodeVal.getMonth()
      day: nodeVal.getDay()
      hour: nodeVal.getHours()
      abbreviated: nodeVal.toString()
    ret
  _matchesAsStringDate: (json) ->
    return false if json.constructor != String
    @_dateMatchers.some (dateMatcher) -> dateMatcher.test json

  precommitNodeVal: (string, node) ->
  inferType: (json)->
  defaultNodeVal: ->
    new Date()

  matchAgainstJson: (json) ->
    ret = false
    try
      # if it's a date object
      ret ||= (typeof json is "object" && json.constructor == Date)

      ret ||= @_matchesAsStringDate json

      # if it's a JS formatted date
      ret ||= (new Date(json)).toString() == json

      # if it's an ISO date
      ret ||= (new Date(json.substring 0, 19)).toISOString().substring( 0, 19) == json.substring(0, 19)
    catch error
      console.log error.toString()
      ret = false
    finally
      !!ret

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
