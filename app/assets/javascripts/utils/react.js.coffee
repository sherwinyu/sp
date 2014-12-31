window.utils ||= {}

reactUtils =
  renameObjectKey: (object, oldKey, newKey) ->
    newObject = {}
    for k, idx in Object.keys object
      newK = k
      newK = newKey if newK is oldKey
      newObject[newK] = object[k]
    return newObject

window.utils.react ||= reactUtils

