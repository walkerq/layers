var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mysql = require("mysql");
// var createjs = require("createjs-soundjs")

app.use(express.static(__dirname + "/public"));
app.use(bodyParser.json());

//do music stuff:
/*createjs.Sound.on("fileload", handleLoadComplete);
createjs.Sound.alternateExtensions = ["mp3"];
createjs.Sound.registerSound({src:"public/music/Nikes.mp3", id:"nikes"});
function handleLoadComplete(event) {
    createjs.Sound.play("nikes");
}
*/

//Creates connection to the MySQL database
var con = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "sesame", //***NOTE: CHANGE THIS TO YOUR MYSQL PASSWORD***
  database: "layers_project",
  multipleStatements: "true"
});

con.connect(function(err){
  if(err){
    console.log('Error connecting to Db');
    return;
  }
  console.log('Connection established'); 
});

/* Model Query Handlers (app.get, app.post, or app.put):
use http objects to receive data from a controller in app.js,
use Node-MySQL to form database queries, and
send query results back to controller as JSON */
app.get('/layers/', function (req, res) {
	con.query(
	  	'SELECT * FROM layer a ',
	  function(err,rows){
	    if(err) throw err;
	    res.json(rows);
	  }
	)
});

app.post('/addLayer', function (req, res) {
	con.query(
	  	'CALL insert_layer(?,?,?,?)',
	  	[req.body.data[0].LayerName,req.body.data[0].Length_of_Layer,
	  	req.body.data[0].FileLayer, req.body.data[0].Username],
	  function(err,rows){
	    if(err) throw err;
	    console.log(req.body.LayerName + ' added to the DB\n');
	  })
});

app.get('/editLayer/:id', function(req, res) {
	var id = req.params.id;
	con.query(
	  	'SELECT * FROM layer WHERE layerID = ' + id + ";",
	  function(err,rows){
	    if(err) throw err;
	    res.json(rows);
	  }
	)
});

app.post('/deleteHashtag/:id', function (req, res) {
	con.query(
	  	'CALL delete_hashtag_layer(?)',
	  	[req.params.id],
	  function(err,rows){
	    if(err) throw err;
	    console.log(rows);
	  }
	)
});

app.post('/addHashtag/', function (req, res) {
	con.query(
	  	'CALL insert_hashtag_layer2(?,?)',
	  	[req.body.hashtag, req.body.layerID],
	  function(err,rows){
	    if(err) throw err;
	    console.log("hashtag " + req.body.hashtag + " added to layer " + req.body.layerID);
	    console.log(rows);
	  }
	)
});

app.get('/layers/:id', function(req, res) {
	  con.query(
	  	'SELECT * FROM layer WHERE LayerID = \'' + req.params.id + '\'; \
	  	SELECT * FROM layer_junction lj JOIN layer l ON lj.BaseLayerID = \
	  	l.LayerID WHERE LinkedLayerID = \'' + req.params.id + '\'; SELECT \
	  	* FROM layer_junction lj JOIN layer l ON lj.LinkedLayerID = l.LayerID \
	  	WHERE BaseLayerID = \'' + req.params.id + '\'; SELECT * FROM \
	  	hashtag_layer WHERE LayerID = \'' + req.params.id + '\';',
	  function(err,rows){
	    if(err) throw err;
	    res.json(rows);
	  }
	)
});

app.put('/updateLayer/:id', function (req, res) {
	con.query(
	  'CALL update_layer_name(?, ?)',
	  [req.body.data[0].LayerName, req.body.data[0].LayerID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('Layer name changed');
	    console.log(rows);
	  }
	)
});

app.get('/artists/:Username', function (req, res) {
	con.query(
	  	'SELECT * FROM user WHERE Username = \'' + req.params.Username + '\';',
	  function(err,rows){
	    if(err) throw err;
	    res.json(rows);
	  }
	)
});

app.post('/signUpUser/', function (req, res) {
	con.query(
	  	'CALL insert_user(?,?,?)',
	  	[req.body.Username, req.body.age, req.body.country],
	  function(err,rows){
	    if(err) throw err;
	    console.log(req.body.Username + ' added to the DB\n');
	  })
});

app.post('/addLinkedLayer/', function (req, res) {
	con.query(
	  	'CALL insert_layer_junction(?,?)',
	  	[req.body.BaseLayerID, req.body.LinkedLayerID],
	  function(err,rows){
	    if(err) throw err;
	    console.log(req.body.BaseLayerID + ' linked to ' + req.body.LinkedLayerID);
	  })
});

//Tells Express to listen on port 3000 (http://localhost:3000/)
app.listen(3000);
console.log("Server running on port 3000");