vlocity.cardframework.registerModule.controller('paymentScreenConditonal', ['$scope', function ($scope) {

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
  var paymentRequestId = '';
  var inputMap = {};
    $scope.nextStepCheckPayment = function(child){
      $scope.loading = true;
      var chargentOrder='';
      chargentOrder = $scope.bpTree.response.ChargentOrderId;
      console.log('verify chargent order', chargentOrder);
      inputMap = {
        DRParams:{
          chargentOrderId : chargentOrder
        },
        Bundle:"DRget_osh_individualChargentOrderStatus"
      };
      $scope.searchResult = [];
      console.log('input map parameters',inputMap);
      $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(inputMap),'{}').then(function(result){
        var resultParsed = JSON.parse(result);
        console.log('result Parsed', resultParsed);
        if(resultParsed.OBDRresp.chargentOrderPaymentStatus == "Partial"){
          console.log('Inside of the if',resultParsed.OBDRresp.chargentOrderPaymentStatus);
          $scope.nextRepeater(child.nextIndex, child.indexInParent);
        }else{
          alert("We cannot verify that you paid, please pay");
        }
        $scope.loading = false;
        console.log('Resut final2',$scope.searchResult);
      });
    }

}]);