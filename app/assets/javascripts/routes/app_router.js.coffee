Sysys.Router.map ->
  @resource "acts", ->
    @route "new"
    @route "activeAct", path: 'activeAct/:act_id'

Sysys.ActsRoute = Ember.Route.extend
  enter: ->
    console.log 'enter acts route'
  model: ->
    # Sysys.Act.find()
  events:
    wala: ->
      console.log @controllerFor('acts')
      console.log 'wala'

Sysys.ActsNewRoute = Ember.Route.extend
  model: ->

Sysys.ActsActiveActRoute = Ember.Route.extend
  enter: ->
    console.log 'enter acts active route'
  model: (params)->
    model = @controllerFor('acts').objectAt(0)
    console.log model, params
    model
    ###
  setupController: (ctrl, model) ->
    chain = Sysys.j2hn({})
    description = model.get 'description'
    description.set 'nodeKey', 'description'
    start_time = model.get 'start_time'
    start_time.set 'nodeKey', 'start time'
    end_time = model.get 'end_time'
    end_time.set 'nodeKey', 'end time'
    detail = model.get 'detail'
    detail.set 'nodeKey', 'details'
    chain.insertAt 0, description, start_time, end_time, detail
    ctrl.chain = chain
    ###

Sysys.ActsIndexRoute = Ember.Route.extend
  model: ->

Sysys.ApplicationRoute = Ember.Route.extend
  actions:
    jsonChanged: (json)->
      5

Sysys.IndexRoute = Ember.Route.extend
  actions:
    jsonChanged: ->
      5

Sysys.ActsIndex = Ember.Route.extend
  actions:
    jsonChanged: ->
      5




    # = Ember.Router.extend
    # location: 'hash'

###

  root: Ember.Route.extend

    testing: Ember.Route.extend
      route: '/testing'

      connectOutlets: (router)->
        router.get('applicationController').connectOutlet('testing')

    index: Ember.Route.extend
      route: '/'
      redirectsTo: 'root.acts.index'

    showAct: Ember.Route.transitionTo('acts.act')

    acts: Ember.Route.extend
      route: '/acts'

      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('acts')

      index: Ember.Route.extend
        route: '/'

        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('acts')
          router.get('actsController').connectOutlet( 'notifications', 'notifications', [Sysys.Notification.create()])


      # root.acts.act
      act: Ember.Route.extend
        enter: ->

        route: '/:act_id'

        connectOutlets: (router, act) ->
          # TODO(syu): figure out how to handle case of outlet doesn't exist
          if act.get('isNew')
            router.transitionTo('root.acts')
          else
            router.get('applicationController').connectOutlet('act', act)



  enableLogging: true
###
