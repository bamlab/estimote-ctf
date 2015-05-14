angular.module('starter.controllers', [])

.controller('StartCtrl', ($scope, $ionicPlatform, $timeout) ->
  beaconsFound = {};

  registerBeacon = (beaconInfo) ->
    angular.forEach(beaconInfo.beacons, (beacon) ->
      if !beaconsFound[beacon.major + beacon.minor]
        beaconsFound[beacon.major + beacon.minor] = beacon
    )

  $scope.refresh = () ->
    $scope.loading = true;

    $ionicPlatform.ready ->
      estimote.beacons.startRangingBeaconsInRegion(
        {},
        registerBeacon,
        (err) ->
          console.log err
          return
      )

      $timeout(() ->
        estimote.beacons.stopRangingBeaconsInRegion(
          {},
          angular.noop,
          angular.noop
        )

        tmp = []
        angular.forEach(beaconsFound, (beacon) ->
          tmp.push beacon
        )

        tmp.sort (beacon1, beacon2) ->
          return beacon1.distance > beacon2.distance

        $scope.beacon = tmp[0]
        $scope.loading = false;

        return

      , 5000);

  $scope.refresh()

  return
)

.controller 'LoginCtrl', ($scope, Player, $rootScope) ->
  _savePlayer = (playerForm) ->
    playerParse = new Player(
      username: playerForm.username
      team: playerForm.team
    )
    playerParse.save().then(
      (_player) ->
        $rootScope.player = _player
        $scope.message = "Login successful"
      (err) ->
        console.log err
        $scope.message = "Login unsuccessful"
    )

  $scope.login = (playerForm) ->
    if !playerForm or !playerForm.username or !playerForm.team
      $scope.message = 'missing fields'
      return

    query = Player.query(
      where:
        username: playerForm.username
        team: playerForm.team
    )
    .then(
      (results) ->
        if results.length > 0
          $scope.message = "Login already used"
        else
          _savePlayer playerForm
      (err) ->
        $scope.message = "unavailable server"
    )
    return

  return
