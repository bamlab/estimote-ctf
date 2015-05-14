angular.module('starter')
.factory 'Game', (Parse) ->
  class Game extends Parse.Model
    @configure 'Game'