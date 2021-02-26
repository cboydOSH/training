vlocity.cardframework.registerModule.controller('OSHappReview', ['$scope', function($scope) {
    /**
     * Looks for any Medication Conditions checked true
     * */
     $scope.medicalConditionsCheck = function(data){
        console.info(data);
        return !((data.heartdisease == false || data.heartdisease == undefined) && 
                (data.hearthbypasssurgery == false || data.hearthbypasssurgery == undefined) && 
                (data.diabetesI == false || data.diabetesI == undefined) && 
                (data.diabetesII == false || data.diabetesII == undefined) && 
                (data.kidneydiseaseorfailure == false || data.kidneydiseaseorfailure == undefined)&&
                (data.congestiveheartfailure == false || data.congestiveheartfailure == undefined) &&
                (data.hypertensionorhighblood == false || data.hypertensionorhighblood == undefined) &&
                (data.behavioralormentalhealth == false || data.behavioralormentalhealth == undefined)&&
                (data.hyperlipidemia == false || data.hyperlipidemia == undefined) &&
                (data.copd == false || data.copd == undefined) &&
                (data.eatingdisorders == false || data.eatingdisorders == undefined) &&
                (data.asthma == false || data.asthma == undefined) &&
                (data.hivaids == false || data.hivaids == undefined)&&
                (data.crohnsdisease == false || data.crohnsdisease == undefined) &&
                (data.herniateddisc == false || data.herniateddisc == undefined));
    }
}]);