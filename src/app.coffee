angular.module('starter', [
  'ionic'
  'starter.controllers'
  'starter.services'
  'Parse'
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleLightContent()
    return
  return
).config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state('tab',
    url: '/'
    templateUrl: 'templates/start.html'
    controller: 'StartCtrl').state 'login',
    url: '/login'
    templateUrl: 'templates/login.html'
    controller: 'LoginCtrl'
  $urlRouterProvider.otherwise '/'
  return
