#Backbone = require 'backbone-express-client'
#async = require 'async'
#views = require './views'
#models = require './models/models'

window.test = yes

# TODO: express-client should initialize this
window.routers = {}

class window.routers.Router extends window.Express.Router
    # `Router#render` will figure out whether or not it 
    # needs to render the layout chrome
    #layout: views.Layout

    routes:
        '': 'home'
        'about': 'detail'

    home: ->
        #async.parallel queries, (error, resources) =>
        #new models.Instruments().query() (errors, instruments) =>
        #    @render [views.Home], instruments: instruments

    detail: ->
        #@render [views.Detail]
