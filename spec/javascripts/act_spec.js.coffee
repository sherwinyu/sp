store = DS.Store.create( revision: 10)
describe "Sysys.Act", ->
  beforeEach ->
    @params = 
      description: "Woke up and lumpd around"
      start_time: moment("2012 08 12").toDate()
      end_time: moment("2012 08 12").add('hours', 4).toDate()

  describe "attributes", ->

    beforeEach ->
      @act = store.createRecord(Sysys.Act, @params)


    it "should have the expected attributes", ->
      expect(@act.get('description')).toBe(@params.description)
      expect(@act.get('start_time')).toBe(@params.start_time)
      expect(@act.get('end_time')).toBe(@params.end_time)


              




