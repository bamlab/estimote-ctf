angular.module('starter.services', [])
.factory 'Beacon', (Parse) ->
  class Beacon extends Parse.Model
    @configure 'Beacon', 'role', 'team', 'majorMinor'

