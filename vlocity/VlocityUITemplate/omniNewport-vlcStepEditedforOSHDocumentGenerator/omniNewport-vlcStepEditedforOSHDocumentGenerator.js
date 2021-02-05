vlocity.cardframework.registerModule.controller('docusignController', ['$scope', function($scope) {


//Current URL header
var url = 'https://'+  window.location.hostname +'/';

$scope.currentLocation = function (){
                 if(url != null){
                         $scope.bpTree.response.currentUrl = url;
                  }else{
                    $scope.bpTree.response.currentUrl = 'null';
                  }
          }

          angular.element(document).ready(function () {
             console.log('page loading completed');
             $scope.childNextIndex = $scope.child.nextIndex;
             console.log('$scope.childNextIndex',$scope.childNextIndex);
             $scope.childIndexInParent = $scope.child.indexInParent;
             console.log('$scope.childIndexInParent',$scope.childIndexInParent);
          });

  $scope.nextRepeater2 = function(){
    console.log('$scope.child.nextIndex',$scope.child.nextIndex);
    console.log('$scope.child.indexInParent',$scope.child.indexInParent);
    $scope.nextRepeater($scope.child.nextIndex, $scope.child.indexInParent);
  }


/*$scope.loadingScreen = function(){
  var checkisPDFAttachDone = $scope.bpTree.response.isPDFAttachDone;
  var waitingScreen = $scope.bpTree.response.waitingScreen;
  if(checkisPDFAttachDone != true && waitingScreen == true ){
  console.info('We are in');
  $scope.loading = true;
  setTimeout(function(){ $scope.loading = false }, 3000);
  }
  console.info('Out here');
}*/

}]);