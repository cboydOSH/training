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
      console.log('$scope.bpTree.response.bill.formulaCreateOneDollarOrder', $scope.bpTree.response.bill.formulaCreateOneDollarOrder);
      console.log('thisiscommunity', $scope.bpTree.response.thisIsCommunity);
      if($scope.bpTree.response.thisIsCommunity){
         console.log('thisiscommunity', $scope.bpTree.response.thisIsCommunity);
         var chargentOrder='';
          chargentOrder = $scope.bpTree.response.chargentOrderId;
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
            if(resultParsed.OBDRresp.chargentOrderPaymentStatus == "Full"){
              console.log('Inside of the if',resultParsed.OBDRresp.chargentOrderPaymentStatus);
              $scope.nextRepeater(child.nextIndex, child.indexInParent);
            }else{
              alert("Error"+"<br/>"+"We were not able to verify your payment. Please complete your payment to continue");
            }
            $scope.loading = false;
            console.log('Resut final2',$scope.searchResult);
          });

      }else{
        paymentRequestId = $scope.bpTree.response.paymentRequestId;
        inputMap = {
          DRParams:{
            paymentRequestId : paymentRequestId
          },
          Bundle:"DRget_osh_individualPaymentStatus"
        };
        $scope.searchResult = [];
        console.log('input map parameters',inputMap);
        $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(inputMap),'{}').then(function(result){
          var resultParsed = JSON.parse(result);
          var found = false;
          console.log('result Parsed', resultParsed);
          if(resultParsed.OBDRresp.chargentPaymentStatus == "Paid"){
            console.log('Inside of the if',resultParsed.OBDRresp.chargentPaymentStatus);
            $scope.nextRepeater(child.nextIndex, child.indexInParent);
          }else{
            alert("We cannot verify your Document. Please try again on your Sign In Document screen.");
          }
          $scope.loading = false;
          console.log('Resut final2',$scope.searchResult);
        });
      } 
    }

}]);