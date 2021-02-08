vlocity.cardframework.registerModule.controller('customChargentController', ['$scope', '$sce', function($scope, $sce) {
    $scope.chargentPaymentRequestLink = $sce.trustAsResourceUrl($scope.bpTree.response.chargentInfo.paylink);
}]);