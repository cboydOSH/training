vlocity.cardframework.registerModule.controller('OSHapp', ['$scope', function($scope) {

    //var cList = [];
    //var array = [];
    $scope.currentDate = new Date();
    $scope.radioConditions24monthFlag = null ;
    $scope.radioMedicalServiceFlag = null ;
    $scope.radioHaveorHadCancerFlag = null ;
    $scope.havePrescriptionMedicationsFlag = null ;
    $scope.radioPregnantFlag = null;
    $scope.playExtremeSportsFlag = null ;
    $scope.radioConsumeAlcoholFlag = null;
    $scope.vmedicalConditionsModified = null;
    $scope.radioHospitalizedFlag = null;
    $scope.hospitalizedDetails=[];
    $scope.medicalServiceDetails=[];
    $scope.radioConsumeTobaccoFlag=null;
    $scope.flagForHospitalizationDisclaimer = null;

    $scope.medicalConditionsForDisplayColumn1 = ["Diabetes I", "Diabetes II", "Kidney Disease/Failure", "Heart Disease", "Hearth By-Pass Surgery", 
                                        "Congestive Heart Failure", "Hypertension/High Blood Pressure", "Behavioral/Mental Health"];
    $scope.medicalConditionsForDisplayColumn2 = ["Herniated Disc", "Crohn’s Disease", "HIV/Aids", "Asthma", "Eating Disorders", "COPD", "Hyperlipidemia"];

    $scope.validate = function(){
        if($scope.radioConditions24monthFlag && $scope.vmedicalConditionsModified == null) return false; //first question
        var returnFromForEach = true;

        if($scope.radioMedicalServiceFlag){ //if medical services to add [second question]
            if($scope.medicalServiceDetails!="undefined"){
                if((Array.isArray($scope.medicalServiceDetails) && $scope.medicalServiceDetails.length) == 0) return false;
                Array.prototype.forEach.call($scope.medicalServiceDetails,medicalServiceMember => { //for each medicalServiceMemberDetails displayed on the UI table
                    if(typeof medicalServiceMember.incidentDate === "undefined" || medicalServiceMember.incidentDate == ""){
                        returnFromForEach = false;
                    }
                    if(typeof medicalServiceMember.providerName === "undefined" || medicalServiceMember.providerName == ""){
                        returnFromForEach = false;
                    }
                    if(typeof medicalServiceMember.diagnosis === "undefined" || medicalServiceMember.diagnosis == ""){
                        returnFromForEach = false;
                    }                
                });
            }
        }

        if($scope.radioHospitalizedFlag){
            if($scope.hospitalizedDetails!="undefined"){
                if((Array.isArray($scope.hospitalizedDetails) && $scope.hospitalizedDetails.length) == 0) return false;
                Array.prototype.forEach.call($scope.hospitalizedDetails,hospitalizedMember => { //for each hospitalizedDetails displayed on the UI table
                    if(typeof hospitalizedMember.admissionDate === "undefined" || hospitalizedMember.admissionDate == ""){
                        returnFromForEach = false;
                    }
                    if(typeof hospitalizedMember.facilityName === "undefined" || hospitalizedMember.facilityName == ""){
                        returnFromForEach = false;
                    }
                    if(typeof hospitalizedMember.diagnosis === "undefined" || hospitalizedMember.diagnosis == ""){
                        returnFromForEach = false;
                    }            
                });
            }
        }

        if($scope.bpTree.response.medicalQuestions !== undefined){
            if($scope.bpTree.response.medicalQuestions.CountFinalFemaleOnEditFamilyMember){ //is there are female
                if($scope.radioPregnantFlag==null) return false;
            }
        }
        
        if($scope.bpTree.response.EditFamilyMember !== undefined){
            $scope.bpTree.response.EditFamilyMember.forEach(member => {
                if($scope.radioHaveorHadCancerFlag){ //third question validation
                    if(member.hadcander == '5+ Years'){
                        if( member.hadCancerwhattype == "" || typeof member.hadCancerwhattype === "undefined"){
                            returnFromForEach = false;
                        }
                    }
                }
                if($scope.havePrescriptionMedicationsFlag){
                    if(member.medicalPrescriptiontext == "" || typeof member.medicalPrescriptiontext === "undefined"){
                        returnFromForEach = false;
                    }
                }
                if($scope.playExtremeSportsFlag){
                    if(member.extremesporttext == "" || typeof member.extremesporttext === "undefined"){
                        returnFromForEach = false;
                    }
                }
            });
        }

        if(!returnFromForEach){
            return returnFromForEach;
        }

         if ($scope.radioConditions24monthFlag == null || $scope.radioMedicalServiceFlag == null || $scope.radioHaveorHadCancerFlag == null || $scope.havePrescriptionMedicationsFlag == null 
         || $scope.playExtremeSportsFlag == null || $scope.radioConsumeAlcoholFlag == null || $scope.radioHospitalizedFlag == null || $scope.radioConsumeTobaccoFlag==null){
            return false;
         }

        return true;
    }

    /**
     * Method to verify todays date against the hospitalized date
     */
    $scope.dateUpdated = function(){
        $scope.flagForHospitalizationDisclaimer = false;
        var todaysDate = new Date();
        Array.prototype.forEach.call($scope.hospitalizedDetails,hospitalizedMember => { //for each hospitalizedDetails displayed on the UI table
            var diff = diff_months(todaysDate, new Date(hospitalizedMember.admissionDate)); // get months difference
            if(diff < 1){
                $scope.flagForHospitalizationDisclaimer = true;
            }
        });
    }

    /**
     * Method to re-initialize hospitalizedMemberDetails on the OS data
     */
    $scope.reinitializeHospitalizedMemberDetails = function(){
        $scope.bpTree.response.EditFamilyMember.forEach(member => {
            member["hospitalizedMemberDetails"]=[];
        });
    }

    /**
     * Method to sync the Hospitalized table data with the Omniscript data
     */
    $scope.synchHospitalizedTableDataToOS = function(){
        $scope.reinitializeHospitalizedMemberDetails(); //re-initialize hospital member details
        Array.prototype.forEach.call($scope.hospitalizedDetails,hospitalizedMember => { //for each hospitalizedDetails displayed on the UI table
            var index = $scope.bpTree.response.EditFamilyMember.findIndex( editMember => editMember.id === hospitalizedMember.id ); //Identify where the member is
            if( index !== -1){ //If found
                $scope.bpTree.response.EditFamilyMember[index].hospitalizedMemberDetails.push({
                    "admissionDate":typeof hospitalizedMember.admissionDate != undefined ? hospitalizedMember.admissionDate : "",
                    "facilityName":typeof hospitalizedMember.facilityName != undefined ? hospitalizedMember.facilityName : "",
                    "diagnosis":typeof hospitalizedMember.diagnosis != undefined ? hospitalizedMember.diagnosis : ""
                }); //Push the table data to the OS data
            }
        });
    }

    /**
     * Increase the rows of hospitalized details questions
     */
    $scope.addHospitalizedDetails = function(){
        $scope.hospitalizedDetails.push({
            "id":"",
            "admissionDate":"",
            "facilityName":"",
            "diagnosis":""
        });
    }

    /**
     * Decrease the rows of hospitalized details questions
     */
    $scope.deleteHospitalizedDetails = function(hospitalizedDetail){
        var index = $scope.hospitalizedDetails.findIndex( hospitalizedDetailsIndex => hospitalizedDetailsIndex === hospitalizedDetail );
        if( index !== -1){ //If found
            $scope.hospitalizedDetails.splice(index,1);
        }
        $scope.synchHospitalizedTableDataToOS();
    }

    /**
     * Method to re-initialize medicalServiceMemberDetails on the OS data
     */
    $scope.reinitializeMedicalServiceMemberDetails = function(){
        $scope.bpTree.response.EditFamilyMember.forEach(member => {
            member["medicalServiceMemberDetails"]=[];
        });
    }

    /**
     * Method to sync the medical service table data with the Omniscript data
     */
    $scope.synchMedicalServiceTableDataToOS = function(){
        $scope.reinitializeMedicalServiceMemberDetails(); //re-initialize medical service member details
        Array.prototype.forEach.call($scope.medicalServiceDetails,medicalServiceMember => { //for each medicalServiceMemberDetails displayed on the UI table
            var index = $scope.bpTree.response.EditFamilyMember.findIndex( editMember => editMember.id === medicalServiceMember.id ); //Identify where the member is
            if( index !== -1){ //If found
                $scope.bpTree.response.EditFamilyMember[index].medicalServiceMemberDetails.push({
                    "incidentDate":typeof medicalServiceMember.incidentDate != undefined ? medicalServiceMember.incidentDate : "",
                    "providerName":typeof medicalServiceMember.providerName != undefined ? medicalServiceMember.providerName : "",
                    "diagnosis":typeof medicalServiceMember.diagnosis != undefined ? medicalServiceMember.diagnosis : ""
                }); //Push the table data to the OS data
            }
        });
    }
    /**
     * Add medical service to UI table
     */
    $scope.addMedicalService = function(){
        $scope.medicalServiceDetails.push({
            "id":"",
            "incidentDate":"",
            "providerName":"",
            "diagnosis":""
        });
    }

    /**
     * Decrease the rows of hospitalized details questions
     */
    $scope.deleteMedicalService = function(medicalServiceDetail){
        var index = $scope.medicalServiceDetails.findIndex( medicalServiceDetailsIndex => medicalServiceDetailsIndex === medicalServiceDetail );
        if( index !== -1){ //If found
            $scope.medicalServiceDetails.splice(index,1);
        }
        $scope.synchMedicalServiceTableDataToOS();
    }

    /**
     * Function to get the months difference between two dates
     */
    function diff_months(dt2, dt1) {
        return moment(dt2).diff(dt1, 'months', false);
    }


    /**
     * Filter for relationship valid for display on medical questions
     */
    $scope.filterForRelationship = function(member){
        return member.relationship=="Primary" || member.relationship=="Spouse" || member.relationship=="Child" || member.relationship=="Adult Dependent" || member.relationship=="Disabled Dependent";
    }

    /**
     * Below methods are for controlling UI
     */
    $scope.radioConditions24monthFunction = function (isChecked){
        $scope.radioConditions24monthFlag =isChecked;
        if(isChecked == false){
            $scope.bpTree.response.EditFamilyMember.forEach(member => {
                member.diabetesI = false;
                member.diabetesII = false;
                member.kidneydiseaseorfailure = false;
                member.heartdisease = false;
                member.hearthbypasssurgery = false;
                member.congestiveheartfailure = false;
                member.hypertensionorhighblood = false;
                member.behavioralormentalhealth = false;
                member.herniateddisc = false;
                member.crohnsdisease = false;
                member.hivaids = false;
                member.asthma = false;
                member.eatingdisorders = false;
                member.copd = false;
                member.hyperlipidemia = false;
            });
             $scope.vmedicalConditionsModified=null;
        }
    }

    $scope.radioMedicalServiceFunction = function (isChecked){
        $scope.radioMedicalServiceFlag =isChecked;
    }
    $scope.radioHaveorHadCancerFunction = function (isChecked){
        $scope.radioHaveorHadCancerFlag =isChecked;
    }
    $scope.havePrescriptionMedicationsFunction = function (isChecked){
        $scope.havePrescriptionMedicationsFlag =isChecked;
    }
    $scope.radioPregnantFunction = function (isChecked){
        $scope.radioPregnantFlag =isChecked;
    }
    $scope.playExtremeSportsFunction = function (isChecked){
        $scope.playExtremeSportsFlag =isChecked;
    }
    $scope.radioConsumeAlcoholFunction = function (isChecked){
        $scope.radioConsumeAlcoholFlag =isChecked;
    }
    $scope.radioConsumeTobaccoFunction = function (isChecked){
        $scope.radioConsumeTobaccoFlag =isChecked;
    }
    $scope.radioHospitalizedFunction = function (isChecked){
        $scope.radioHospitalizedFlag =isChecked;
    }
    $scope.medicalConditionsModified = function(medicalCondition, medDesc, member){
        if($scope.vmedicalConditionsModified==null){
            $scope.vmedicalConditionsModified=0;
        }
        if(medicalCondition){
            $scope.vmedicalConditionsModified+=1;
        }else{
            $scope.vmedicalConditionsModified-=1;
        }    
        if($scope.vmedicalConditionsModified==0){
            $scope.vmedicalConditionsModified=null;
        }

        if(member.listMedDesc == undefined || member.listMedDesc == 'undefined'){
            member.listMedDesc = [];
            member.medDescString = "";
        }
        
        if(member.listMedDesc.indexOf(medDesc) == -1){
            member.listMedDesc.push(medDesc);
        }else{
            member.listMedDesc.splice(member.listMedDesc.indexOf(medDesc), 1);
        }
        member.medDescString = member.listMedDesc.join(", ");
    }
}]);