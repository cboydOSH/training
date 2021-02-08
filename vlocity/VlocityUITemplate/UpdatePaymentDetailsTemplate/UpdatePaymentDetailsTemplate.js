vlocity.cardframework.registerModule.controller('paymentDetailsTemplate', ['$scope', '$sce', function($scope, $sce) {
    // console.log($scope.bpTree.response.UpdatePaymentInformationStep.PaymentFormURL);
    //  $scope.paymentDetailsUrl = $sce.trustAsResourceUrl($scope.bpTree.response.UpdatePaymentInformationStep.PaymentFormURL);
    //  console.log($scope.paymentDetailsUrl);

    function checkIFrameURL() {
        console.log('checkIFrameURL');
        if($scope.bpTree.response.UpdatePaymentInformationStep == undefined) {
            window.setTimeout(checkIFrameURL, 50); 
        } else {
            $scope.paymentDetailsUrl = $sce.trustAsResourceUrl($scope.bpTree.response.UpdatePaymentInformationStep.PaymentFormURL);
            console.log($scope.paymentDetailsUrl);
            $scope.$apply();
        }
    }
    checkIFrameURL();
}]);