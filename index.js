var express = require('express'),
    restful = require('node-restful'),
    mongoose = restful.mongoose;
var app = express();

var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));

app.use(express.query());
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

mongoose.connect("mongodb://localhost/linkbagdb");

var BaggedLink = app.baggedlink = restful.model('baggedlink', mongoose.Schema({
    urlletje: String,
    tags: [String],
    updated: { type: Date, default: Date.now },
    active: Boolean
  }))
  .methods(['get', 'post', 'put', 'delete']);

BaggedLink.register(app, '/linkbag');

console.log('Starting server on port 3019 ... ');
app.listen(3019);
