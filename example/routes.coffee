{Express, views, models} = window

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

        #log new models.Instruments().query()
        
        ###
        new models.Instruments().query() (errors, instruments) =>
            @render [views.Home], instruments: instruments
        ###

    detail: ->
        @render [views.Detail]
