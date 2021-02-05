vlocity.cardframework.registerModule.controller('myappHomeProductController', ['$scope', function($scope) {
     $scope.$watch("bpTree.response.letsGetStartedAnswers.BlkNoExistingInfoPacket.SSNITIN", function (value1) {
            console.log("watcher executed letsGetStartedAnswers", value1);
             $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.SSNITIN = $scope.bpTree.response.letsGetStartedAnswers.BlkNoExistingInfoPacket.SSNITIN;
        }, true);

}]);