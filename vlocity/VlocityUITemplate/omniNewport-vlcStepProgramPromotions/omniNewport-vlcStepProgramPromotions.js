vlocity.cardframework.registerModule.controller('productSecurity', ['$scope', function($scope) {
    $scope.optionsToDisplay = $scope.bpTree.response.ProductFilter;
    
    angular.element(document).ready(function() {
       $scope.load();
       $scope.$apply();
       console.log('loaded');
    });

    var className = '%vlocity_namespace%.DefaultDROmniScriptIntegration'; 
    var classMethod = 'invokeOutboundDR';
    $scope.updateProductPrivileges = function(){
        $scope.loading = true;
        console.info('updateProductPrivileges');
        var inputMap = {
            DRParams:{
                promotionId : $scope.bpTree.response.ContextId,
                programsMetadata: $scope.optionsToDisplay
            },
            Bundle:"DRUP_CreateUpdateProgramPromotionDiscounts"
        };
        console.log('input map parameters',inputMap);
        $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(inputMap),'{}').then(function(result){
            var resultParsed = JSON.parse(result);
            if(resultParsed.error=="OK"){
                console.log('result Parsed', resultParsed);
                $scope.bpTree.response.PromotionPrograms = angular.copy($scope.optionsToDisplay);
                $scope.reload();
            }
            $scope.loading = false;
        });
    }

    $scope.reload = function(){
         $scope.optionsToDisplay = [];
         $scope.load();
         $scope.bpTree.response.gateStep = false;
    }

    $scope.load = function(){
         if($scope.bpTree.response.PromotionPrograms != "[]"){
            var selectedPrivilegesArray = [];
            $scope.bpTree.response.ProductFilter.forEach( product => {
                var option = {};
                //console.log('Check: ', product);
                $scope.bpTree.response.PromotionPrograms.forEach( selectedPrivilege => {
                    if(product.id == selectedPrivilege.id){ //found
                        option = selectedPrivilege;
                    }
                });
                //console.log('To add option: ', option, Object.keys(option).length === 0 && option.constructor === Object);
                //console.log('To add product: ', product);
                if(Object.keys(option).length === 0 && option.constructor === Object){ //if not found empty
                    option = product;
                    option.available = 'not applicable';
                }
                //console.log('Adding: ', option);
                selectedPrivilegesArray.push(option);
            });
            $scope.optionsToDisplay = angular.copy(selectedPrivilegesArray);
        }else{
            $scope.bpTree.response.ProductFilter.forEach( product => {product.available = 'not applicable';});
            $scope.optionsToDisplay = angular.copy($scope.bpTree.response.ProductFilter);
        }
    }

}]);