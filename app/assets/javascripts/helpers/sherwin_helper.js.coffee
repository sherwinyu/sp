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

# Handlebars.registerHelper "key_value", (obj, fn) ->
# debugger
# obj = {key1: "value1", key2: "value2" }
# (fn(key: key, value: value) for own key, value of obj).join('')
