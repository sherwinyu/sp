#= require_self
#= require vendor/jquery-1.9.1
#= require handlebars
#= require ember
#= require ember-data
#= require vendor/moment.min
# require moment ------- not using bundled moment for now because it's stuck on 2.0
#
#= require vendor/mousetrap
#= require vendor/jquery.hotkeys
#= require vendor/humon
@ENV =
  FEATURES:
    'query-params-new': true
