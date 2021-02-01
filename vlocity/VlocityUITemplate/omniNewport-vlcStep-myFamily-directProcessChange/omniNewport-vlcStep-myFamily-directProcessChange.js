vlocity.cardframework.registerModule.controller('myFamilyController', ['$scope', function($scope) {
    $scope.nextStep = function(child){
        console.log('working');
        if($scope.bpTree.response.Thisisdirect==true){
            if($scope.bpTree.response.myFamily.hasProductsAvailable==false){
                alert("Unfortunately, none of the programs included in the Information Packet you selected are" +
                        "currently available for Enrollment. Please create a new Information Packet to continue you " +
                        "Enrollment process.");
                return false;
            }else{
                $scope.nextRepeater(child.nextIndex, child.indexInParent);
            }
        }else{
            $scope.nextRepeater(child.nextIndex, child.indexInParent);
        }
    }
}]);