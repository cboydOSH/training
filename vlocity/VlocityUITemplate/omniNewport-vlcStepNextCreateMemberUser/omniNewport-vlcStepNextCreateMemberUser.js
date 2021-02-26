vlocity.cardframework.registerModule.controller('stateController', ['$scope', function($scope) {
var url = 'https://'+  window.location.hostname +'/';

  $scope.currentLocation = function (){
    if(url != null){
      $scope.bpTree.response.currentUrl = url;
    }else{
      $scope.bpTree.response.currentUrl = 'null';
    }
  }
}]);