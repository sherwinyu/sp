slowPromise = ->
  new Ember.RSVP.Promise((resolve) ->
    setTimeout (->
      resolve [
        title: "a"
      ,
        title: "b"
      ,
        title: "c"
      ]
    ), 1500
  )

Sysys.Router.map ->
  @resource "sexy_articles", ->

Sysys.SexyArticlesIndexRoute = Ember.Route.extend
  model: slowPromise
