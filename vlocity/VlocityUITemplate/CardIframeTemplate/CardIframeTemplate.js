vlocity.cardframework.registerModule.controller('customCardTemplate', ['$scope', '$sce', function($scope, $sce) {
   // $scope.urlForCard = $sce.trustAsResourceUrl($scope.bpTree.response.ShowMemberCardStep.FormulaIFrameURL);
    // if($scope.bpTree.response.thisIsCommunity){
    //     $scope.chargentPaymentRequestLink = $sce.trustAsResourceUrl($scope.bpTree.response.chargentStep.ChargentPayLinkFormula);
    // }else{
    //     $scope.chargentPaymentRequestLink = $sce.trustAsResourceUrl($scope.bpTree.response.chargentInfo.paylink);
    // }
    //Some code was here

    //Current URL header
    $scope.currentLocation = function (){
        var url = 'https://'+  window.location.hostname +'/';
        var urlToReturn = "";
        if(url != null){
            if(url.includes("oshtraining")){
                urlToReturn = $scope.bpTree.response.iframeHostURLCommunity;
            }else{
                urlToReturn = $scope.bpTree.response.iframeHostURLSalesforce;
            }
            return urlToReturn + $scope.bpTree.response.ShowMemberCardStep.FormulaIFrameURL;
        }
        return "";
    }

    function checkIFrameURL() {
        console.log('checkIFrameURL');
        if($scope.bpTree.response.ShowMemberCardStep == undefined) {
            window.setTimeout(checkIFrameURL, 50); 
        } else {
            $scope.urlForCard = $sce.trustAsResourceUrl($scope.currentLocation());
            console.log($scope.urlForCard);
            $scope.$apply();
        }
    }
    checkIFrameURL();
}]);