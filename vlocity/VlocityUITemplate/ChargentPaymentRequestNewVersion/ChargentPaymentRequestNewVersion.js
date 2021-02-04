vlocity.cardframework.registerModule.controller('customChargentController', ['$scope', '$sce', function($scope, $sce) {
    //$scope.chargentPaymentRequestLink = $sce.trustAsResourceUrl($scope.bpTree.response.chargentInfo.paylink);
    $scope.cssClass='';
    if($scope.bpTree.response.thisIsCommunity){
        $scope.cssClass='community';
        $scope.chargentPaymentRequestLink = $sce.trustAsResourceUrl($scope.bpTree.response.chargentStep.ChargentPayLinkFormula);
        // var frame = document.getElementById("chargentIframe");
        // header = frame.contentDocument.querySelector("header");
        // header.remove();
    }else{
        $scope.chargentPaymentRequestLink = $sce.trustAsResourceUrl($scope.bpTree.response.paymentLink);
    }
    //Some code was here
    
}]);