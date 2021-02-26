vlocity.cardframework.registerModule.controller('hipaaStepController', ['$scope', function($scope) {

$scope.factorSubType = function (child) {
  if($scope.bpTree.response.HIPAAAuthorization!= undefined && $scope.bpTree.response.HIPAAAuthorization.SubTypeForm != undefined){

    if ($scope.bpTree.response.HIPAAAuthorization.SubTypeForm != null) {
          var ListSubType = $scope.bpTree.response.HIPAAAuthorization.SubTypeForm;
          var subtypesText = "";
          Array.prototype.forEach.call(ListSubType, subTypes=> {
            if (subtypesText != "" && subTypes != "Other") {
              subtypesText = subtypesText + ", " + subTypes;
            }
            else if(subTypes != "Other") {
              subtypesText = subTypes;   
            }
          });
        $scope.bpTree.response.HIPAAAuthorization.AuthDetailsSubType = subtypesText;
    }
    $scope.nextRepeater(child.nextIndex, child.indexInParent);
  }
}
  var url = 'https://'+  window.location.hostname +'/';
  $scope.currentLocation = function (){
    if(url != null){
      $scope.bpTree.response.currentUrl = url;
    }else{
      $scope.bpTree.response.currentUrl = 'null';
    }
  }
}]);