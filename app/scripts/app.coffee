'use strict';
app = angular.module 'podiumMenu', []

app.config ($httpProvider) ->
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

app.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when null,
    templateUrl: 'navigation-template.html',
    controller: 'MainCtrl'

app.filter 'nobreak', ->
  (text) ->
    text.replace('<br>', ' ')

app.directive 'stickRight', ->
  return (scope, elem, attr) ->
    scrollRight = ->
      children = elem.children().children()
      children[children.length-1]?.scrollIntoView()
      # originalValue = elem.css('scrollLeft')
      # console.log(originalValue);
      # elem.css('scrollLeft', originalValue?0 + 30)
      # console.log(elem.css('scrollLeft'));
      # setTimeout(scrollRight, 50) if elem.css('scrollLeft') != originalValue

    scope.$watch attr.stickRight, scrollRight, true

app.factory 'MenuData', ($http) ->
  MenuData = (data) ->
    angular.extend this, data

  MenuData.get = (url) ->
    $http.get(url).then (response) ->
      new MenuData response.data

  return MenuData

app.controller 'MainCtrl', ($scope, $location, MenuData) ->
  #?menujson=http://gnfwebtst02/PodiumSiteTest/Resources/toshtest/MenuJson/5d564fb6-d574-4977-b26e-a1a100a48714
  menujson = $location.search().menujson
  alert "No menujson" if not menujson
  $scope.levels = [MenuData.get(menujson)]
  $scope.selectLink = (level, index, link) ->
    level.selectedLink = link
    $scope.levels.splice index + 1
    $scope.contentUrl = 'http://gnfwebtst02' + link.uri if link.isContent
    $scope.levels.push MenuData.get(link.menudata.uri) if not link.isContent

