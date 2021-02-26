vlocity.cardframework.registerModule.controller('enrollController2', ['$scope', '$timeout', function($scope, $timeout) {

//Current URL header
var url = 'https://'+  window.location.hostname +'/';
$scope.currentLocation = function(){
                 if(url != "https:///"){
                         $scope.bpTree.response.currentUrl = url;
                         //console.info("currentUrl = " , $scope.bpTree.response.currentUrl);
                  }else{
                    $scope.bpTree.response.currentUrl = 'null';
                    //console.info("currentUrl = " , $scope.bpTree.response.currentUrl);
                  }
                  
          }

    $('.nds-input').attr('autocomplete', 'new-password');
        angular.element(document).ready(function () {
        //console.log('executed 0');
        $timeout(function() {
        //console.log('executed 1');
            $scope.init();
        //console.log('executed 2');
        }, 2000);
    });
  
    $scope.init = function(){
     //console.log('from init executed 5');
        $('.nds-input').attr('autocomplete', 'new-password');
    }


//Get Radiofamily from count family Members
$scope.getradioFamilyOption = function() {
    var counterPrimary = 0;
    var counterSpouse = 0;
    var counterChild = 0;
    var counterAdultDependent = 0;
    Array.prototype.forEach.call($scope.bpTree.response.EditFamilyMember,familyMember=> {
    //$scope.bpTree.response.EditFamilyMember.forEach(function(familyMember){
        if (familyMember.relationship == "Primary"){
            counterPrimary ++;
        }
        if (familyMember.relationship == "Spouse"){
            counterSpouse ++;
        }
        if (familyMember.relationship == "Child"){
            counterChild ++;
        }
        if (familyMember.relationship == "Adult Dependent"){
            counterAdultDependent ++;
        }
    });

    var  isMySelf = counterPrimary == 1 && counterSpouse == 0 && counterChild == 0 && counterAdultDependent == 0;
    var  isMyselfMyspouse = counterPrimary == 1 && counterSpouse == 1 && counterChild == 0 && counterAdultDependent == 0;
    var  isMyselfandDependents = counterPrimary == 1 && counterSpouse == 0 && (counterChild >= 1 || counterAdultDependent >= 1);
    var  isMyselfSpouseDependents = counterPrimary == 1 && counterSpouse == 1 && (counterChild >= 1 || counterAdultDependent >= 1);

    if (isMySelf){
        $scope.bpTree.response.radioFamilyOption = "MySelf";
    }else if(isMyselfMyspouse){
        $scope.bpTree.response.radioFamilyOption = "MyselfMyspouse";
    }else if(isMyselfandDependents){
        $scope.bpTree.response.radioFamilyOption = "MyselfandDependents";
    }else if(isMyselfSpouseDependents){
        $scope.bpTree.response.radioFamilyOption = "MyselfSpouseDependents";
    }else{
        $scope.bpTree.response.radioFamilyOption = null;
    }
    
}
}]);