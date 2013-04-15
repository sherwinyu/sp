Sysys.Router.map ->
  @resource "acts", ->
    @route "new"
    @route "activeAct"

Sysys.ActsRoute = Ember.Route.extend
  model: ->
    Sysys.Act.find()
  events:
    wala: ->
      console.log @controllerFor('acts')
      console.log 'wala'

Sysys.ActsNewRoute = Ember.Route.extend
  model: ->

Sysys.ActsActiveAct = Ember.Route.extend
  model: ->
    @controllerFor('acts').objectAt(0)

Sysys.ActsIndexRoute = Ember.Route.extend
  model: ->
    [ Sysys.Act.createRecord() ]
    
  

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
