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
}).config([
  'ParseProvider', function(ParseProvider) {
    return ParseProvider.initialize('18UPD5RuXebgnhvc0yVK3pIkslTj7LbqATAz9Daa', '0EQ63ItiOArSc9WSFJlv1orJBU4x2e6soY8ssnjv');
  }
]);

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
}).controller('LoginCtrl', function($scope, Player, $rootScope) {
  var _savePlayer;
  _savePlayer = function(playerForm) {
    var playerParse;
    playerParse = new Player({
      username: playerForm.username,
      team: playerForm.team
    });
    return playerParse.save().then(function(_player) {
      $rootScope.player = _player;
      return $scope.message = "Login successful";
    }, function(err) {
      console.log(err);
      return $scope.message = "Login unsuccessful";
    });
  };
  $scope.login = function(playerForm) {
    var query;
    if (!playerForm || !playerForm.username || !playerForm.team) {
      $scope.message = 'missing fields';
      return;
    }
    query = Player.query({
      where: {
        username: playerForm.username,
        team: playerForm.team
      }
    }).then(function(results) {
      if (results.length > 0) {
        return $scope.message = "Login already used";
      } else {
        return _savePlayer(playerForm);
      }
    }, function(err) {
      return $scope.message = "unavailable server";
    });
  };
});

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

angular.module('starter.services', []).factory('Player', function(Parse) {
  var Player;
  return Player = (function(superClass) {
    extend(Player, superClass);

    function Player() {
      return Player.__super__.constructor.apply(this, arguments);
    }

    Player.configure('Player', 'username', 'team');

    return Player;

  })(Parse.Model);
});
