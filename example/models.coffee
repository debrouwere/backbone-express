Backbone = require 'backbone-express-client'

class exports.Instrument extends Backbone.Model

class exports.Instruments extends Backbone.Collection
    model: exports.Instrument
    plural: 'instruments'
    endpoint: 'https://raw.github.com/stdbrouw/backbone-express-example/master/src/assets/data.json'
    endpoint: 'http://localhost:3400/clientside/backbone-express-example/src/assets/data.json'
