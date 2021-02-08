vlocity.cardframework.registerModule.controller('OSHapp', ['$scope', function($scope) {
    $scope.isValidRecord = function (record) {
        // substracting two items to account for the hash key
        return (
            angular.isObject(record) &&
            Object.keys(record).length - 1 >= $scope.bpTree.response.Columns.length
        );
    }

    $scope.getLabelWidth = function (label) {
        if (typeof label === 'string' && label.length > 0) {
            return label.length * 9 + 'px'
        } else { 
            return 0;
        }
    }

    // watch for changes in the record list
    $scope.$watch('bpTree.response.Data.ExpenseSharingRequests', function (newValue, oldValue) {
        console.log("WATCH LIST");
        if (oldValue !== newValue) {
            console.log('Expense Sharing Requests have changed');
        }
    });
}]);