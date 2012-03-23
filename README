# Backbone-express

Backbone-express is a compatibility layer that allows you to run client-side Backbone applications on the server. With Backbone-express your site will gracefully degrade for clients that don't have JavaScript, including search engines.

This application is useful if (and only if) you want to build a website entirely in JavaScript, yet still need it to be searchable. Working on a website that is sort of in between a site and an app, is api-driven, needs to be searchable, and you were planning on using Backbone anyway? This is for you.

When not to use Backbone-express? If your website doesn't have a big JavaScript component (most news websites, say), use a server-side framework like Django or Rails or Express instead. If your website is really an app, it makes no sense for Google to index anything and you should use plain Backbone without the overhead of Backbone-express.

Backbone-express tries to be transparent. You can't quite feed it a client-side Backbone.js and get it to work server-side as-is, but required changes are minimal.

## Project status

Backbone-express is highly experimental, alpha, under heavy development, however you'd like to call it. Please don't use this... yet.

## Features

* Translates Backbone.js routes into express.js routes on the server
* Renders Backbone.js views without the need for a global `window` object
* With the help of Ender, bundles up your application JavaScript, templates and vendor libraries
* `require` in the browser, so you can split your application into logical chunks
* Provides `/api/<collection>` and `/api/<collection>/<id>` endpoints so you don't have to worry about cross-domain scripting

## Getting started

1. `var Backbone = require('backbone-express-client');` -- you'll be using this instead of plain Backbone
2. Create a Backbone router with some routes and a Backbone view.
3. You can render that view with `this.render([view, ...], options)` on your router object. You'll want to do this instead of calling `view.render` directly, because `router.render` will facilitate server-side template rendering.
4. Initialize your app by `require`'ing your router, instantiating it and then enabling HTML5 `pushState` support with `Backbone.history.start({pushState: true, silent: true});`.
5. Hijack link clicks in your application so they use `router.navigate(url, true)` instead of actually requesting the page behind that link.
6. Create a layout chrome template and a view template. Specify the layout as a static property on your router. Require the view template and specify it as a static property on your view. Your router and view will then take care of rendering whatever needs to be rendered, both client-side and server-side.
7. In your layout chrome, make sure to load the `ender.min.js` and `application.min.js` scripts, and to run your initialization script, e.g. by opening a script tag and running `require('initialize');` or however your init script from step 4 is called.

Note that Backbone-express is centered entirely around your routes. If you have views that only render whenever a model changes or whenever an event occurs, but not when a route activated, those will only work client-side. (Though they won't crash your server.) Backbone-express provides graceful degradation, not emulation.

## Todo

* better error messages
* easier building and serving process, should work transparently with CoffeeScript
* live rebuilding
* better inline docs and getting started docs
