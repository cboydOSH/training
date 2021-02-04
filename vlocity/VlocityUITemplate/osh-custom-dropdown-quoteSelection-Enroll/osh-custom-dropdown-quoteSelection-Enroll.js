vlocity.cardframework.registerModule.controller('oshDropdownControllerForEnroll', ['$scope', function($scope) {
    // $scope.$watch('bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.RadioForLookingThroughName', function (value) {
    //         console.log("watcher executed RadioForLookingThroughName", value);
    //         if(value==true){
    //             $scope.bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtInfoPacketNumber='';
    //             if($scope.bpTree.response.QuoteOptions!='something'){
    //                 $scope.bpTree.response.QuoteOptions=='something';
    //             }
    //         }
    //     }, true);

    $scope.$watch('bpTree.response.Search.questionsBlock.TxtNameForSearch', function (value) {
        console.info('Value TxTNameForSearch: ENROLLLMENT ' + value);
        $scope.bpTree.response.Search.questionsBlock.packetNumber='';
        $scope.bpTree.response.QuoteOptions=='something';
    }, true);

}]);