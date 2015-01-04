window.utils ||= {}

reactUtils =
  renameObjectKey: (object, oldKey, newKey) ->
    newObject = {}
    for k, idx in Object.keys object
      newK = k
      newK = newKey if newK is oldKey
      newObject[newK] = object[k]
    return newObject

  insertObjectKeyAt: (object, insertAtIdx, keyName='', value='') ->
    newObject = {}
    for k, idx in Object.keys object
      if idx == insertAtIdx
        newObject[keyName] = value
      newObject[k] = object[k]
    return newObject

window.utils.react ||= reactUtils

