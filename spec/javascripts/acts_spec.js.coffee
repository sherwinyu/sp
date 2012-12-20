describe "Acts", ->
  beforeEach ->
    @transaction = (new Sysys.Store).transaction()
    # act1 = transaction.createRecord(Sysys.Act, description: "act1")
    # act2 = transaction.createRecord(Sysys.Act, description: "act2")
    # act3 = transaction.createRecord(Sysys.Act, description: "act3")
    act1 = { description: 'act1' }
    act2 = { description: 'act2' }
    act3 = { description: 'act3' }
    @act = Sysys.store.createRecord(Sysys.Act, description: "actdescription")
    @acts = [act1, act2, act3]
    @actsController = Sysys.ActsController.create content: @acts
    @actsView = Sysys.ActsView.create controller: @actsController

  afterEach ->
    Sysys.store.deleteRecord(@act)
    @act = null



  describe "Controller", ->
    it "should call Sysys.store. an ajax on commit", ->
      commit = sinon.stub(Sysys.store, "commit", Em.K)
      @actsController.commit()
      expect(commit).toHaveBeenCalledOnce
      Sysys.store.commit.restore()

  describe "model", ->
    it "it should have 'description' property", ->
      expect(@act.get('description')).toEqual("actdescription")
      @act.set('description', 'derp')
      expect(@act.get('description')).toEqual('derp')
      
  describe "integrated validations", ->

    beforeEach ->
      @actView = Sysys.ActView.create( context: @act, controller: Sysys.router.get('actsController'))
      Ember.run =>
        @actView.append()

    afterEach ->
      Ember.run =>
        @actView.remove()
      @actView = null

    it "should create a new notification on submit", ->
      @act.set("description", "changed")
      xhr = sinon.useFakeXMLHttpRequest()
      @requests = []
      actDidCreate = sinon.spy(@act, "didCreate")

      xhr.onCreate = (ajax) => 
        @requests.push ajax
      Ember.run =>
        @actView.submit()
      response = JSON.parse(@requests[0].requestBody)
      response.act.id = '12345'
      debugger
      @requests[0].respond(200, {act: ''}, JSON.stringify(response) ) #{ "Content-Type": "application/json" },  "OK")
      expect(actDidCreate).toHaveBeenCalledOnce()
      xhr.restore()
      actDidCreate.restore()

    it "should create an error notification if act is invalid", ->
      actBecameInvalid = sinon.spy(@act, "becameInvalid")

      xhr = sinon.useFakeXMLHttpRequest()
      @requests = []
      xhr.onCreate = (ajax) => 
        @requests.push ajax


      @act.set('description', '')
      Ember.run =>
        @actView.submit()

      # response = JSON.parse(@requests[0].requestBody)
      # response.act.errors = [ description : "can't be blank"]
      response = errors: {description: ["can't be blank"]}
      @requests[0].respond(422, {act: ''}, JSON.stringify(response) ) #{ "Content-Type": "application/json" },  "OK")

      expect(actBecameInvalid).toHaveBeenCalledOnce()
      debugger
      expect(actBecameInvalid.args[0][0].errors).toBeDefined()

