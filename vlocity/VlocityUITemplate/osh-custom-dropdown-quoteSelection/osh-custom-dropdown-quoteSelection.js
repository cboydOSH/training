vlocity.cardframework.registerModule.controller('oshDropdownControllerForQuote', ['$scope', function($scope) {
    // $scope.$watch('bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.RadioForLookingThroughName', function (value) {
    //         console.log("watcher executed RadioForLookingThroughName", value);
    //         if(value==true){
    //             $scope.bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtInfoPacketNumber='';
    //             if($scope.bpTree.response.QuoteOptions!='something'){
    //                 $scope.bpTree.response.QuoteOptions=='something';
    //             }
    //         }
    //     }, true);

    $scope.$watch('bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtNameForSearch', function (value) {
        //console.info('Value TxTNameForSearch: ' + value);
        $scope.bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtInfoPacketNumber='';
        $scope.bpTree.response.QuoteOptions=='something';
    }, true);

}]);