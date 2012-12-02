Sysys.Store = DS.Store.extend
  revision: 4,
  adapter: DS.RESTAdapter.create()

Sysys.store = new Sysys.Store
