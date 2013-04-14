'use strict';
var myApp = angular.module('angulartestApp', []);

myApp.config(['$httpProvider', function($httpProvider) {
  delete $httpProvider.defaults.headers.common['X-Requested-With'];
}]);

myApp.factory('MenuData', function($http) {
  var MenuData = function(data) {
    angular.extend(this, data);
    console.log(this);
  };

  MenuData.get = function(url) {
    return $http.get(url).then(function(response) {
      return new MenuData(response.data);
    });
  };

  return MenuData;
});


myApp.controller('MainCtrl', function($scope, MenuData) {
  $scope.data = {
    root: MenuData.get('http://podium.gyldendal.no/Resources/salaby/MenuJson/6cdf5969-cd8e-4c15-9b03-a00b00f3b1dd'),
    firstLevel: null,
    contentUrl: null
  };
  $scope.selectFirstLevel = function(link) {
    $scope.data.rootSelection = link;
    if (!link.isContent) {
      $scope.data.firstLevel = MenuData.get(link.menudata.uri);
    } else {
      $scope.data.contentUrl = 'http://podium.gyldendal.no/' + link.uri;
    }
  };

  $scope.selectSecondLevel = function(link) {
    $scope.data.firstLevelSelection = link;
    if (link.isContent) {
      $scope.data.contentUrl = 'http://podium.gyldendal.no/' + link.uri;
    }
  };
  // $scope.selectItem = function(item) {
  //   Data.selectedItem = item;
  // };
});
