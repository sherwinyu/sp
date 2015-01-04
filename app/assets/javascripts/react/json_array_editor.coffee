#= require utils/react
#= require react/mixins/json_editor_mixin

window.sp ||= {}
rd = React.DOM

sp.JsonObjectEditor = React.createClass
  displayName: 'ObjectEditor'

  mixins: [sp.JsonEditorMixin]

  propTypes:
    value: React.PropTypes.object
    updateHandler: React.PropTypes.func

  _updateObjectKey: (updateAtIdx, oldKey, newKey) ->
    newObject = utils.react.renameObjectKey @props.value, oldKey, newKey
    @props.updateHandler newObject

  _updateObjectValue: (updateAtIdx, key, newVal) ->
    newObject = $.extend {}, @props.value
    newObject[key] = newVal
    @props.updateHandler newObject

  insertSiblingAtIdx: (idx) ->
    newObject = utils.react.insertObjectKeyAt @props.value, idx
    console.log newObject
    @props.updateHandler newObject

  objectKeyboardShortcuts: (idx, e)->
    @_upDownShortcuts(idx, e)
    if e.key is 'Enter'
      @insertSiblingAtIdx(idx)




  render: ->
    rd.ul null,
      for key, idx in Object.keys @props.value
        val = @props.value[key]
        rd.li
          onKeyDown: @objectKeyboardShortcuts.bind null, idx
        ,
          sp.JsonEditor
            role: 'key-field'
            key: "key#{idx}"
            value: key
            updateHandler: @_updateObjectKey.bind null, idx, key
          sp.JsonEditor
            role: 'value-field'
            key: "val#{idx}"
            value: val
            updateHandler: @_updateObjectValue.bind null, idx, key
            # keyboardShortcuts: @_objectValueShortcuts

sp.JsonArrayEditor = React.createClass
  displayName: 'ObjectEditor'

  mixins: [sp.JsonEditorMixin]

  propTypes:
    # role: React.PropTypes.string
    value: React.PropTypes.array
    updateHandler: React.PropTypes.func
    keyboardShortcuts: React.PropTypes.func

  _updateArrayElement: (idx, newVal) ->
    newArray = @props.value.slice 0
    newArray[idx] = newVal
    @props.updateHandler newArray

  insertSiblingAtIdx: (idx) ->
    newArray = @props.value.slice 0
    newArray.splice idx, 0, ''
    @props.updateHandler newArray

  arrayKeyboardShortcuts: (idx, e) ->
    @_upDownShortcuts(idx, e)
    if e.key is 'Enter'
      @insertSiblingAtIdx(idx)

  render: ->
    rd.ol null,
      for val, idx in @props.value
        rd.li
          onKeyDown: @arrayKeyboardShortcuts.bind null, idx
        ,
          sp.JsonEditor
            role: 'value-field'
            key: idx
            value: val
            updateHandler: @_updateArrayElement.bind null, idx

