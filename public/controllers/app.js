var myApp = angular.module('myApp', [
  'ngRoute',
  'myAppControllers'
]);

myApp.config(['$routeProvider',
  function($routeProvider) {
        $routeProvider.
      when('/layers/', {
        templateUrl: 'layerlist_view.html',
        controller: 'AppCtrl'
      }).
      when('/layers/:LayerID', {
        templateUrl: 'layer_view.html',
        controller: 'LayerDetailCtrl'
      }).
      when('/artists/:Username', {
        templateUrl: 'user_view.html',
        controller: 'UserDetailCtrl'
      }).
      when('/signup/', {
        templateUrl: 'signup.html',
        controller: 'SignUpCtrl'
      }).
      otherwise({
        redirectTo: '/layers/'
      });
}]);