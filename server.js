var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mysql = require("mysql");

app.use(express.static(__dirname + "/public"));
app.use(bodyParser.json());

// First you need to create a connection to the db
var con = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "sesame",
  database: "layers_project"
});

con.connect(function(err){
  if(err){
    console.log('Error connecting to Db');
    return;
  }
  console.log('Connection established'); 
});

var input_Username = 'test1';
var input_Password = 'Example1';
var input_FirstName = 'Example1';
var input_LastName = 'Example1';
var input_DOB= '1992-8-07';
var input_UserID= 6;

var insertUser = false; //these are supposed to be collecting user input
//check triggers and consider what data validation is necessary
//test user input against those SQL triggers
var updateUserUsername = false;
var updateUserPassword = false;
var updateUserFirstName = false;
var updateUserLastName = false;
var updateUserDOB = false;
var deleteUser = false;

//TODO: currently this code is being triggered by a get request. it needs to be triggered instead by
//user input, so it needs to be called by search.
app.get('/layerlist', function(req, res) {
	console.log("Model received a GET request");

	con.query(
	  'SELECT * FROM layer',
	  function(err,rows){
	    if(err) throw err
	    console.log('SELECT ran successfully\n');
	    console.log(rows);
	    res.json(rows);
	    } 
	)

/*	con.end(function(err) {
  // The connection is terminated gracefully
  // Ensures all previously enqueued queries are still
  // before sending a COM_QUIT packet to the MySQL server.
	});*/
});

app.post('/layerlist', function (req, res) {
	console.log(req.body);
	console.log(req.body.LayerName);
	console.log(req.body.UserID);
	con.query(
	  	'SELECT * FROM Layer WHERE LayerName = \'' + req.body.LayerName + '\'',
/*		'AND UserID = \'' + ... '\''),
*/	  function(err,rows){
	    if(err) throw err;
	    console.log('here are the results filtered by provided layer name and (not yet) artist:\n');
	    console.log(rows);
	    res.json(rows);
	  }
	)
});

//Insert a User
if (insertUser == true) {
	con.query(
	  'CALL insert_user(?, ?, ?, ?, ?)',
	  [input_Username,input_Password, input_FirstName, input_LastName, input_DOB],
	  function(err,rows){
	    if(err) throw err;
	    console.log('User inserted into Db\n');
	    console.log(rows);
	  }
	)
};

//Update a User Username
if (updateUserUsername == true) {
	con.query(
	  'CALL update_user_username(?, ?)',
	  [input_Username,input_UserID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('Username updated in Db\n');
	    console.log(rows);
	  }
	)
};

//Update a User Password
if (updateUserPassword == true) {
	con.query(
	  'CALL update_user_password(?, ?)',
	  [input_Password,input_UserID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('User Password updated in Db\n');
	    console.log(rows);
	  }
	)
};

//Update a User First Name
if (updateUserFirstName == true) {
	con.query(
	  'CALL update_user_first_name(?, ?)',
	  [input_FirstName,input_UserID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('User First Name updated in Db\n');
	    console.log(rows);
	  }
	)
};

//Update a User Last Name
if (updateUserLastName == true) {
	con.query(
	  'CALL update_user_last_name(?, ?)',
	  [input_LastName,input_UserID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('User Last Name updated in Db\n');
	    console.log(rows);
	  }
	)
};

//Update a User DOB
if (updateUserDOB == true) {
	con.query(
	  'CALL update_user_dob(?, ?)',
	  [input_DOB,input_UserID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('User DOB updated in Db\n');
	    console.log(rows);
	  }
	)
};

//Delete a User
if (deleteUser == true) {
	con.query(
	  'CALL delete_user(?)',
	  [input_UserID],
	  function(err,rows){
	    if(err) throw err;
	    console.log('User deleted in Db\n');
	    console.log(rows);
	  }
	)
};

app.listen(3000);
console.log("Server running on port 3000");