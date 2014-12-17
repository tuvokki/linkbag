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

mongoose.connect("mongodb://localhost/resources");

var Resource = app.resource = restful.model('resource', mongoose.Schema({
    title: 'string',
    year: 'number',
  }))
  .methods(['get', 'post', 'put', 'delete']);

Resource.register(app, '/resources');

console.log('Starting server on port 3019 ... ');
app.listen(3019);
