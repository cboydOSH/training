vlocity.cardframework.registerModule.controller('enrollNextControl', ['$scope', function($scope) {

//Current URL header
var url = 'https://'+  window.location.hostname +'/';
$scope.currentLocation = function (){
                 if(url != null){
                         $scope.bpTree.response.currentUrl = url;
                  }else{
                    $scope.bpTree.response.currentUrl = 'null';
                  }
}

//Call IP and error when no find information on the IP
var count = null;
$scope.bpTree.response.count;

$scope.nextBeforeLoadData = function(child, bptree){
  $scope.integrationProcedure(child, bptree);
}

//Integration Procedure call
$scope.integrationProcedure = function(child, bptree) {
  $scope.loading = true;
  $scope.bpService.GenericInvoke('%vlocity_namespace%.IntegrationProcedureService', 'Indivual/OSH_Search/MemberElegibility', 
                                  JSON.stringify($scope.bpTree.response.search.fields),'{}').then(function(result) {
                                                console.info("stringly",$scope.bpTree.response.search.fields);
                                                $scope.bpTree.response.ipresult = JSON.parse(result).IPResult;
                                                console.info("scopeacaunt",$scope.Account);
                                                 if($scope.bpTree.response.Account != null){
                                                   console.info("Account is diferent from null");
                                                  $scope.nextRepeater(child.nextIndex, child.indexInParent); 
                                                  }else{
                                                  count=true;
    $scope.bpTree.response.count = count;
  }
  $scope.loading = false;

});
}


}]);