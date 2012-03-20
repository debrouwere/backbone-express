# 1. extend Backbone

# 2. set up development environment

script.getElementsByTagName('script').forEach (script) ->
    if script['data-express-environment'] is 'production'
        script.parentNode.removeChildNode script
