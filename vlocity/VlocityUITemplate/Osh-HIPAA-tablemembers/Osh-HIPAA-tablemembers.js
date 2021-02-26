vlocity.cardframework.registerModule.controller('oshHipaa', ['$scope', function($scope) {

    $scope.AddremoveMember = function (member,addRemove){
        var confirmed = confirm('Are you sure you want '+addRemove+' this person?'), interval = setInterval(function() {
            if(confirmed === true || confirmed.$$state.status) {
                clearInterval(interval);
                if(confirmed === true || confirmed.$$state.value) {
                    member.isAuthorized = !(member.isAuthorized); 
                    if (member.isAuthorized == true) {
                        $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers++;
                    }
                    else if ($scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers > 0){
                         $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers--;
                    }
    
                }
                $scope.countEditFamilyMember();
            }
        }, 100);
            
    }

    $scope.AddremoveServicingAgent = function (servicingAgent,addRemove,authorized){
        var confirmed = confirm('Are you sure you want '+addRemove+' this person?'), interval = setInterval(function() {
            if(confirmed === true || confirmed.$$state.status) {
                clearInterval(interval);
                if(confirmed === true || confirmed.$$state.value) {
                    servicingAgent.isHipaaAuthorized = authorized;
                    var producer= $scope.bpTree.response.Agent;
                    producer.hipaaName =  $scope.bpTree.response.Account.Name + " - " + (servicingAgent.FullName);
                    producer.isAuthorized= authorized;
                    if (producer.isAuthorized == true) {
                        $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers++;
                    }
                    else if ($scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers > 0){
                         $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers--;
                    }
                    producer.relationship = 'Producer';
                    $scope.bpTree.response.HipaaList.push(producer);
                }
                $scope.countEditFamilyMember();
            }
        }, 100);
    }

    $scope.$watch("bpTree.response.Welcome['TAAddressGoogle-Block'].address", function (value1) {
            $scope.countEditFamilyMember();
        }, true);
    
    //Get Count Fmaily Members from count EditFamilyMember
    $scope.countEditFamilyMember = function(){

        if( $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers == null ||  $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers== undefined) {
             $scope.bpTree.response.HIPAAAuthorization.NumberOfAuthorizedMembers = 0;
             $scope.bpTree.response.HIPAAAuthorization.isDisabled = true;
        }

        $scope.counterSpouse = 0;
        console.info("counterSpouse:",$scope.counterSpouse);
        $scope.counterChild = 0;
        console.info("counterChild:",$scope.counterChild);
        $scope.counterAdultDependent = 0;
        console.info("counterAdultDependent:",$scope.counterAdultDependent);
        $scope.counterOther = 0;
        console.info("counterOther:",$scope.counterOther);
        if($scope.bpTree.response.HipaaList!=undefined && $scope.bpTree.response.HipaaList!=null){
            var EditFamilyMember = $scope.bpTree.response.HipaaList;
            console.log('aqui', EditFamilyMember);

            Array.prototype.forEach.call(EditFamilyMember, familyMember=> {

                if (familyMember.hipaaName== null || familyMember.hipaaName== undefined){
                    familyMember.hipaaName = $scope.bpTree.response.Account.Name + " - " + familyMember.fullname;
                }

                if(familyMember.relationship == "Spouse" && familyMember.isAuthorized == false){
                    $scope.counterSpouse ++;
                    console.info("Inside Count counterSpouse", $scope.counterSpouse);
                }
                if(familyMember.relationship == "Child" && familyMember.isAuthorized == false && familyMember.age >= 18){
                    $scope.counterChild ++;
                    console.info("Inside Count counterChild", $scope.counterChild);
                }
                if(familyMember.relationship == "Adult Dependent" && familyMember.isAuthorized == false){
                    $scope.counterAdultDependent ++;
                    console.info("Inside Count counterAdultDependent", $scope.counterAdultDependent);
                }
                if(familyMember.relationship == "Other" && familyMember.isAuthorized == false){
                    $scope.counterOther ++;
                    console.info("Inside Count counterOther", $scope.counterOther);
                }
            });
        }
    }

    $scope.phoneMask= "(999) 999-9999";
    $scope.removeMask = function () {
        if ($scope.rep.phone.length === 10) {
            $scope.phoneMask= "(999) 999-9999";
        }
    };

}]);