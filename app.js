var myApp = angular.module('myApp',[]);

//TODO: we shouldn't need $http, we should be triggering off of user input (so function calls via directives in the view)
myApp.controller('AppCtrl', ['$scope', '$http', function($scope, $http) {

/*  $http.get('/layerlist').then(function(response) {
  	console.log("controller got the data requested");
    //it is not clear at the moment what the following line actually does.
  	//$scope.layers = response;
  })
*/
  //TODO: search should filter results dynamically

/*  var refresh = function() {
    $http.get('/layerlist').then(function(response) {
      console.log("I got the data in refresh!");
      $scope.layers = response;
      $scope.layer = "";
    });
  }

  refresh();*/

  $scope.search = function() {
    console.log($scope.layer);
    $http.post('/layerlist', $scope.layer).then(function(res) {
      console.log("got the data from POST!");
      $scope.layers = res;
      console.log($scope.layers);
      console.log($scope.layers.data[0]);
      console.log($scope.layers.data[1]);
//      refresh();
    });
    //$scope.layers = data from model
    //call a callback in the model which returns the relevant data.
    //this thing should SELECT * via layer name and artist, or something complicated like that.
    //but for now, it should just SELECT * and inject the mysql query to layers.
    //Once data is flowing we can do complex filters.

    
  }

  //TODO: not sure what download should actually do. This won't be implemented for a while because it is not
  //currently implemented in the back-end
  $scope.download = function () {
    console.log("hi from download");
  }

/*  layer1 = {
  	LayerName: "song1",
  	UserID: "artist1"
  };

  layer2 = {
  	LayerName: "song2",
  	UserID: "artist2"
  };

  layer3 = {
  	LayerName: "song3",
  	UserID: "artist3"
  };

var layers = [layer1, layer2, layer3];
$scope.layers = layers;
*/

}]);