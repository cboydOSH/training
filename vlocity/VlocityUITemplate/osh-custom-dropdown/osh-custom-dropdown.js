vlocity.cardframework.registerModule.controller('oshDropdownController', ['$scope', function($scope) {
     /*$scope.$watch("servicingAgentDropdown", function (value) {
            var newValue = {'Id': value.Id,
                        'Monthly_Commission_Fee': value.Monthly_Commission_Fee__c,
                        'Name': value.Name};
            $scope.bpTree.response.ExistingInfoPacket.ServicingAgentDropdown = newValue;
        }, true);*/
    angular.element(document).ready(function(){
        var newValue = {'Id': '',
                        'Monthly_Commission_Fee': '',
                        'Name': ''};
        //$scope.bpTree.response.SelectedServicingAgentDropdown = newValue;
        //$scope.bpTree.response.SelectedServicingAgentDropdown = $scope.bpTree.response.AccountsForOSHEmployees.get(0);
    });

    function checkAccountsForOSHEmployees() {
        //console.log('checkAccountsForOSHEmployees');
        if($scope.bpTree.response.AccountsForOSHEmployees == undefined) {
            window.setTimeout(checkAccountsForOSHEmployees, 50); 
        } else {
            //$scope.bpTree.response.SelectedServicingAgentDropdown = $scope.bpTree.response.AccountsForOSHEmployees[0];
            $scope.bpTree.response.AccountsForOSHEmployees.forEach(selectedServicingAgentOption => {
                if(selectedServicingAgentOption.Name=='OSH Enrollment'){
                    $scope.bpTree.response.SelectedServicingAgentDropdown = selectedServicingAgentOption;
                }
            });
            $scope.$apply();
        }
    }
    checkAccountsForOSHEmployees();

}]);