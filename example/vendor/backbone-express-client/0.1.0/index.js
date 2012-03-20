(function() {
  var Backbone, error, establish_window, methods, request,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  if (typeof exports === "undefined" || exports === null) exports = {};

  if (typeof process !== "undefined" && process !== null) {
    Backbone = require('backbone');
    request = require('request');
  }

  methods = {
    create: "post",
    read: "get",
    update: "put",
    "delete": "del"
  };

  establish_window = function(callback) {
    var jsdom;
    if (typeof process !== "undefined" && process !== null) {
      jsdom = require('jsdom');
      return jsdom.env('<html></html>', function(errors, window) {
        return callback(errors, window);
      });
    } else {
      return callback(void 0, window);
    }
  };

  exports.url_for = function(object) {
    if (object.url instanceof Function) {
      return object.url();
    } else if (typeof object.url === 'string') {
      return object.url;
    }
  };

  exports.Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.render = function(views, options) {
      var _this = this;
      if (options == null) options = {};
      if (this.layout && this.server) views.unshift(this.layout);
      return establish_window(function(errors, window) {
        var html, view, _i, _len;
        for (_i = 0, _len = views.length; _i < _len; _i++) {
          view = views[_i];
          if (view.options == null) view = new view(options);
          view.render(window);
        }
        if (_this.server) {
          html = '<!DOCTYPE html>\n' + window.document.getElementsByTagName('html')[0].outerHTML;
          console.log("rendering " + _this.server.req.url);
          _this.server.res.send(html);
        }
        return _this;
      });
    };

    return Router;

  })(Backbone.Router);

  exports.View = (function(_super) {

    __extends(View, _super);

    function View() {
      View.__super__.constructor.apply(this, arguments);
    }

    View.prototype._ensureElement = function() {};

    View.prototype.prepare = function() {};

    View.prototype.render = function(window) {
      var el, title;
      if (window == null) window = window;
      if (this.id) {
        el = window.document.getElementById(this.id);
      } else {
        el = window.document.getElementsByTagName('html')[0];
      }
      el.innerHTML = this.template(this.options);
      title = this.options.title || this.title;
      if (title) {
        window.document.getElementsByTagName('title')[0].innerHTML = title;
      }
      return this;
    };

    return View;

  })(Backbone.View);

  exports.sync = function(method, model, options) {
    var params;
    params = {
      method: methods[method],
      uri: exports.url_for(model)
    };
    return request(params, function(error, response, body) {
      var content;
      content = JSON.parse(body);
      if (!error && response.statusCode < 300) {
        return options.success(content, response);
      } else {
        return options.error(error, response);
      }
    });
  };

  exports.Model = (function(_super) {

    __extends(Model, _super);

    function Model() {
      Model.__super__.constructor.apply(this, arguments);
    }

    Model.prototype.sync = exports.sync;

    return Model;

  })(Backbone.Model);

  error = function(model, response) {
    throw new Error("Couldn't fetch " + model + ".");
  };

  exports.Collection = (function(_super) {

    __extends(Collection, _super);

    function Collection() {
      Collection.__super__.constructor.apply(this, arguments);
    }

    Collection.prototype.sync = exports.sync;

    Collection.prototype.url = function() {
      if (typeof process !== "undefined" && process !== null) {
        return this.endpoint;
      } else {
        return "/api/" + this.plural;
      }
    };

    Collection.prototype.query = function(data) {
      var _this = this;
      if (data == null) data = {};
      return function(success) {
        return _this.fetch({
          data: data,
          success: success,
          error: error
        });
      };
    };

    return Collection;

  })(Backbone.Collection);

  window.Express = _.extend({}, Backbone, exports);

  /*
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
  */

}).call(this);
