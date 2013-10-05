# //  humanize an ISO date -from-now using Moment.js
# //  http://momentjs.com/
# //  moment syntax example: moment(Date("2011-07-18T15:50:52")).format("MMMM YYYY")
# //  usage: {{dateFromNow creation_date}}
Handlebars.registerHelper('as_json',  (object, options) ->
  # zorg = @get(object)
  zorg = Ember.get(this, object)
  return JSON.stringify zorg

# if (window.moment and @get(date)) {
# // var f = block.hash.format || "MMM Do, YYYY";
# return moment(this.get(date)).fromNow();
# }else{
# return date;   //  moment plugin not available. return data as is.
# }
)

# Handlebars.registerHelper 'isEnumerable'

# Handlebars.registerHelper "key_value", (obj, fn) ->
# debugger
# obj = {key1: "value1", key2: "value2" }
# (fn(key: key, value: value) for own key, value of obj).join('')
#
#
#
Ember.Handlebars.registerBoundHelper('eachO', (path, options) ->
  console.log 'zugzug'
  if arguments.length == 4
    Ember.assert("If you pass more than one argument to the each helper, it must be in the form #each foo in bar", arguments[1] == "in")
    keywordName = arguments[0]
    options = arguments[3]
    path = arguments[2]
    if path == ''
      path = "this"
    options.hash.keyword = keywordName
  else
    options.hash.eachHelper = 'each'


  options.hash.contentBinding = path
  #  Set up emptyView as a metamorph with no tag
  #  options.hash.emptyViewClass = Ember._MetamorphView;

  # if (options.data.insideGroup && !options.hash.groupedRows && !options.hash.itemViewClass) {
  # new Ember.Handlebars.GroupedEach(this, path, options).render();
  # } else {
  return Ember.Handlebars.helpers.collection.call(@, 'Ember.Handlebars.EachView', options)
  # }
)


Ember.Handlebars.registerBoundHelper('repeat', (value, options) ->
  # count = options.hash.count
  # a = []
  # while(a.length < count)
    # a.push(value)
    # return a.join('')
  options.hash.val = value

  return Ember.Handlebars.helpers.view.call(@, Sysys.RepeatView, options);
)
