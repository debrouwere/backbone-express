views = window.views = {}
{Express, jade: {templates}} = window

class views.Layout extends Express.View
    template: templates.layout

class views.Home extends Express.View
    id: 'page'
    title: 'Homepage'
    template: templates.home

class views.Detail extends Express.View
    id: 'page'
    title: 'Detail'
    template: templates.detail

###
prepare: (callback) ->
    new models.Breads().fetch success: (breads) =>
        @options.breads = breads
        callback()
    callback()
###
