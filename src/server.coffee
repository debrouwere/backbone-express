request = require 'request'
express = require 'express'
_ = require 'underscore'
_.str = require 'underscore.string'

# TODO: `methods`, `url_for` and `sync` are duplicated in backbone-express-client
# if possible try to define a single time and reuse, and see if I really
# use them in both files
methods =
    http:
        create: "post"
        read: "get"
        update: "put"
        delete: "del"
    backbone:
        post: "create"
        get: "read"
        put: "update"
        delete: "delete"

url_for = (object) ->
    if typeof object.url is 'function'
        object.url()
    else if typeof object.url is 'string'
        object.url

sync = (method, model, options) ->
    console.log typeof model.url

    params =
        method: methods.http[method]
        uri: url_for(model)

    request params, (error, response, body) ->
        content = JSON.parse body
    
        if !error and response.statusCode < 300
            options.success content, response, body
        else
            options.error error, response, body

getCollections = (models) ->
    _.filter models, (object) ->
        # collections have an `all` method, models do not
        object::all?

exports.serve = (root, routers, models) ->
    app = express.createServer()
    
    # serve static assets
    app.use '/assets', express.static root + '/lib/assets'

    # translate backbone.js client-side routes into express.js server-side routes
    # TODO: support multiple routers (most apps only have one, but not always)
    Router = routers.Router
    router = new Router()
    
    _(router.routes).each (view, route) ->
        console.log "mapped /#{route} to #{view}"
        app.get '/' + route, (req, res) ->
            router.server = {req, res}
            router[view].apply router, _.values req.params

    # provide a proxy to sidestep cross-domain scripting issues
    # TODO: temporarily disabled while I'm trying to get backbone-express
    # running again with the new 'nobones' architecture

    collections = getCollections models
    _(collections).each (collection) ->
        collection = new collection()
        route = "/api/#{collection.plural}/:id?"

        # TODO: flesh out / replace with node-http-proxy
        app.all route, (req, res) ->
            model = collection
            endpoint = collection.endpoint
            
            if req.params.id
                model = collection.model
                endpoint = endpoint + "/#{req.params.id}"

            method = methods.backbone[req.method.toLowerCase()]

            sync method, model, success: (model, response, body) ->
                res.contentType 'application/json'
                res.send body

    app
