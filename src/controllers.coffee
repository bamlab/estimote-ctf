angular.module('starter.controllers', [])

.controller('StartCtrl', ($scope, $ionicPlatform, $timeout, $cordovaEstimote, Beacon) ->
  beaconsFound = {};

  registerBeacon = (beaconInfo) ->
    angular.forEach(beaconInfo.beacons, (beacon) ->
      if !beaconsFound[beacon.major + beacon.minor]
        beaconsFound[beacon.major + beacon.minor] = beacon
    )

  $scope.refresh = () ->
    $scope.loading = true;

    $ionicPlatform.ready ->
      $cordovaEstimote.startRangingBeaconsInRegion(
        {},
        registerBeacon,
        (err) ->
          console.log err
          return
      )

      $timeout(() ->
        $cordovaEstimote.stopRangingBeaconsInRegion(
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

  $scope.registerBase = (teamNb) ->

    return

  $scope.registerDefender = (teamNb) ->
    return

  updateOrCreateBeacon = (team, role) ->
    Beacon.query(
      where:
        majorMinor: $scope.beacon.major + $scope.beacon.minor
    )
    .then(
      (results) ->
        if results.length > 0
          beacon = results[0]

          beacon.team = team
          beacon.role = role
        else
          beacon = new Beacon(
            team: team
            role: role
            majorMinor: $scope.beacon.major + $scope.beacon.minor
          )

        beacon.save().then(
          (_player) ->
            console.log 'ok'
          (err) ->
            console.log err
        )
      (err) ->
        $scope.message = "unavailable server"
    )

  $scope.refresh()

  return
)

.controller 'LoginCtrl', ($scope, Player, $rootScope, $state) ->
  _savePlayer = (playerForm) ->
    playerParse = new Player(
      username: playerForm.username
      team: playerForm.team
    )
    playerParse.save().then(
      (_player) ->
        $rootScope.player = _player
        $scope.message = "Login successful"
        $state.go "play"
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

.controller 'MainCtrl', () -> null

.controller 'GameCtrl', ($scope, $ionicPlatform, $timeout, $cordovaEstimote, $rootScope) ->
  beaconsFound = {}
  $scope.hasFlag = false
  $scope.isRedTeam = $rootScope.player.team == "red"

  checkBeaconForFlag = (beaconInfo) ->
    angular.forEach(beaconInfo.beacons, (beacon) ->
      if beacon.distance < 0.3
        $timeout () -> $scope.hasFlag = true
    )
  $scope.loading = true;

  $ionicPlatform.ready ->
    $cordovaEstimote.startRangingBeaconsInRegion(
      {},
      checkBeaconForFlag,
      (err) ->
        console.log err
        return
    )

