###
We need to do two passes through index.html

1. concatenation, optimization and preprocessing (using the Railgun API)

We do this first so backbone-express doesn't have to deal with preprocessing CoffeeScript, ClojureScript etc.

2. load the page and associated scripts, and sniff for Backbone models and routers in `window`

We look for everything in window.models, window.routers and window itself to find models, collections and routers

We need to do this in JSDOM and execute all JavaScript on the page because you can never be sure people use window properties or stuff like that to set up their models dynamically.
###

fs = require 'fs'
fs.path = require 'path'
_ = require 'underscore'
jsdom = require 'jsdom'
# TODO: once railgun is more stable, require it as a regular package
railgun = require '/Users/stdbrouw/Projects/Apps/railgun/src'
server = require './server'

exports.serve = (root, port) ->
    basepath = fs.path.dirname root

    railgun.bundle root, (errors, bundle) ->
        index = (bundle.find '/index.html').content
        application = (bundle.find '/application.min.js').content

        scripts = bundle.optimizedLinks.scripts.map (script) ->
            script = bundle.find '/' + script

            # TODO: make this work for external (web) resources too
            unless script.content
                path = fs.path.join basepath, script
                script.content = fs.readFileSync path, 'utf8'

            script.content

        env =
            html: index
            src: scripts
            done: (errors, window) ->
                window.Express.isServer = yes
                window.log = console.log

                # create our backbone-express compatibility server
                express = server.createServer window.routers, window.models
                # add static file serving
                express.use railgun.static bundle
                # listen on specified port
                express.listen port
        jsdom.env env
