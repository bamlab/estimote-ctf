angular.module('starter')
  .factory 'Player', (Parse) ->
    class Player extends Parse.Model
      @configure 'Player', 'username', 'team'

