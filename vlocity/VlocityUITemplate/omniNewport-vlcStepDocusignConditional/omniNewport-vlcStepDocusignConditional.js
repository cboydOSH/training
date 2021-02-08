vlocity.cardframework.registerModule.controller('docusignConditionalController', ['$scope', function ($scope) {

  //Current URL header
  var url = 'https://' + window.location.hostname + '/';

  $scope.currentLocation = function () {
    if (url != null) {
      $scope.bpTree.response.currentUrl = url;
    } else {
      $scope.bpTree.response.currentUrl = 'null';
    }
  }

  //Conditional for next step call Dataraptor
  var className = '%vlocity_namespace%.DefaultDROmniScriptIntegration'; 
  var classMethod = 'invokeOutboundDR';
    $scope.nextStepCheckDocusingStatus = function(child){
      $scope.loading = true;
      var ContractId = $scope.bpTree.response.ContractServiceRemoteAction.contractId;
      var inputMap = {
        DRParams:{
          ContractId : ContractId
        },
        Bundle:"DRget_osh_individualDocusignStatus"
      };
      $scope.searchResult = [];
      console.log('input map parameters',inputMap);
      setTimeout(function(){
        $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(inputMap),'{}').then(function(result){
          var resultParsed = JSON.parse(result);
          var found = false;
          console.log('result Parsed', resultParsed);
          if(resultParsed.OBDRresp.contractStatus == "Signed"){
            console.log('Inside of the if',resultParsed.OBDRresp.contractStatus);
            $scope.nextRepeater(child.nextIndex, child.indexInParent);
          }else{
            alert("We cannot verify your payment. Please try again on your payment screen.");
          }
          $scope.loading = false;
          console.log('Resut final2',$scope.searchResult);
        });
      },20000);
    };
}]);