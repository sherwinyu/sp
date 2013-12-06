HumonStructures = {}

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
Controller
  goToPrev
  goToNext
  indent
  outdent
  delete
  insert
  commitAndContinue
  goToField
  bubbleUp
  bubbleDown

PRINCIPLES:
  * controller actions interface with humon node
  * humon node interfaces with Humon*types, which provides a standardized api
  * a node is something whose value is committed at the same time. atomic values

HumonNode
  nodeType
  nodeKey
  nodeVal -- the wrapper
  nodeParent

  *isCollection -- proxied attr
  *isList -- proxied attr
  *size
  *isHash -- proxied attr
  *hasChildren -- proxied attr

  !nextNode
  !prevNode
  !delete
  !replaceWithHumon
  validate

Humon.HumonValue mixin
  nextNode()
  prevNode()
  delete()
  class {
    hnv2j
    j2hnv
  }
  validateSelf()
  validateHook()
  typecheck()

Humon.HumonCollection = new mixin# Ember.Array.extend
  isCollection
  flatten
  hasChildren
  insertChild(position)
  deleteChild(key or position)
  childrenModifiable?
  keys
  children

Humon.List = Ember.Array.extend Humon.HumonCollection
  insertChild(position)

Humon.Hash = Humon.List.extend
  @override
  getNode
  getElementAt
  getUnknownProperty

Humon.Complex = new interface?  -- think, could we have a list with attributes? of course
Humon.Complex = Humon.Hash.extend
  validate
  class {
    attributes
  }

Humon.Couple = Humon.List.extend
  startBinding: "0"
  endBinding: "1"
  validateSelf: ->
    size == 2

Humon.DateTimeRange = Humon.Complex.extend
  start: null
  end: null

  validateSelf: ->
    @start < @end

  class {
    attributes:
      start: Humon.DateTime
      end: Humon.DateTime
  }

###



# Humon.AbstractPrimitive = Ember.Object.extend Humon.HumonValue


Humon.Number = Ember.Object.extend Humon.HumonValue,
  _value: null
Humon.Number.reopenClass
  j2hnv: (json) ->
    Humon.Number.create(_value: json)

Humon.Boolean = Ember.Object.extend Humon.HumonValue,
  _value: null
Humon.Boolean.reopenClass
  j2hnv: (json) ->
    Humon.Boolean.create(_value: json)


Humon.Hash = Humon.List.extend
  unknownProperty: (key) ->
    if isNaN(key)
      @get('_value')






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
