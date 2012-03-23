models = window.models = {}
{Express} = window

class models.Instrument extends Express.Model

class models.Instruments extends Express.Collection
    model: models.Instrument
    plural: 'instruments'
    endpoint: 'https://raw.github.com/stdbrouw/backbone-express/master/example/assets/data.json'
