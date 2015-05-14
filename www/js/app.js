angular.module('starter', ['ionic', 'starter.controllers', 'starter.services', 'Parse']).run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      StatusBar.styleLightContent();
    }
  });
}).config(function($stateProvider, $urlRouterProvider) {
  $stateProvider.state('tab', {
    url: '/',
    templateUrl: 'templates/start.html',
    controller: 'StartCtrl'
  }).state('login', {
    url: '/login',
    templateUrl: 'templates/login.html',
    controller: 'LoginCtrl'
  });
  $urlRouterProvider.otherwise('/');
});

angular.module('starter.controllers', []).controller('StartCtrl', function($scope, $ionicPlatform) {
  var getNearest;
  getNearest = function(beaconInfo) {
    beaconInfo.beacons.sort(function(beacon1, beacon2) {
      return beacon1.distance > beacon2.distance;
    });
    $scope.beacon = beaconInfo.beacons[0];
    estimote.beacons.stopRangingBeaconsInRegion({}, angular.noop, angular.noop);
  };
  $scope.refresh = function() {
    return $ionicPlatform.ready(function() {
      return estimote.beacons.startRangingBeaconsInRegion({}, getNearest, function(err) {
        console.log(err);
      });
    });
  };
  $scope.refresh();
}).controller('LoginCtrl', function($scope) {
  $scope.login = function(user) {
    $rootscope.user = user;
  };
});

angular.module('starter.services', []);
