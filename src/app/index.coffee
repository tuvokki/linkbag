express    = require 'express'
restful    = require 'node-restful'
bodyParser = require 'body-parser'

mongoose   = restful.mongoose
app        = express()
serverPort = 3019
running    = false

app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})
app.use express.query()
app.use (req, res, next) ->
  res.header "Access-Control-Allow-Origin",
             "*"
  res.header "Access-Control-Allow-Headers",
             "Origin, X-Requested-With, Content-Type, Accept"
  next()
  #prevent from returning
  return

BaggedLink = app.baggedlink = restful.model 'baggedlink', mongoose.Schema {
  urlletje: String,
  tags: [String],
  updated: { type: Date, default: Date.now },
  active: Boolean
}
.methods ['get', 'post', 'put', 'delete']

BaggedLink.register app, '/linkbag'

mongoose.connect "mongodb://localhost/resources", (error) ->
  if error
    console.log 'error connecting to mongoose, is the local server running?'
    process.exit()
  else
    console.log 'Starting server on port %s ... ', serverPort
    app.listen serverPort
  return
