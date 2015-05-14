angular.module('starter', [
  'ionic'
  'starter.controllers'
  'starter.services'
  'Parse'
])

.run(($ionicPlatform) ->
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
)

.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'home',
      url: '/'
      templateUrl: 'templates/main.html'
      controller: 'MainCtrl'

    .state 'gameStart',
      url: '/start'
      templateUrl: 'templates/start.html'
      controller: 'StartCtrl'

    .state 'login',
      url: '/login'
      templateUrl: 'templates/login.html'
      controller: 'LoginCtrl'

  ###
  $stateProvider.state('tab',
    url: '/'
    templateUrl: 'templates/start.html'
    controller: 'StartCtrl')
  .state 'login',
    url: '/login'
    templateUrl: 'templates/login.html'
    controller: 'LoginCtrl'
  .state 'game',
    url: '/game'
    templateUrl: 'templates/game.html'
    controller: 'GameCtrl'
  ###
  $urlRouterProvider.otherwise '/'

  return

.config ['ParseProvider', (ParseProvider) ->
  ParseProvider.initialize '18UPD5RuXebgnhvc0yVK3pIkslTj7LbqATAz9Daa', '0EQ63ItiOArSc9WSFJlv1orJBU4x2e6soY8ssnjv'
]
