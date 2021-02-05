vlocity.cardframework.registerModule.controller('docuSignSendSignatureButtonController', ['$scope', function($scope) {
   $scope.setEmbededToFalse = function(){
       $scope.bpTree.response.isEmbeded = false;
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