'use strict';
appDev = angular.module 'podiumMenuDev', ['podiumMenu', 'ngMockE2E']
appDev.run ($httpBackend) ->
  $httpBackend.whenGET(/.*/).respond
    links: for i in [1..10]
      link =
        written: 'link ' + i
        isContent: i % 3 == 0
        contentUrl: '/'
        menudata:
          uri: '/something/MenuJson/something'
