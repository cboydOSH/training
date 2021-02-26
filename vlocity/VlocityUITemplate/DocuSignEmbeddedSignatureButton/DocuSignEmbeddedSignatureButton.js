vlocity.cardframework.registerModule.controller('docuSignEmbeddedSignatureButtonController', ['$scope', function($scope) {
   $scope.setEmbededToTrue = function(){
       $scope.bpTree.isEmbeded = true;
   }
   /*
   $scope.hasPDF = false;
   $scope.$watch("bpTree.response.GenerateDocument.FormulaHasPdf", function(newValue,oldValue){
       $scope.hasPDF = newValue;
   });

   $scope.loading = true;
   stop = $timeout(function() {
        $scope.loading = false;
    }, 45000);
    */
}]);