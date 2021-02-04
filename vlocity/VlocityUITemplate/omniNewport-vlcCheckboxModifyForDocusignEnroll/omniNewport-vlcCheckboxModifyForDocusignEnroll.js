vlocity.cardframework.registerModule.controller('checkBoxDocusignController', ['$scope', '$timeout', function($scope, $timeout) {

/*$scope.$watch("bpTree.response.isPDFAttachDone", function (value1) {
            $scope.loadingScreen();
        }, true);*/
// Loading Screen for Checkbox
//$scope.bpTree.response.countDocuSignPopUp = null;
$scope.loadingScreen = function(){
      $scope.loading = true;
      setTimeout(function(){ 
        console.info("Inside function timeout");
        $scope.loading = false;
        $scope.$apply();
        }, 25000
      );
      //alert('Sucesfull');
    }
  /*function sleep(milliseconds) {
      var start = new Date().getTime();
      for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds){
          break;
        }
      }
    }*/

}]);