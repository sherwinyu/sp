Sysys.Store = DS.Store.extend
  revision: 9,
  adapter: DS.RESTAdapter.create()

Sysys.store = new Sysys.Store
