vlocity.cardframework.registerModule.controller('oshReviewHipaa', ['$scope', function($scope) {

    

    $scope.AddremoveMember = function (member){
        var confirmed = confirm('Are you sure you want authorize/remove this person?'), interval = setInterval(function() {
            if(confirmed === true || confirmed.$$state.status) {
                clearInterval(interval);
                if(confirmed === true || confirmed.$$state.value) {
                    member.isHipaaAuthorized = !member.isHipaaAuthorized;
                }
            }
        }, 100);
    }

    $scope.AddremoveServicingAgent = function (servicingAgent,addRemove,authorized){
        var confirmed = confirm('Are you sure you want '+addRemove+' this person?'), interval = setInterval(function() {
            if(confirmed === true || confirmed.$$state.status) {
                clearInterval(interval);
                if(confirmed === true || confirmed.$$state.value) {
                    servicingAgent.isHipaaAuthorized = authorized;
                }
            }
        }, 100);
    }

    // $scope.$watchCollection( 'bpTree.response.EditFamilyMember', function(currentValue, oldValue) {
    //             console.log('Current value:', currentValue, 'Old value:', oldValue);
    //             $scope.bpTree.response.EditFamilyMember = $scope.bpTree.response.EditFamilyMember.filter((elem, index, self) => self.findIndex(
    //                 (t) => {return (t.fname === elem.fname && t.lname === elem.elename)}) === index)
    //     }
    //  );

    $scope.phoneMask= "(999) 999-9999";
    $scope.removeMask = function () {
        if ($scope.rep.phone.length === 10) {
            $scope.phoneMask= "(999) 999-9999";
        }
    };

}]);