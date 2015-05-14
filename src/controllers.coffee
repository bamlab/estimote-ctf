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
).controller 'LoginCtrl', ($scope) ->

  $scope.login = (user) ->
    $rootscope.user = user
    return

  return
