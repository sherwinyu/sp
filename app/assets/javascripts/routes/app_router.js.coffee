Sysys.Router.map ->
  @resource "acts", ->
    @route "new"

Sysys.ActsRoute = Ember.Route.extend
  model: ->
    Sysys.Act.find()

Sysys.ActsNewRoute = Ember.Route.extend
  model: ->

Sysys.ActsIndexRoute = Ember.Route.extend
  model: ->
    
  

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
