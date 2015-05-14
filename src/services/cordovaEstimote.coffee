angular.module('starter.services', [])
.factory '$cordovaEstimote', () ->

  startRangingBeaconsInRegion: (region, successCallback, errorCallback) ->

    if window.estimote
      return window.estimote.beacons.startRangingBeaconsInRegion(region, successCallback, errorCallback)

    # return mock object for easier developement
    successCallback({beacons:[{
      major:48451,
      minor:2727,
      rssi:-68,
      measuredPower:-74,
      proximityUUID:'b9407f30-f5f8-466e-aff9-25556b57fe6d',
      proximity:1,
      distance:0.41856988869951295,
      name:'estimote',
      macAddress:'F2:30:0A:A7:BD:43'
    }]});

    return

  stopRangingBeaconsInRegion: (region, successCallback, errorCallback) ->
    if window.estimote
      return window.estimote.beacons.stopRangingBeaconsInRegion(region, successCallback, errorCallback)

    successCallback()

    return


