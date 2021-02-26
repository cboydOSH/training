vlocity.cardframework.registerModule.controller('programsController', ['$scope', function($scope) {

    // Template initialization
    /**
     * @param {Object} config OmniScript objects
     */
    $scope.insSelectionInit = function(config) {
        bpTreeResponse = config.bpTreeResponse;
        control = config.control;
        scp = config.scp;
        console.log('insSelectionInit control', control);
        console.log('insSelectionInit config', config);
    };
    
    $scope.nextLastStep = function(child){
        console.log('$scope.bpTree.response.planSelection', $scope.bpTree.response.planSelection);
        console.log('$scope.bpTree.response.planSelection.selectedPlans', $scope.bpTree.response.planSelection.selectedPlans);
        if($scope.bpTree.response.planSelection!=undefined && Array.isArray($scope.bpTree.response.planSelection.selectedPlans) && $scope.bpTree.response.planSelection.selectedPlans.length > 0){
            console.log('Called');
            var message = "<b>Thanks, We'll Take it from Here!</b><br> <br> Your answers have been saved, and we're generating your Information Packet! Please note that generated Packets cannot be edited. If you'd like to select different Programs for comparision, you must generate a new Packet.<br><br> If you'd like to make changes to this Packet now, click <b>\"Cancel\"</b>. Otherwise, click <b>\"OK\"</b> to generate.";
            var confirmed = confirm(message), interval = setInterval(function() {
                if(confirmed === true || confirmed.$$state.status) {
                    clearInterval(interval);
                    if(confirmed === true || confirmed.$$state.value) {
                        $scope.nextRepeater(child.nextIndex, child.indexInParent);
                    }
                }
            }, 200);
        }else{
            alert('Please select one program following above instructions');
            //$scope.nextRepeater(child.nextIndex, child.indexInParent);
        }
    }
}]);