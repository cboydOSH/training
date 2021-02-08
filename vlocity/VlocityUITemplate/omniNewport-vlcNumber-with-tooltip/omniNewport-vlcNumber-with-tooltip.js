vlocity.cardframework.registerModule.controller('OnlyPositivePlusTooltipController', ['$scope', function($scope) {
    
    $scope.getMinus = function(control){
        let resStr=String(control.response);
        if(resStr.includes("-")){
            if(control.name==='FullTimeEquivalentEmployees')$scope.bpTree.response.isNotNumberFTEE=true;
            if(control.name==='EmployeesEnroll')$scope.bpTree.response.isNotNumberEE=true;
            if(control.name==='AnnualGroupSize')$scope.bpTree.response.isNotNumberAGS=true;
        }else{
            if(control.name==='FullTimeEquivalentEmployees')$scope.bpTree.response.isNotNumberFTEE=false;
            if(control.name==='EmployeesEnroll')$scope.bpTree.response.isNotNumberEE=false;
            if(control.name==='AnnualGroupSize')$scope.bpTree.response.isNotNumberAGS=false;
        }
    }
}]);