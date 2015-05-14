angular.module('starter.controllers', [])

.controller('StartCtrl', ($scope, $ionicPlatform, $timeout, $cordovaEstimote, Beacon) ->
  $scope.beaconsFound = {};

  registerBeacon = (beaconInfo) ->
    console.log(beaconInfo.beacons.length)

    angular.forEach(beaconInfo.beacons, (beacon) ->
      $scope.beaconsFound[('' + beacon.major + beacon.minor)] = beacon
    )

    tmp = []
    angular.forEach($scope.beaconsFound, (beacon) ->
      tmp.push beacon
    )

    tmp.sort (beacon1, beacon2) ->
      return beacon1.distance > beacon2.distance

    $timeout -> $scope.beacon = tmp[0]

  $scope.refresh = () ->
    $scope.stopped = false;

    $scope.beaconsFound = {};

    $ionicPlatform.ready ->
      $cordovaEstimote.startRangingBeaconsInRegion(
        {},
        registerBeacon,
        (err) ->
          console.log err
          return
      )

    $scope.$on('$destroy', () ->
      $cordovaEstimote.stopRangingBeaconsInRegion(
        {},
        angular.noop,
        angular.noop
      )
    )

  $scope.stopLooking = () ->
    $scope.stopped = true;

    $cordovaEstimote.stopRangingBeaconsInRegion(
      {},
      angular.noop,
      angular.noop
    )

  $scope.registerBase = (team) ->
    updateOrCreateBeacon(team, 'base')

    return

  $scope.registerDefender = (team) ->
    updateOrCreateBeacon(team, 'defender')

    return

  updateOrCreateBeacon = (team, role) ->
    Beacon.query(
      where:
        majorMinor: ('' + $scope.beacon.major + $scope.beacon.minor)
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
            majorMinor: ('' + $scope.beacon.major + $scope.beacon.minor)
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

.controller 'GameCtrl', ($scope, $ionicPlatform, $timeout, $cordovaEstimote, $rootScope, Beacon) ->
  beaconsFound = {}
  beaconRedBase = null
  beaconBlueBase = null
  $scope.hasFlag = false
  $scope.isRedTeam = $rootScope.player.team == "red"

  getBeacons = () ->
    Beacon.query().then (beaconsResults) ->
      for beacon in beaconsResults
        if beacon.role == "base"
          if beacon.team == "blue"
            beaconBlueBase = beacon
          else
            beaconRedBase = beacon

  checkBeaconForFlag = (beaconInfo) ->
    angular.forEach(beaconInfo.beacons, (beacon) ->
      if beacon.distance < 0.3
        if $scope.isRedTeam
          if beaconBlueBase and beacon.major.toString() + beacon.minor.toString() == beaconBlueBase.majorMinor
            $timeout () -> $scope.hasFlag = true
        else
          if beaconRedBase and beacon.major.toString() + beacon.minor.toString() == beaconRedBase.majorMinor
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

  getBeacons()

