###
DONE

- switch draughtsman over to preprocessor instead of its own compilation library
- implement a ?raw flag in draughtsman

IN PROGRESS (IN OTHER APPS)

- environments (Envv)
- handling various preprocessors (Tilt.js, available through Railgun and Draughtsman) 
- concatenation and optimization (Railgun)

TODO

- work on HTML parsing and getting all models, collections and routers first
- then integrate that with the existing backbone-express code (start with just routes, proxy is less important)
- modify the example so it works entirely on the client-side (save for fetching data), meaning template compilation, stylus compilation etc.
- integrate the proxy code from the old backbone-express again
- CLI with -p --port to pick a port, and -n --no-api for users that don't want the proxy
- enable logging (preferably with a client-side logging endpoint [though what/how to log is up to the user on the client-side], so we can merge client-side and server-side errors in a single file)

we need to do two passes through index.html

1. concatenation, optimization and preprocessing (using the Railgun API)

We do this first so backbone-express doesn't have to deal with preprocessing CoffeeScript, ClojureScript etc.

2. load the page and associated scripts, and sniff for Backbone models and routers in `window`

We look for everything in window.models, window.routers and window itself to find models, collections and routers

We need to do this in JSDOM and execute all JavaScript on the page because you can never be sure people use window properties or stuff like that to set up their models dynamically.
###

fs = require 'fs'
fs.path = require 'path'
_ = require 'underscore'
# TODO: once railgun is more stable, require it as a regular package
railgun = require '/Users/stdbrouw/Projects/Apps/railgun/src'
jsdom = require 'jsdom'
server = require './server'

{argv} = require 'optimist'

root = fs.path.join process.cwd(), argv._[0]

railgun.bundle root, (errors, bundle) ->
    #console.log JSON.stringify bundle, undefined, 4

    index = (bundle.find '/index.jade').content
    # TODO: should be `content` too, this is a bug in Railgun that should be fixed
    application = (bundle.find '/application.min.js').origin

    # TODO: we should automate this, of course
    # NOTE that we shouldn't really load init since we don't need that
    # on the server (though perhaps it does no harm)
    scripts = [
        'vendor/jquery/1.7.1/jquery.min.js',
        'vendor/underscore/1.3.1/underscore.min.js',
        'vendor/backbone/0.9.1/backbone.min.js'
        'vendor/jade/0.21.0/runtime.min.js'
        ]

    scripts = scripts.map (script) ->
        path = fs.path.join process.cwd(), 'example', script
        fs.readFileSync path, 'utf8'
    scripts.push application

    env =
        html: index
        src: scripts
        done: (errors, window) ->
            ###
            console.log errors
            console.log window.Backbone?
            console.log window.Express?
            console.log _.keys window.models
            console.log _.keys window.views
            console.log _.keys window.jade.templates
            ###

            window.Express.isServer = yes
            window.log = console.log
            
            express = server.serve null, window.routers, window.models
            #window.close()
            express.listen 3000
            
    jsdom.env env
