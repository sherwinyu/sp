Sysys.Router = Ember.Router.extend
  location: 'hash',

  root: Ember.Route.extend

    showAct: Ember.Route.transitionTo('acts.act')

    acts: Ember.Route.extend
      route: '/acts'
        
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('acts', Sysys.store.findAll(Sysys.Act))

      index: Ember.Route.extend
        route: '/'

        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('acts')


      act: Ember.Route.extend
        enter: ->
            
        route: '/:act_id'

        connectOutlets: (router, act) ->
          # TODO(syu): figure out how to handle case of outlet doesn't exist
          unless act.get('isLoaded')
            router.transitionTo('root.acts') 
          else
            router.get('applicationController').connectOutlet('act', act)





          ###
    acts: Ember.Route.extend
      route: 'acts'
      
      connectOutlets: (router, context) ->
        actController = router.get('actController')
      ###

  enableLogging: true
