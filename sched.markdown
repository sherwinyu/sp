### Schedule ###

Stub templates on client side

HumonTypes.typeDefStub, "SurveyResponse0to10",
  $type: "integer"
  $minimum: 0
  $maximum: 10

HumonTypes.typeDefStub, "Sleep",
  $type: Complex
  computer off at:
    $type: "DateTime"
    $display: "time only"
    $bias: 4am
  lights out at:
    $type: "DateTime"
    $display: "time only"
    $bias: 4am
  energy level at lights out:
    $type: SurveyResponse0to10
  asleep at
    $type: "DateTime"
    $display: "time only"
    $bias: 4am
  awake at:
    $type: "DateTime"
    $display: "time only"
    $bias: 4am
  energy level at awake
    $type: SurveyResponse0to10


Primitives
  Number
  Date
  DateTime
  Bool
  Null
  String



HumonTypes.register "SurveyResponse0to10"
  nodeTypeDef:


Functionality:
  PARSING
    -- given a JSON object, and told that the object adheres to this template, generate a HumonNode that contains all this
    information
  HANDLING TEMPLATE INFORMATION
    -- commit and continue
    -- up, down, bubble up, bubble down, delete,


  VALIDATING --
    when a subtype's value is committed, need to validate against the type's specifications for that subtype


Low priorty:
  storing templates on Rails side
  SpTemplate model
