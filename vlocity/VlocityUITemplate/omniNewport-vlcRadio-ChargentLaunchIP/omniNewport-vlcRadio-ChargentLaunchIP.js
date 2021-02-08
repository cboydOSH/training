vlocity.cardframework.registerModule.controller('radioButtonController', ['$scope', function($scope) {
/*
//Integration Procedure Instant Payment
  $scope.generateChargentOrder = function(child){
    $scope.loading = true;
    var request = $scope.bpTree.response;
    var response;
    request.packetNumber = $scope.bpTree.response.Search.questionsBlock.packetNumber;
    $scope.bpService.GenericInvoke('%vlocity_namespace%.IntegrationProcedureService', 'chargentGenerate/orderandPaymentRequest', JSON.stringify(request),'{}').then(
        function(result){
          response = JSON.parse(result).IPResult;
          if(response.DREX_INDIV_enrollgetPacketNumber.length != 0 && response.DREX_INDIV_enrollgetPacketNumber.infoPacket.packetFound == true){
            $scope.mapIPResultToOSData(response);
            sleep(500);
            //$scope.nextRepeater(child.nextIndex, child.indexInParent); 
          }else{
            alert("Ssorry We can't generate your 'Payment Request', 404 Data Not Found");
          }
      $scope.loading = false;
      }
    );
  }
*/

}]);