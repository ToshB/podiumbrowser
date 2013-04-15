'use strict';
app = angular.module 'podiumMenu', []

app.config ($httpProvider) ->
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

app.filter 'nobreak', ->
  (text) ->
    text.replace('<br>', ' ')

app.directive 'stickRight', ->
  return (scope, elem, attr) ->
    scrollRight = ->
      children = elem.children().children()
      children[children.length-1].scrollIntoView()
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

app.controller 'MainCtrl', ($scope, MenuData) ->
  $scope.levels = [MenuData.get('http://podium.gyldendal.no/Resources/salaby/MenuJson/6cdf5969-cd8e-4c15-9b03-a00b00f3b1dd')]
  $scope.selectLink = (level, index, link) ->
    level.selectedLink = link
    $scope.levels.splice index + 1
    $scope.contentUrl = 'http://podium.gyldendal.no/' + link.uri if link.isContent
    $scope.levels.push MenuData.get(link.menudata.uri) if not link.isContent

