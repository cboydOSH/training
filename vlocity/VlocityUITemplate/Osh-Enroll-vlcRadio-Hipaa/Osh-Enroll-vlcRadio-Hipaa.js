vlocity.cardframework.registerModule.controller('radioHipaa', ['$scope', function($scope) {


    $scope.$watch("bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers", function (value1) {
            $scope.updateRadio();
        }, true);


     $scope.updateRadio = function(){
         //This will disable the Button by default.

         if ($scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers >0){
             console.log('entro aca');
               $scope.bpTree.response.HIPAAAuthorization.isDisabled = $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers > 0;
         }
     
     }



}]);