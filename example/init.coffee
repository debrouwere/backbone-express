# TODO: if this is the only initialization you need, we could provide an
# Express.initialize(window) function.

$(document).ready ->
    #window.Backbone = Backbone = require 'backbone'
    #{Router} = require './routes'
    router = new window.routers.Router()

    state = Backbone.history.start
        pushState: yes     # HTML5 history support
        silent: yes
    
    # All navigation that is relative should be passed through the navigate
    # method, to be processed by the router.  If the link has a data-bypass
    # attribute, bypass the delegation completely.

    $(document).delegate "a:not([data-bypass])", "click", (event) ->
        # Get the anchor href and protocol
        url = event.target.getAttribute('href', 2)
        external_link = url.slice(0, 4) is 'http'
        
        unless external_link
            router.navigate url, true

        event.preventDefault()
