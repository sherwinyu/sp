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




Low priorty:
  storing templates on Rails side
  SpTemplate model
