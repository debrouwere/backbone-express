fs = require 'fs'
path = require 'path'
express = require 'express'
_ = require 'underscore'
_.str = require 'underscore.string'
# TODO: this isn't proper, 'fcourse
#{sync} = require '../example/vendor/backbone-express-client/0.1.0/index.coffee'

fetch_collections = (root) ->
    files = fs.readdirSync path.join root, '/lib/models'
    collections = _(files).chain()
        .map (file) ->
            if _.str.endsWith file, '.js'
                objects = require path.join root, '/lib/models/', file
                return _.filter objects, (object) ->
                    # collections have an `all` method, models do not
                    object::all?
            else
                return false
        .compact()
        .flatten()
        .value()

methods =
    post: "create"
    get: "read"
    put: "update"
    delete: "delete"

exports.serve = (root, routers) ->
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
    ###
    collections = fetch_collections root
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

            method = methods[req.method.toLowerCase()]

            sync method, model, success: (model, response) ->
                res.contentType 'application/json'
                res.send response.body 
    ###

    app
