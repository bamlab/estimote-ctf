angular.module('starter.services', [])
.factory 'Game', (Parse) ->
  class Game extends Parse.Model
    @configure 'Game'

