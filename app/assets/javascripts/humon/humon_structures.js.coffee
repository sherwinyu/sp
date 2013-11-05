HumonStructures = {}
Humon.HumonNodeGeneral = Ember.Object.extend
  nodeKey: ''
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null

###
compare: (hna, hnb) ->
nodeIdx: ((key, val)->
json: (->
nodeValChanged: (->
isHash: (->
isList: (->
isCollection: (->
    hasChildren: (->
isLiteral: (->
getNode: (keyOrIndex) ->
flatten: ->
lastFlattenedChild: ->
nextNode:  ->
prevNode: ->
convertToHash: ->
convertToList: ->
replaceWithJson: (json)->
replaceWithHumonNode: (newNode)->
replaceAt: (idx, amt, nodes...) ->
insertAt: (idx, nodes...) ->
deleteAt: (idx, amt)->
deleteChild: (node)->
pathToNode: (testNode)->
isDescendant: (testNode)->
###
Humon.HumonCollection = Ember.Object.extend
  isCollection: true
  flatten: ->
  hasChildren: ->
  getNode: ->
    throw "Interface method called"

Humon.HumonCollection.reopenClass
  each:
    type: "anything"


Humon.HumonList = Humon.HumonCollection.extend
  getNode: ->

Humon.HumonHash = Humon.HumonCollection.extend
  getNode: ->
    mat
Humon.HumonComplex =  Humon.HumonCollection.extend
  subAttributeActive: ->

Humon.HumonDateTimeRange = Humon.HumonComplex.extend
  start: (->).property()
  end: (->).property()

Humon.HumonDateTimeRange.reopenClass
  attributes:
    start:
      $type: Date
    end: 5
      # $type: HumonDateTime


Humon.HumonPrimitive = Ember.Object.extend
  isPrimitive: true
  isCollection: false



# Structure templates have to be pure json!
###
Humon.stubStucture "Time",
  $extends: "DateTime"
  $validations: {}
  # $compare: HARDCODED
  $display_as:
    format: "HH:MM:SS"
###

# It's a contract! Take a HumonStructureTemplate (it's own library), and turn it into
# its adapted type system. In this case, ember humon node objects
HumonStructures.createEmberType = (name) ->
  structureTemplate = HumonStructures.structures[name]
  # problem with dependency management oh my

  if structureTemplate.$extends?
    ancestor = HumonStructures.types[structureTemplate.$extends]
    # structureTemplate.
