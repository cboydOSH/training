vlocity.cardframework.registerModule.controller('insCommunityHomeCtrl', ['$scope', '$q', function($scope, $q) { 
    /*$scope.openQuote = function(quoteType){
        if(quoteType){
            top.location.href = quoteType;
        }
    }*/
    //Current URL header
    var url = 'https://'+  window.location.hostname +'/';
    $scope.currentLocation = function (){
                 if(url != null){
                         $scope.bpTree.response.currentUrl = url;
                  }else{
                    $scope.bpTree.response.currentUrl = 'null';
                  }
    }


    var test = "testurl";
    $scope.testfunction = function(){
    $scope.bpTree.response.testpush = test;
    }

}]);