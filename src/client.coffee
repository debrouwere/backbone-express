exports ?= {}

# DEBUGGING

log = ->
    window.log.apply @, arguments

if process?
    Backbone = require 'backbone'
    request = require 'request'
else
    Backbone = window.Backbone

methods =
    create: "post"
    read: "get"
    update: "put"
    delete: "del"

exports.url_for = (object) ->
    if object.url instanceof Function
        object.url()
    else if typeof object.url is 'string'
        object.url

class exports.Router extends Backbone.Router
    render: (views, options = {}) ->    
        # we only render layout chrome when we really need to (a.k.a. on the server)
        # TODO: @server disabled because it's not working, but we really do need 
        # to make this distinction or client-side rendering will be really suboptimal
        if @layout and window.Express.isServer
            log 'ADD LAYOUT'
            views.unshift @layout
    
        # TODO: if we keep view.prepare in there, we'll need to replace 
        # this with async.series because subviews may depend on a more 
        # general view being rendered first.
        
        for view in views
            # TODO: run view.prepare first before rendering
            # (Or should fetching models not be a part of view rendering? Fair question.)

            # If we get a view that's already instantiated, we 
            # don't try to instantiate it again
            unless view.options?
                view = new view options
            
            view.render window

        # on the server, once we've molded our window.document to look exactly how
        # we want, we still need to send it to the client
        if @server
            html = '<!DOCTYPE html>\n' + window.document.getElementsByTagName('html')[0].outerHTML
            log "rendering #{@server.req.url}"
            @server.res.send html

        return this

class exports.View extends Backbone.View
    _ensureElement: ->
            
    prepare: ->

    # `window` is a keyword argument because on the server, we explicitly
    # pass in a window object since there's no `window` global
    render: ->
        log 'VIEW RENDER FOR ' + @id
        if @id
            el = window.document.getElementById @id
        else
            # for client-side apps, it makes much more sense to apply layouts to the body and not 
            # to the entire document -- that stuff should be in your app entrypoint: the single
            # page people refer to when talking about single-page apps.
            el = window.document.getElementsByTagName('body')[0]

        el.innerHTML = @template(@options)

        title = @options.title or @title
        if title
            window.document.getElementsByTagName('title')[0].innerHTML = title

        return this

exports.sync = (method, model, options) ->
    params =
        method: methods[method]
        uri: exports.url_for(model)

    request params, (error, response, body) ->
        content = JSON.parse body
    
        if !error and response.statusCode < 300
            options.success content, response
        else
            options.error error, response

class exports.Model extends Backbone.Model
    sync: exports.sync

error = (model, response) ->
    throw new Error("Couldn't fetch #{model}.")

class exports.Collection extends Backbone.Collection
    sync: exports.sync

    # fetch content from external APIs through a relay when fetching client-side, 
    # to avoid AJAX cross-domain limitations
    url: ->
        if window.Express.isServer
            @endpoint
        else
            "/api/#{@plural}"

    # prepares a query for a collection without actually executing it
    query: (data = {}) ->
        (success) => @fetch {data, success, error}

window.Express = _.extend {}, Backbone, exports

###
Rendering API (server-side and client-side)

    @render [view_a, view_b, view_c], options

also possible:

    @render [new view_a(options), view_b, view_c], options

when given an initiated view, it'll render it, and when given a class, it'll 
instantiate that class first, with any general options if specified

What about partial renders? Well, we can respond to click events etc.
with partial renders, but for pages we need a full render.
Potentially, we could specify a default layout somewhere so the client-side
can skip a full rerendering on page changes (PJAX-like) but the server-side
knows where to get the chrome it needs
###
