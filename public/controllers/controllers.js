var myAppControllers = angular.module('myAppControllers', ['angularFileUpload']);

myAppControllers.controller('AppCtrl', ['$scope', '$http', function($scope, $http, FileUploader) {
    $scope.layer = ""
/*    console.log($scope.layer + "layer");
    $scope.uploader = new FileUploader();
*/

  var refresh = function() {
    $http.get('/layers').then(function(response) {
      $scope.layers = response;
      $scope.layer = "";
    });
  }

  refresh();

  $scope.addLayer = function() {
    console.log($scope.layer);
    $http.post('/addLayer', $scope.layer).then(function(res) {
      console.log("$scope.layer:")
      console.log($scope.layer);
      $scope.layers = res;
    });
    refresh();
    
  }

  $scope.download = function () {
    alert("Hey - Download will not be implemented until we actually host files!");
  }

  $scope.editLayer = function (id) {
    console.log(id);
    $http.get('/editLayer/' + id).then(function(res) {
      console.log($scope.layer);
      $scope.layer = res;
      console.log($scope.layer);
    });
  }

  $scope.updateLayer = function() {
    $http.put('/updateLayer/' + $scope.layer.LayerID, $scope.layer)
    refresh();
  };
}]);

myAppControllers.controller('LayerDetailCtrl', ['$scope', '$routeParams', '$http',
  function($scope, $routeParams, $http) {
    $scope.thisLayer = ""

  console.log("layerid = ", $routeParams.LayerID)

  var refresh = function() {
    $http.get('/layers/' + $routeParams.LayerID).then(function(res) {
      console.log("data: ");
      console.log(res);
      $scope.thisLayer = res;
    });

  }

  refresh();

  $scope.deleteHashtag = function (HashtagLayerID) {
      console.log(HashtagLayerID);
      $scope.HashtagLayerID = HashtagLayerID
      $http.post('/deleteHashtag/' + $scope.HashtagLayerID);
      refresh();
  };

  $scope.addHashtag = function (layerID, hashtag) {
      $scope.layerID = layerID;
      $scope.hashtag = hashtag;
      var inData = {'hashtag': $scope.hashtag, 'layerID': $scope.layerID};
      console.log("in add hashtag from controller")
      $http.post('/addHashtag', inData)
      .then(refresh());
  };

  $scope.addLinkedLayer = function () {
      console.log($scope.sublayer_input)
      var inData = {'BaseLayerID': $routeParams.LayerID, 'LinkedLayerID': $scope.sublayer_input};
      $http.post('/addLinkedLayer', inData)
      .then(refresh());
  };
}]);

myAppControllers.controller('UserDetailCtrl', ['$scope', '$routeParams', '$http',
  function($scope, $routeParams, $http) {

    $scope.thisUser = "";

    var refresh = function() {
    $http.get('/artists/' + $routeParams.Username).then(function(res) {
      console.log("data: ");
      console.log(res);
      $scope.thisUser = res;
    });
  }

  refresh();

}]);

myAppControllers.controller('SignUpCtrl', ['$scope', '$http', 
  function($scope, $http) {

    $scope.signUp = function() {
      console.log($scope.signUpUser);
      $http.post('/signUpUser', $scope.signUpUser);
    }   
}]);