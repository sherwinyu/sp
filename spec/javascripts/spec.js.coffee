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
#
#
#= require ../../app/assets/javascripts/vendor/jquery-autogrow-textarea
#= require ../../app/assets/javascripts/vendor/jquery-autogrow-textarea-plus
#= require ../../app/assets/javascripts/vendor/jquery.hotkeys
#= require ../../app/assets/javascripts/vendor/date
#= require ../../app/assets/javascripts/vendor/moment
#= require ../../app/assets/javascripts/vendor/jquery-ui-timepicker-addon
#= require ../../app/assets/javascripts/vendor/humon
@TESTING = true

