Backbone = require 'backbone-express-client'

class exports.Layout extends Backbone.View
    template: require './templates/layout'

class exports.Home extends Backbone.View
    id: 'page'
    title: 'Homepage'
    template: require './templates/home'

class exports.Detail extends Backbone.View
    id: 'page'
    title: 'Detail'
    template: require './templates/detail'

###
prepare: (callback) ->
    new models.Breads().fetch success: (breads) =>
        @options.breads = breads
        callback()
    callback()
###
