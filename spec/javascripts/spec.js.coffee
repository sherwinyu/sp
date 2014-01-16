# This pulls in all your specs from the javascripts directory into Jasmine:
#= require jquery
#= require handlebars
#= require ember
#= require ember-data

#= require sinon
#= require jasmine-sinon
#= require ../../app/assets/javascripts/vendor/jasmine-jquery
#= require ../../app/assets/javascripts/dependencies
#
#= require_self
#= require ../../app/assets/javascripts/sysys
#= require_tree ./
#
Em.testing = true

