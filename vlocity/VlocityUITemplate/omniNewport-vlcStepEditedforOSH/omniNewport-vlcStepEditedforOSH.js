vlocity.cardframework.registerModule.controller('quoteController', ['$scope', function($scope) {


//Current URL header
var url = 'https://'+  window.location.hostname +'/';


  $scope.currentLocation = function (){
      if (url != null) {
        $scope.bpTree.response.currentUrl = url;
      } else {
          $scope.bpTree.response.currentUrl = 'null';
      }
     
  }


}]);