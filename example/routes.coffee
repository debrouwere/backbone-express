#Backbone = require 'backbone-express-client'
#async = require 'async'
#views = require './views'
#models = require './models/models'

{Express, views} = window

window.test = yes

# TODO: express-client should initialize this
window.routers = routers = {}

class routers.Router extends Express.Router
    # `Router#render` will figure out whether or not it 
    # needs to render the layout chrome
    layout: views.Layout

    routes:
        '': 'home'
        'about': 'detail'

    home: ->
        @render [views.Home], instruments: []
        
        #async.parallel queries, (error, resources) =>
        #new models.Instruments().query() (errors, instruments) =>
        #    @render [views.Home], instruments: instruments

    detail: ->
        @render [views.Detail]
