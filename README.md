# Backbone-express

Backbone-express is a compatibility layer that allows you to run client-side Backbone applications on the server. With Backbone-express your site will gracefully degrade for clients that don't have JavaScript, including search engines.

This application is useful if (and only if) you want to build a website entirely in JavaScript, yet still need it to be searchable. If you are working on a website that is sort of in between a site and an app, is API-driven, needs to be searchable and you were planning on using Backbone anyway, this is for you.

When not to use Backbone-express?

* If your website doesn't have a big JavaScript component (most news websites, say), use a server-side framework like Django or Rails or Express instead.
* If your website is really an app, it makes no sense for Google to index anything and you should use plain Backbone without the overhead of Backbone-express.

## Project status

Backbone-express is highly experimental, alpha, under heavy development, however you'd like to call it. Please don't use this... yet.

## Installation

`npm install backbone-express -g`

## Getting started

You can turn any Backbone.js app into a Backbone-express app with a couple of easy steps

1. Load `backbone-express.min.js` instead of `backbone.min.js`
2. Have routers, models and collections extend from `Express` instead of `Backbone`, e.g. use `Express.Router` instead of `Backbone.Router`
3. Put models and collections on `window.models`, routers on `window.routers` and views on `window.views`
4. Start Backbone's history with `Backbone.history.start({pushState: true, silent: true});` to enable HTML5 pushState support and to suppress rendering on initial page load (because it's already been rendered server-side)

Now you can serve your app with `backbone-express path/to/app.html`.

Backbone-express will render your application server-side on initial requests: for clients that don't support JavaScript or when your JavaScript hasn't loaded yet (before your router is activated). Essentially, it translates your Backbone routes into [Express.js](http://expressjs.com/) routes and renders view on the server whenever necessary.

Note that Backbone-express is centered entirely around your routes. If you have views that only render whenever a model changes or whenever an event occurs, but not when a route activated, those will only work client-side. (They won't crash your server, though.) Backbone-express provides graceful degradation on the server, not emulation.

The source code contains a complete example app -- check it out.

### Optimization

Backbone-express also minifies and concatenates your JavaScript and modifies your HTML to point to an optimized `application.min.js` instead, so don't worry about splitting up your application into separate files for models, views and routes.

To learn more about optimization works, look at the documentation for the [Railgun](https://github.com/stdbrouw/railgun) application, which takes care of this for Backbone-express.

## Advanced usage

Backbone-express has a couple of tricks up its sleeve beyond providing a server-side compatibility layer for Backbone. You're free to use or not use these additional features as you please.

### API proxy

If you want to access external APIs through JavaScript without using [CORS](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing) or [JSONP](http://en.wikipedia.org/wiki/JSONP), you can use Backbone-express its built-in API proxy.

To use the API proxy, don't override `Collection#url` but instead put your API endpoint on `Collection#endpoint` instead. Backbone-express will then take care of proxying requests to other servers through `/api/:collection` and `/api/:collection/:id` routes on the app server.

### Preprocessing

Before serving your application, Backbone-express will actually optimize it, preprocess anything it can (such as CoffeeScript, LESS and other CSS preprocessors) and precompile templates (such as Handlebars, Jade or Mustache).

For example, if you have `<script src="templates/dashboard.handlebars" type="text/x-handlebars-template"></script>` in your html, Backbone-express will precompile that template and make it a part of your `application.min.js`. Your template would be available under `window.Handlebars.templates`.

Even the "single page" of your single-page app can be in any template language you choose. Serving `backbone-express path/to/app.handlebars` will work just fine.

Optimization is taken care of by [Railgun](https://github.com/stdbrouw/railgun), which in turn depends on [Tilt.js](https://github.com/stdbrouw/tilt.js) to preprocess templates, compile-to-JavaScript languages and so forth.

You can look at the documentation for Railgun and Tilt.js to find out more about the optimization and preprocessing capabilities of Backbone-express.

### Environments

Backbone-express has support for development environments using [Envv](https://github.com/stdbrouw/envv), allowing you to change what code executes depending on whether you're in a development or production environment. This can be useful to disable error logging or analytics in development.

Environments can also be useful when using template preprocessors or CoffeeScript. A contrived example: 

    <script src="models.coffee" data-runtime="build/models.js" />

(The example is contrived because Backbone-express will actually precompile CoffeeScript for you -- see the documentation about preprocessing above.)

Read more about environments and how you can use them in your application in the [Envv](https://github.com/stdbrouw/envv) documentation.

## Troubleshooting

To make sure server-side rendering actually works, it makes sense to disable JavaScript in your browser or your testing framework.
