vlocity.cardframework.registerModule.controller('docuSignControllerTemplate', ['$scope', '$sce', function($scope, $sce) {
    $scope.docusignURL = $sce.trustAsResourceUrl($scope.bpTree.response.DocuSignURL);
    $scope.counter = 0;
    goNextFunction = function(){
        $scope.counter++;
        //return $scope.counter;
        if ($scope.counter == 2) {
            angular.element('#NextButtonCustomHidden').triggerHandler('click');
        }
    }
}]);