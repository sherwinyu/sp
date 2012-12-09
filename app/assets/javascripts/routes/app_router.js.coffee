Sysys.Router = Ember.Router.extend
  location: 'hash',

  root: Ember.Route.extend

    showAction: Ember.Route.transitionTo('actions.action')

    actions: Ember.Route.extend
      route: '/actions'
        
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('actions', Sysys.store.findAll(Sysys.Action))

      index: Ember.Route.extend
        route: '/'

        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('actions')


      action: Ember.Route.extend
        enter: ->
            
        route: '/:action_id'

        connectOutlets: (router, action) ->
          # TODO(syu): figure out how to handle case of outlet doesn't exist
          unless action.get('isLoaded')
            router.transitionTo('root.actions') 
          else
            router.get('applicationController').connectOutlet('action', action)





          ###
    actions: Ember.Route.extend
      route: 'actions'
      
      connectOutlets: (router, context) ->
        actionController = router.get('actionController')
      ###

  enableLogging: true
