angular.module('starter.controllers', [])

.controller('StartCtrl', ($scope, $ionicPlatform) ->
  getNearest = (beaconInfo) ->
    beaconInfo.beacons.sort (beacon1, beacon2) ->
      return beacon1.distance > beacon2.distance

    $scope.beacon = beaconInfo.beacons[0]

    estimote.beacons.stopRangingBeaconsInRegion(
      {},
      angular.noop,
      angular.noop
    )
    return

  $scope.refresh = () ->
    $ionicPlatform.ready ->
      estimote.beacons.startRangingBeaconsInRegion(
        {},
        getNearest,
        (err) ->
          console.log err
          return
      )

  $scope.refresh()

  return
)

.controller 'LoginCtrl', ($scope, Player, $rootScope) ->

  $scope.login = (playerForm) ->
    if !playerForm or !playerForm.username or !playerForm.team
      $scope.message = 'missing fields'
      return
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

    return

  return
