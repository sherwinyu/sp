Sysys.Store = DS.Store.extend
  revision: 10,
  adapter: DS.RESTAdapter.create()

Sysys.store = new Sysys.Store
