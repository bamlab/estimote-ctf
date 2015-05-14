angular.module('starter.controllers', [])

  .controller('StartCtrl', function($ionicPlatform) {
    $ionicPlatform.ready(function() {
      estimote.beacons.startEstimoteBeaconsDiscoveryForRegion(
        {}, // Empty region matches all beacons.
        function (beaconInfo) {
          angular.forEach(beaconInfo.beacons, function (beacon) {
            console.log(beacon);
          })
        },
        function (err) {
          console.log(err);
        });
    });
  });