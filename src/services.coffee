angular.module('starter.services', [])
  .factory 'Player', (Parse) ->
    class Player extends Parse.Model
      @configure 'Player', 'username', 'team'
