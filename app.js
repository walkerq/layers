var myApp = angular.module('myApp',[]);

myApp.controller('AppCtrl', ['$scope', '$http', function($scope, $http) {

/*  $http.get('/layerlist').then(function(response) {
  	console.log("controller got the data requested");
  	//$scope.layers = response;
  })
*/

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
    
  }

  //TODO: not sure what download should actually do. This won't be implemented for a while because it is not
  //currently implemented in the back-end
  $scope.download = function () {
    console.log("hi from download");
  }

}]);