vlocity.cardframework.registerModule.controller('stateController', ['$scope', '$timeout', function($scope, $timeout) {
var url = 'https://'+  window.location.hostname +'/';

  $scope.currentLocation = function (){
    if(url != null){
      $scope.bpTree.response.currentUrl = url;
    }else{
      $scope.bpTree.response.currentUrl = 'null';
    }
  }

  $('.nds-input').attr('autocomplete', 'new-password');
    angular.element(document).ready(function () {
      //console.log('executed 0');
      $timeout(function() {
        //console.log('executed 1');
        $scope.init();
        //console.log('executed 2');
      }, 2000);
    });
  
  $scope.init = function(){
     //console.log('from init executed 5');
      $('.nds-input').attr('autocomplete', 'new-password');
  }

}]);