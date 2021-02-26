vlocity.cardframework.registerModule.controller('vlcDateCustom2', ['$scope', function($scope) {
    $scope.initValue = function(){
        var date = new Date();
        date.setDate(date.getDate() + 1);
        if($scope.bpTree.response.EffectiveDate!=undefined && $scope.bpTree.response.EffectiveDate!='undefined' && $scope.bpTree.response.EffectiveDate!=''){
            var datesplited = $scope.bpTree.response.EffectiveDate.split('/');
            date = new Date(datesplited[2], datesplited[0]-1, datesplited[1]);
        }
        console.info('date initialized',date);
        var ye = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(date);
        var mo = new Intl.DateTimeFormat('en', { month: '2-digit' }).format(date);
        var da = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(date);
        $scope.bpTree.response.myFamily.effDate = ye + "-" + mo + "-" + da;
    }
}]);