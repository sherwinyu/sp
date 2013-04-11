# This pulls in all your specs from the javascripts directory into Jasmine:
# 
# spec/javascripts/*_spec.js.coffee
# spec/javascripts/*_spec.js
# spec/javascripts/*_spec.js.erb
# require_self
#
#= require sinon
#= require jasmine-sinon
#= require ../../app/assets/javascripts/vendor/jasmine-jquery
#= require ../../app/assets/javascripts/dependencies
#= require_self
#= require ../../app/assets/javascripts/sysys
#= require_tree ./
@TESTING = true

