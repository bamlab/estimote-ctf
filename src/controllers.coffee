angular.module('starter.controllers', []).controller('StartCtrl', ($ionicPlatform) ->
  $ionicPlatform.ready ->
    estimote.beacons.startEstimoteBeaconsDiscoveryForRegion {}, ((beaconInfo) ->
      angular.forEach beaconInfo.beacons, (beacon) ->
        console.log beacon
        return
      return
    ), (err) ->
      console.log err
      return
    return
  return
).controller 'LoginCtrl', ($scope) ->

  $scope.login = (user) ->
    $rootscope.user = user
    return

  return
