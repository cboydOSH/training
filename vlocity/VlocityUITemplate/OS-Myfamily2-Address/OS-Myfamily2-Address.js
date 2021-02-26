vlocity.cardframework.registerModule.controller('OSHController', ['$scope', '$rootScope', '$timeout', function($scope, $rootScope, $timeout) {

     //for autopopulating
        //Ethnic Dropdown
        $scope.statelist=[
        "AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH",
        "NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY",
        ];
        
        $scope.ethnicityAndDesc=[
            {name:"Hispanic or Latino", description:" a person of Cuban, Mexican, Chicano, Puerto Rican, South or Central American, or other spanish culture or origin, regardless of race."},
            {name:"White", description:" a person having origins in any of the original peoples of Europe, the Middle East, or North Africa."},
            {name:"Black or African American", description:" a person having origins in any of the black racial groups of Africa."},
            {name:"Asian", description:" a person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam."},
            {name:"Native Hawaiian or Other Pacific Islander", description:" a person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands."},
            {name:"American Indian or Alaska Native", description:" a person having origins in any of the original peoples of North and South America (including Central America), and who maintains tribal affiliation or community attachment."},
            {name:"Two or More Races", description:" a person who primarily identifies with two or more of the above race/ethnicity categories."},
            {name:"Prefer not to answer", description:""}
            ];

        var cList = [];
        var className = '%vlocity_namespace%.DefaultDROmniScriptIntegration';            
        var classMethod = 'invokeOutboundDR';  
        $scope.censusDetails = [];
        $scope.gender = ["Male", "Female"];
        //$scope.tobacco = ["Yes", "No"];
        $scope.americanIndian = ["Yes", "No"];
        $scope.eligiblemedicare = ["Yes", "No"];


        $scope.primaryRelationships = ["Primary"];
        $scope.spouseRelationships = ["Spouse"];

        $scope.dependentRelationship = ["Spouse","Adult Dependent", "Child"];
        $scope.childRelationship = ["Adult Dependent","Child"];
        $scope.blank=null;



        $scope.dateToday = new Date();
        var uniqueId = new Date().valueOf();
        var uniqueId2 = new Date().valueOf();
        var parentUniqueId = uniqueId;

        //If the context ID has a Person Account Id
        var personAcc = typeof $scope.bpTree.response.PersonAccount != 'undefined' ? $scope.bpTree.response.PersonAccount : {};


        // console.log('$scope.bpTree.response.ThisisQuote', $scope.bpTree.response.ThisisQuote);
        // console.log('$scope.bpTree.response.myFamily', $scope.bpTree.response.myFamily);
        // console.log('$scope.bpTree.response', $scope.bpTree.response);

        angular.element(document).ready(function() {
            if(typeof $scope.bpTree.response.letsGetStarted != 'undefined'){
                if($scope.bpTree.response.AddEditFamilyMember!= undefined && $scope.bpTree.response.AddEditFamilyMember[0]!= 'undefined' && $scope.bpTree.response.AddEditFamilyMember[0].fname !=null){
                }else{
                    $scope.censusDetails.push({
                    'id': uniqueId.toString(),
                    'parent_id': parentUniqueId.toString(),
                    'fname': typeof $scope.bpTree.response.letsGetStarted != 'undefined' && typeof $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket != 'undefined' ? $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.fName: "",
                    'lname': typeof $scope.bpTree.response.letsGetStarted != 'undefined' && typeof $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket != 'undefined' ? $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.lName: "",
                    'dob': "",
                    //'tobacco': "No",
                    'defaultNo': "false",
                    'age': 0,
                    'relationship': "Primary",
                    'americanIndian':"",
                    'eligiblemedicare':"",
                    'address':"",
                    'city':"",
                    'state':"",
                    'zipcode':"",
                    'phone':"",
                    'email':"",
                    'gender':""
                    });   
                }
                $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
            }

            var className = '%vlocity_namespace%.DefaultDROmniScriptIntegration'; 
            var classMethod = 'invokeOutboundDR';
            if($scope.bpTree.response.Thisisdirect==true){
                console.info('this is direct');
                var inputMap = {
                    DRParams:{
                        incomingQuoteId : $scope.bpTree.response.ContextId
                    },
                    Bundle:"DREX_INDIV_enrollGetQuoteProductAvailability"
                };

                console.log('input map parameters',inputMap);
                $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(inputMap),'{}').then(function(result){
                    var resultParsed = JSON.parse(result);
                    console.log('result Parsed', resultParsed);
                    var countFalse = 0; //Counter For false programs
                    $scope.bpTree.response.productsAvailability = resultParsed.OBDRresp.Products;
                    $scope.bpTree.response.productsAvailability.forEach( product => {
                        console.log(product);
                        if(product.IsActive==false){
                            countFalse++;
                        }
                    });
                    if(countFalse===$scope.bpTree.response.productsAvailability.length){
                        //All are false.
                        // alert("Unfortunately, none of the programs included in the Information Packet you selected are" +
                        // "currently available for Enrollment. Please create a new Information Packet to continue you " +
                        // "Enrollment process.");
                        $scope.bpTree.response.myFamily.hasProductsAvailable=false;
                    }else{
                        $scope.bpTree.response.myFamily.hasProductsAvailable=true;
                    }
                    console.log('resultParsed',resultParsed);
                    console.log('$scope.bpTree.response.myFamily.hasProductsAvailable',$scope.bpTree.response.myFamily.hasProductsAvailable);
                });
            }
        
        });       

       //Watch Checkbox Field 
        $scope.$watch('bpTree.response.myFamily.RadioFamily', function() {
            if($scope.bpTree.response.myFamily.RadioFamily!=null && $scope.bpTree.response.AddEditFamilyMember != 'undefined'){
                //console.info('watcher executed RadioFamily: ', $scope.bpTree.response.myFamily.RadioFamily);
                if($scope.bpTree.response.AddEditFamilyMember!= undefined && $scope.bpTree.response.AddEditFamilyMember[0]!= 'undefined' && $scope.bpTree.response.AddEditFamilyMember[0].fname !=null){
                    //console.info('movingonfamilyradio');
                    $scope.movingOnFamilyRadio();
                    groupCensus();
                }else{
                    //console.info('NOT NOT NOT movingonfamilyradio meaning delete all census');
                    $scope.deleteAllCensus();
                    if($scope.bpTree.response.myFamily.RadioFamily =="MySelf" ){
                        
                    }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfMyspouse" ){
                        $scope.addNewSpouse(true, $scope.censusDetails[0]);
                    }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfandDependents" ){
                        $scope.addNewChild(true, $scope.censusDetails[0]);

                    }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfSpouseDependents"){
                        $scope.addNewSpouse(true, $scope.censusDetails[0]);
                        $scope.addNewChild(true, $scope.censusDetails[0]);
                    }
                }
                $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
                groupCensus();
            }
        });

        $scope.createPrimary = function(){
                    $scope.censusDetails = [];
                    $scope.censusDetails.push({
                        'id': uniqueId.toString(),
                        'parent_id': parentUniqueId.toString(),
            'fname': typeof $scope.bpTree.response.letsGetStarted != 'undefined' && typeof $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.fName != 'undefined' ? $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.fName: "",
            'lname': typeof $scope.bpTree.response.letsGetStarted != 'undefined' && typeof $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.lName != 'undefined' ? $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.lName: "",
                        'dob': "",
                        //'tobacco': "No",
                        'defaultNo': "false",
                        'age': 0,
                        'relationship': "Primary",
                        'americanIndian':"",
                        'eligiblemedicare':"",
                        'address':"",
                        'city':"",
                        'state':"",
                        'zipcode':"",
                        'phone':"",
                        'email':""
                    });
        }


        $scope.hasSpouseInFamily = function(dependent){
                var result = false;
                $scope.censusDetails.forEach(function(person){
                    if(person.relationship == 'Spouse'){
                        result = true;
                    }
                });
                return result;
        } 

        function fetchCensus(){
                // $scope.censusDetails = [];
                console.info('fetchCensus');
                // console.info('fetchCensus: censusDetails', JSON.stringify($scope.censusDetails), 'addedit',JSON.stringify($scope.bpTree.response.AddEditFamilyMember),'membersData',JSON.stringify($scope.bpTree.response.membersData));
                if(typeof $scope.bpTree.response.census_Step != 'undefined'){
                    $scope.censusDetails = [];
                    $scope.bpTree.response.membersData.map(function(member){
                        $scope.censusDetails.push({
                            'id': member.id.toString(),
                            'parent_id': member.parent_id.toString(),
                            'fname': member.fname,
                            'lname': member.lname,
                            'dob': new Date(member.dob),
                            //'tobacco': member.tobacco,
                            'defaultNo':'false',
                            'age': 0,
                            'americanIndian': member.americanIndian,
                            'eligiblemedicare': member.eligiblemedicare,
                            'relationship': member.relationship,
                            'address':"",
                            'city':"",
                            'state':"",
                            'zipcode':"",
                            'phone':"",
                            'email':"",
                            'gender': ""
                        });
                    });
                    if($scope.censusDetails.length == 0) {
                        $scope.censusDetails.push({
                            'id': uniqueId.toString(),
                            'parent_id': parentUniqueId.toString(),
                            'fname': typeof personAcc.FirstName != 'undefined' && personAcc.FirstName != null ?  personAcc.FirstName : "",
                            'lname': typeof personAcc.Lastname != 'undefined' && personAcc.Lastname != null ?  personAcc.Lastname : "",
                            'dob': typeof personAcc.Birthdate != 'undefined' && personAcc.Birthdate != null ?  new Date(personAcc.Birthdate) : "",
                            //'tobacco': "",
                            'defaultNo': "false",
                            'age': 0,
                            'relationship': "Primary",
                            'americanIndian':"",
                            'eligiblemedicare':"",
                            'address':"",
                            'city':"",
                            'state':"",
                            'zipcode':"",
                            'phone':"",
                            'email':"",
                            'gender': ""
                        });
                    }
                    $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
                }
                else if($scope.bpTree.response.AddEditFamilyMember){
                    angular.forEach($scope.bpTree.response.AddEditFamilyMember, function(emp) {
                        if(emp.dob instanceof Date == false){
                            emp.dob = new Date(emp.dob);
                        }
                    });
                    $scope.censusDetails = angular.copy($scope.bpTree.response.AddEditFamilyMember);
                }
        }

        function validateCensus(type, value){
                switch (type) {
                    case 'spouseCount':     var spouseCount = _.countBy(value).Spouse;
                                            if(spouseCount > 1){
                                                $scope.bpTree.response.validCensus = false;
                                            }
                        					if(spouseCount == 1){
												$scope.hasSpouse = true;
                                            }
											if(spouseCount != 1){
												$scope.hasSpouse = false;
                                            }
                                            break;
                    default:                break;
                        
                }
        }


        function groupCensus(){
            //console.info("Census Changed");
            $scope.censusGroup = _.groupBy($scope.censusDetails, 'parent_id');
            $scope.censusGroupArr = Object.keys($scope.censusGroup).map(function (key) { return $scope.censusGroup[key]; });
            $scope.censusInfo = {};
            $scope.censusInfo.EmpFaCount = 0, $scope.censusInfo.EmpSpCount = 0, $scope.censusInfo.EmpChCount = 0, $scope.censusInfo.EmpCount = 0;
            $scope.bpTree.response.validCensus = true;
            $scope.censusGroupArr.map(function(member){
                var censusType = _.map(member, 'relationship');

                if(censusType.includes('Primary') && censusType.includes('Spouse')  && censusType.includes('Child')){
                    $scope.censusInfo.EmpFaCount += 1;
                }
                else if(censusType.includes('Primary') && censusType.includes('Spouse')  && !censusType.includes('Child')){
                    $scope.censusInfo.EmpSpCount += 1;
                }
                else if(censusType.includes('Primary') && !censusType.includes('Spouse')  && censusType.includes('Child')){
                    $scope.censusInfo.EmpChCount += 1;
                }
                else if(censusType.includes('Primary') && !censusType.includes('Spouse')  && !censusType.includes('Child')){
                    $scope.censusInfo.EmpCount += 1;
                }
                validateCensus('spouseCount', censusType);
            });

            $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
            $scope.censusAgeErrorMsg = '';
            $scope.censusAgeOldest = '';
            $scope.censusAlaskaError = '';
            $scope.errorDOBList = [];
            $scope.bpTree.response.errorDOBList = [];
            $scope.bpTree.response.oldestMemberList = [];
            $scope.bpTree.response.NoEmpAge18 = 0; 
            $scope.bpTree.response.NoSpouse65 = 0; 
            $scope.bpTree.response.NoChildWrongDate = 0;
            $scope.bpTree.response.HaveAdultDependent = 0; 
            $scope.bpTree.response.NoChildGreaterThan27 = 0;
            $scope.bpTree.response.NoChildGreaterThan65 = 0;
            $scope.bpTree.response.NoAdultGreaterThan27AndLesserThan65 = 0;
            $scope.bpTree.response.childrenInCensus = ($scope.censusInfo.EmpChCount  > 0 && $scope.bpTree.response.NoEmpAge18 == 0) ? true : false;
            $scope.bpTree.response.DateError = 0; 
            $scope.bpTree.response.DateErrorMessage = '';

            var oldestPersonAge = 0; 
            var memberOldest = null;

            $scope.bpTree.response.AddEditFamilyMember.map(function(member){
                

                //DOB: 02/15/1993 - 26 and will be 27 

                //TODAY:  24 January 2020  - 26 years

                //effective date: 03/23/2020
                
                var effectiveDate = new Date($scope.bpTree.response.myFamily.effDate);
                if($scope.bpTree.response.myFamily.effDate==undefined||$scope.bpTree.response.myFamily.effDate=="undefined"){
                    effectiveDate = new Date();
                }
                //console.info("effectiveDate", effectiveDate);
                //console.info("$scope.bpTree.response.myFamily.effDate", $scope.bpTree.response.myFamily.effDate);
                //console.info("$scope.bpTree.response.myFamily", $scope.bpTree.response.myFamily);
                
                
                var diffDateYears = moment(effectiveDate).diff(member.dob, 'years', false); //Age from Effective Date
                var diffDateMonths = moment(effectiveDate).diff(member.dob, 'months', false);
                var diffDateDays = moment(effectiveDate).diff(member.dob, 'days', false);
                var radioFamilyTemp = $scope.bpTree.response.myFamily.RadioFamily;

                if(effectiveDate.getDate()==new Date(member.dob).getDate() && effectiveDate.getMonth()== new Date(member.dob).getMonth()){
                    diffDateYears+=1;
                }

                
                /**
                 * New rules added
                 */
                var effectiveDateforComparison = new Date(effectiveDate);
                effectiveDateforComparison.setDate(effectiveDateforComparison.getDate() + 1); //getting actual selected date
                effectiveDateforComparison.setDate(1); //going back to 1 day of month
                var startOfMonth =  moment(effectiveDateforComparison.setMonth(effectiveDateforComparison.getMonth()-1)).endOf('month').format('YYYY-MM-DD');
                var endOfMonth   = moment(effectiveDateforComparison.setMonth(effectiveDateforComparison.getMonth()+1)).endOf('month').format('YYYY-MM-DD');
                // console.info("before my changes diffDateYears",diffDateYears);
                // console.info("effectiveDateforComparison",effectiveDateforComparison);
                // console.info("startOfMonth",startOfMonth);
                // console.info("endOfMonth",endOfMonth);
                if(member.relationship == 'Child'){
                    if(diffDateYears==27){
                        diffDateYears = moment(startOfMonth).diff(member.dob, 'years', false); //using first day of month
                    }
                }else if(member.relationship == 'Adult Dependent'){
                    if(diffDateYears==65){
                        diffDateYears = moment(startOfMonth).diff(member.dob, 'years', false); //using first day of month
                    }else if(diffDateYears==26){
                        diffDateYears = moment(endOfMonth).diff(member.dob, 'years', false); //using last day of month
                    }
                }else if(member.relationship == 'Primary'){
                    if(diffDateYears==17){
                        diffDateYears = moment(endOfMonth).diff(member.dob, 'years', false); //using last day of month
                    }else if(diffDateYears==65){
                        diffDateYears = moment(startOfMonth).diff(member.dob, 'years', false); //using last day of month
                    }
                }

                member.defaultNo = 'false';
                member.age = 0;
                if(typeof diffDateYears == 'NaN' || Number.isNaN(diffDateYears)){member.age = 0;}else{member.age = diffDateYears;}
                // console.log("member.age", member.age);
                                            
                //ABussiness Rules 18 and 65 for Primary and Spouse
                if((diffDateYears < 18 || diffDateYears >= 65) && (member.relationship == 'Primary')) {
                    $scope.bpTree.response.NoEmpAge18 += 1; 
                }

                if(diffDateYears >= 65 && (member.relationship == 'Spouse')) {
                    $scope.bpTree.response.NoSpouse65 += 1; 
                }

                $scope.isValidEffectiveDateQuote();//vicente martinez added on september 30th

                //Undefined DOB - 1899 or incorrect values
                console.info("member.dob",member.dob);
                if(typeof member.dob  == 'undefined' ){
                    $scope.bpTree.response.validCensus = false;
                    $scope.errorDOBList.push(member.id);
                    $scope.bpTree.response.errorDOBList.push(member.id);
                    $scope.censusAgeErrorMsg =  'Please enter a valid Birth Date. Valid date format is “MM/DD/YYYY”.';//Hector B. included date format on 14-01-21
                    return true;
                }
                //ERROR in DOB
                if((diffDateYears < 0 || diffDateMonths < 0 || diffDateDays < 0)){
                    $scope.bpTree.response.validCensus = false;
                    $scope.censusAgeErrorMsg = 'Please enter a valid Birth Date. Valid date format is “MM/DD/YYYY”.';//Hector B. included date format on 14-01-21
                    $scope.errorDOBList.push(member.id);
                    $scope.bpTree.response.errorDOBList.push(member.id);
                    $scope.bpTree.response.NoChildWrongDate += 1 ; 
                    return true;
                }

                //BUSINESS RULES
                if(diffDateYears > 65 && member.relationship == 'Child' && radioFamilyTemp == 'MyselfandDependents' ){
                    // member.tobacco = 'No';
                    //member.defaultNo = 'true';
                    // member.age = diffDateYears;
                     $scope.bpTree.response.NoChildGreaterThan65 += 1; 
                     $scope.errorDOBList.push(member.id);
                     $scope.bpTree.response.errorDOBList.push(member.id);
                     return true;
                }
                if(diffDateYears >= 27 && member.relationship == 'Child' && radioFamilyTemp == 'MyselfandDependents' ){
                        $scope.bpTree.response.NoChildGreaterThan27 += 1; 
                        $scope.errorDOBList.push(member.id);
                        $scope.bpTree.response.errorDOBList.push(member.id);
                        return true;
                }
                if(diffDateYears >= 27 && member.relationship == 'Child' && radioFamilyTemp == 'MyselfSpouseDependents' ){
                        $scope.bpTree.response.NoChildGreaterThan27 += 1; 
                        $scope.errorDOBList.push(member.id);
                        $scope.bpTree.response.errorDOBList.push(member.id);
                        return true;
                }
                if((diffDateYears < 27 || diffDateYears >= 65) && member.relationship == 'Adult Dependent' && radioFamilyTemp == 'MyselfandDependents' ){
                        // $scope.censusAgeErrorMsg = 'Child or Disabled Dependent with 27 or older cannot be covered.'; || diffDateYears >= 65
                        $scope.bpTree.response.NoAdultGreaterThan27AndLesserThan65 += 1; 
                        $scope.errorDOBList.push(member.id);
                        $scope.bpTree.response.errorDOBList.push(member.id);
                        return true;
                }
                if((diffDateYears < 27 || diffDateYears >= 65) && member.relationship == 'Adult Dependent' && radioFamilyTemp == 'MyselfSpouseDependents' ){
                        // $scope.censusAgeErrorMsg = 'Child or Disabled Dependent with 27 or older cannot be covered.'; || diffDateYears >= 65
                        $scope.bpTree.response.NoAdultGreaterThan27AndLesserThan65 += 1; 
                        $scope.errorDOBList.push(member.id);
                        $scope.bpTree.response.errorDOBList.push(member.id);
                        return true;
                }    
                if(member.relationship == 'Adult Dependent' && (radioFamilyTemp != 'Myself' || radioFamilyTemp != 'MyselfSpouseDependents')){
                        // $scope.censusAgeErrorMsg = 'Child or Disabled Dependent with 27 or older cannot be covered.'; || diffDateYears >= 65
                        $scope.bpTree.response.HaveAdultDependent += 1; 
                        //$scope.errorDOBList.push(member.id);
                        //$scope.bpTree.response.errorDOBList.push(member.id);
                       // return true; as this is not an error we should not be returning, commented by Vicente Martinez
                }
                //console.info("diffDateYears", diffDateYears, "oldestPersonAge", oldestPersonAge, "!Number.isNaN(diffDateYears)", !Number.isNaN(diffDateYears));
                //console.info("diffDateDays", diffDateDays, "oldestPersonAge", oldestPersonAge, "!Number.isNaN(diffDateDays)", !Number.isNaN(diffDateDays));
                if(!Number.isNaN(diffDateDays)){
                    //console.info("Comparing");
                    if(diffDateDays >= oldestPersonAge){
                        oldestPersonAge = diffDateDays;
                        memberOldest = member;
                    }
                }

                else{
                    $scope.errorDOBList = _.filter($scope.errorDOBList, function(x) { return x != member.id });
                }
            });

            //caluclate member 
         
            if(memberOldest != null ){
                $scope.bpTree.response.oldestMemberList.push(memberOldest);
                $scope.censusAgeOldest = 'Rating will be based on ' + memberOldest.fname + ' ' + memberOldest.lname;
                //console.log();
                calculateDiffDate();  
             }

            
        }


        $scope.isSpouseOnly = function(dependent){
            return $scope.bpTree.response.myFamily.RadioFamily =="MyselfMyspouse";
        }

        /*$scope.addNewMember = function(addDependent, employee) {
            //Dependent
            if (addDependent) {
                uniqueId = new Date().valueOf();
                // parentUniqueId = selectedMember[0].id;
                parentUniqueId = employee.id;
            }
            //Employee
            else { 
                uniqueId = new Date().valueOf();
                parentUniqueId = uniqueId;
                    countEmployees();
            }
            $scope.censusDetails.push({
                'id': uniqueId.toString(),
                'parent_id': parentUniqueId.toString(),
                'fname': "",
                'lname': "",
                'dob': "",
                //'tobacco': "No",
                'defaultNo': "false",
                'age': 0,
                'relationship': addDependent ? "":"Primary",
                'americanIndian':"",
                'eligiblemedicare':"",
                'address':"",
                'city':"",
                'state':"",
                'zipcode':"",
                'phone':"",
                'email':""
                
            });
            groupCensus();

        };*/

         $scope.addNewSpouse = function(addDependent, employee) {
       
            var uniqueId2 = new Date().valueOf() + 3;
            var parentUniqueId2 = employee.id;
            $scope.censusDetails.push({
                'id': uniqueId2.toString(),
                'parent_id': parentUniqueId2.toString(),
                'fname': "",
                'lname': "",
                'dob': "",
                //'tobacco': "No",
                'defaultNo': "false",
                'age': 0,
                'relationship': "Spouse",
                'americanIndian':"",
                'eligiblemedicare':"",
                'address':"",
                'city':"",
                'state':"",
                'zipcode':"",
                'phone':"",
                'email':"",
                'gender': ""                
            });
            groupCensus();

        };

        $scope.addNewChild= function(addDependent, employee) {
            var uniqueId2 = new Date().valueOf() + 5;
            var parentUniqueId2 = employee.id;
            $scope.censusDetails.push({
                'id': uniqueId2.toString(),
                'parent_id': parentUniqueId2.toString(),
                'fname': "",
                'lname': "",
                'dob': "",
                //'tobacco': "No",
                'defaultNo': "false",
                'age': 0,
                'relationship': "Child",
                'americanIndian':"",
                'eligiblemedicare':"",
                'address':"",
                'city':"",
                'state':"",
                'zipcode':"",
                'phone':"",
                'email':"",
                'gender': ""
            });
            groupCensus();

        };


        $scope.updateRelationShip = function(){
            groupCensus();
            $scope.getOldestMemberListForEnroll();
        }


        //Delete FamilyRows 
        $scope.deleteCensus = function(censusMember) {
            //console.info(censusMember);
            if (censusMember.id == censusMember.parent_id) {
                $scope.bpTree.response.NumOfEmployeeInternal = $scope.bpTree.response.NumOfEmployeeInternal - 1;
                $scope.censusDetails = _.reject($scope.censusDetails, function(el) {
                    return el.parent_id === censusMember.parent_id;
                });
            } else {
                // $scope.bpTree.response.NumOfEmployeeInternal = $scope.bpTree.response.NumOfEmployeeInternal - 1;
                $scope.censusDetails = _.reject($scope.censusDetails, function(el) {
                    return el.id === censusMember.id;
                });
            }
            groupCensus();
        }

        $scope.deleteAllCensus = function(){
            // console.log('deleteAllCensus');
            var primary = null;
            $scope.bpTree.response.AddEditFamilyMember.forEach(function(member){
                if(member.relationship=="Primary"){
                    primary = member;
                }
            });
            $scope.bpTree.response.oldestMemberList=[];
            uniqueId = new Date().valueOf();
            parentUniqueId = uniqueId;
            $scope.censusDetails = [];
            var dateprimary = new Date(primary.dob);
            //console.log("enocntrar ", primary!=null, primary.dob, typeof primary.dob, dateprimary);
            $scope.censusDetails.push({
                    'id': uniqueId.toString(),
                    'parent_id': parentUniqueId.toString(),
        'fname': typeof $scope.bpTree.response.letsGetStarted != 'undefined' && typeof $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.fName != 'undefined' ? $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.fName: "",
        'lname': typeof $scope.bpTree.response.letsGetStarted != 'undefined' && typeof $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.lName != 'undefined' ? $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket.lName: "",
                    'dob': primary != null ? new Date(dateprimary.getUTCFullYear(), dateprimary.getUTCMonth(), dateprimary.getUTCDate(), 0, dateprimary.getUTCMinutes(), dateprimary.getUTCSeconds()) : "",
                    //'tobacco': "No",
                    'defaultNo': "false",
                    'age': primary != null ? primary.age : "",
                    'relationship': "Primary",
                    'americanIndian':"",
                    'eligiblemedicare':"",
                    'address':"",
                    'city':"",
                    'state':"",
                    'zipcode':"",
                    'phone':"",
                    'email':"",
                    'gender': primary != null ? primary.gender : ""
                });
            $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
            $scope.bpTree.response.NumOfEmployeeInternal = 1;
        }

        $scope.clearAllCensus = function(){
            // console.log('clearAllCensus');
            // var primary = null;
            // $scope.bpTree.response.AddEditFamilyMember.forEach(function(member){
            //     if(member.relationship=="Primary"){
            //         primary = member;
            //     }
            // });
            //uniqueId = new Date().valueOf();
            //parentUniqueId = uniqueId;
            //$scope.censusDetails = [];
            // console.log('censusDetails', $scope.censusDetails);
            $scope.censusDetails.forEach(function(member){
                if(member.relationship!="Primary"){
                    member.fname='';
                    member.lname='';
                    member.dob='';
                    member.age='';
                    member.gender='';
                } else {
                    $scope.bpTree.response.oldestMemberList = [];
                    $scope.bpTree.response.oldestMemberList.push(member);
                }
            });
            // console.log('actvarCensus');
            // console.log('censusDetails', $scope.censusDetails);
            $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
            $scope.bpTree.response.NumOfEmployeeInternal = 1;
       
        }

        function getAge(dateString) {
            var today = new Date();
            var birthDate = new Date(dateString);
            var age = today.getFullYear() - birthDate.getFullYear();
            var m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            return age;
            
        }


        $scope.movingOnFamilyRadio = function(){
            console.log('movingOnFamilyRadio');
            $scope.censusDetails = [];
            //console.info($scope.bpTree.response.AddEditFamilyMember);
            $scope.bpTree.response.AddEditFamilyMember.forEach(member => {
                if($scope.bpTree.response.myFamily.RadioFamily =="MySelf" && "Primary".includes(member.relationship) ){
                    $scope.addMember(member);
                }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfMyspouse" && "Primary,Spouse".includes(member.relationship)){
                    $scope.addMember(member);
                }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfandDependents" && "Primary,Child,Adult Dependent".includes(member.relationship)){
                    $scope.addMember(member);
                }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfSpouseDependents" && "Primary,Spouse,Child,Adult Dependent".includes(member.relationship)){
                    $scope.addMember(member);
                }  
            });

            if($scope.bpTree.response.myFamily.RadioFamily =="MyselfMyspouse" && $scope.bpTree.response.AddEditFamilyMember.findIndex(member => member.relationship === 'Spouse') == -1){
                $scope.addNewSpouse(true, $scope.censusDetails[0]);
            }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfandDependents" && $scope.bpTree.response.AddEditFamilyMember.findIndex(member => (member.relationship === 'Child' || member.relationship === 'Adult Dependent' )) == -1){
                $scope.addNewChild(true, $scope.censusDetails[0]);
            }else if($scope.bpTree.response.myFamily.RadioFamily =="MyselfSpouseDependents"){
                if($scope.bpTree.response.AddEditFamilyMember.findIndex(member => member.relationship === 'Spouse') == -1){
                    $scope.addNewSpouse(true, $scope.censusDetails[0]);
                }
                if($scope.bpTree.response.AddEditFamilyMember.findIndex(member => (member.relationship === 'Child' || member.relationship === 'Adult Dependent' )) == -1){
                    $scope.addNewChild(true, $scope.censusDetails[0]);
                }
            }
            $scope.sortMembers();
            $scope.bpTree.response.AddEditFamilyMember = angular.copy($scope.censusDetails);
            $scope.bpTree.response.NumOfEmployeeInternal = 1;
        }

        $scope.addMember = function(member){
            $scope.censusDetails.push({
                'id': member.id,
                'parent_id': member.parent_id,
                'fname': member.fname,
                'lname': member.lname,
                'dob': member.dob,
                //'tobacco': "No",
                'defaultNo': "false",
                'age': 0,
                'relationship': member.relationship,
                'americanIndian':"",
                'eligiblemedicare':"",
                'address':"",
                'city':"",
                'state':"",
                'zipcode':"",
                'phone':"",
                'email':"",
                'gender':member.gender
                }); 
        }

        /**
         * Method for sorting the primary and spouse
         */
        $scope.sortMembers = function(){
            var tempArray = [];
            if($scope.censusDetails.findIndex(member => member.relationship === 'Primary') != -1){
                tempArray.push($scope.censusDetails[$scope.censusDetails.findIndex(member => member.relationship === 'Primary')]);
                $scope.censusDetails.splice($scope.censusDetails.findIndex(member => member.relationship === 'Primary'), 1);
            }
            if($scope.censusDetails.findIndex(member => member.relationship === 'Spouse') != -1){
                tempArray.push($scope.censusDetails[$scope.censusDetails.findIndex(member => member.relationship === 'Spouse')]);
                $scope.censusDetails.splice($scope.censusDetails.findIndex(member => member.relationship === 'Spouse'), 1);
            }
            $scope.censusDetails.forEach(function(person){
                tempArray.push(person);
            });
            $scope.censusDetails = angular.copy(tempArray);
        }

        //Function to calculate dynamically Age in rows
        $scope.isTwentyOneAndOlder = function (dateDob){
                var diffDateYears = moment().diff(dateDob, 'years', false);
                if(diffDateYears >= 21){
                    return true;
                }else{
                    return false;
                }
        }
        $scope.isTwentySevenOlder = function (dateDob){
                var diffDateYears = moment().diff(dateDob, 'years', false);
                if(diffDateYears >= 26){
                    return true;
                }else{
                    return false;
                }
        }

        $scope.addNewMember = function(addDependent) {
            //Dependent
            if (addDependent) {
                parentUniqueId = uniqueId;
                uniqueId = new Date().valueOf();                
            }
            //Employee
            else { 
                uniqueId = new Date().valueOf();
                parentUniqueId = uniqueId;
            }
            $scope.censusDetails.push({
                'id': uniqueId.toString(),
                'parent_id': parentUniqueId.toString(),
                'fname': "",
                'lname': "",
                'dob': "",
                //'tobacco': "No",
                'defaultNo': "false",
                'age': 0,
                'relationship': addDependent ? "Child" : "Primary",
                'americanIndian':"",
                'eligiblemedicare':"",
                'address':"",
                'city':"",
                'state':"",
                'zipcode':"",
                'phone':"",
                'email':""
                
            });
            groupCensus();

        };

        $scope.updateCensusDetails = function(){
            if(typeof $scope.bpTree.response.EditFamilyMember !== "undefined"){
                $scope.bpTree.response.EditFamilyMember.forEach(function(familyMember){
                    familyMember.address = $scope.bpTree.response.Welcome['TAAddressGoogle-Block'].address;
                    familyMember.city = $scope.bpTree.response.Welcome['TAAddressGoogle-Block'].city;
                    familyMember.state = $scope.bpTree.response.Welcome['TAAddressGoogle-Block'].state;
                    familyMember.zipcode = $scope.bpTree.response.Welcome['TAAddressGoogle-Block'].zipCode;
                    familyMember.phone = $scope.bpTree.response.Welcome.Telephone;
                    if((familyMember.age < 18 && familyMember.relationship=='Child') || familyMember.relationship=='Adult Dependent' || familyMember.relationship=='Primary'){
                        familyMember.email = $scope.bpTree.response.Welcome.Email;
                    }
                });
            }else{
                // console.log("was undefined");
            }
        }

        $scope.$watch("bpTree.response.Welcome['TAAddressGoogle-Block'].address", function (value1, value2, value3) {
            // console.log("watcher executed Address", value1, value2, value3);
            $scope.updateCensusDetails();
        }, true);
        $scope.$watch("bpTree.response.Welcome['TAAddressGoogle-Block'].city", function (value1, value2, value3) {
            // console.log("watcher executed City", value1, value2, value3);
            $scope.updateCensusDetails();
        }, true);
        $scope.$watch("bpTree.response.Welcome['TAAddressGoogle-Block'].state", function (value1, value2, value3) {
            // console.log("watcher executed State", value1, value2, value3);
            $scope.updateCensusDetails();
        }, true);
        $scope.$watch("bpTree.response.Welcome['TAAddressGoogle-Block'].zipCode", function (value1, value2, value3) {
            // console.log("watcher executed ZipCode", value1, value2, value3);
            $scope.updateCensusDetails();
        }, true);
        $scope.$watch('bpTree.response.Welcome.Telephone', function (value1, value2, value3) {
            // console.log("watcher executed Telephone", value1, value2, value3);
            $scope.updateCensusDetails();
        }, true);
        $scope.$watch('bpTree.response.Welcome.Email', function (value1, value2, value3) {
            // console.log("watcher executed Email", value1, value2, value3);
            $scope.updateCensusDetails();
        }, true);
        $scope.$watch('bpTree.response.myFamily.effDateEnroll', function (value1) {
            console.log("watcher executed EffdateEnroll", value1);
            $scope.getOldestMemberListForEnroll();
            $scope.isValidEffectiveDateEnroll();

        }, true);
        $scope.$watch('bpTree.response.myFamily.effDate', function (value1) {
            console.log("watcher executed effDate", value1);
            $scope.getOldestMemberListForQuote();
            $scope.isValidEffectiveDateQuote();
        }, true);


        $scope.ableToProceed=false;
        $scope.ableToProceedMessage='';

        $scope.isValidEffectiveDateQuote = function(){
            var today = new Date();
            // var today = new Date($scope.bpTree.response.testDate);
            var effDate = new Date($scope.bpTree.response.myFamily.effDate);
            effDate.setDate(effDate.getDate() + 1); //Add one day
             //console.log('isValidEffectiveDateQuote, effDate ', effDate.getDate());
             //console.log('isValidEffectiveDateQuote, today ', today.getDate());
            if((today.getDate()==29 || today.getDate()==30 || today.getDate()==31) && effDate.getDate()==1){
                 //console.log('isValidEffectiveDateQuote alert alert');
                $scope.ableToProceed=true;
                $scope.bpTree.response.DateError = 1; 
                $scope.bpTree.response.DateErrorMessage='Your membership cannot start on ' + effDate.toLocaleDateString("en-US") + '. Please select a different date';
            }else{
                $scope.bpTree.response.DateError = 0; 
                $scope.ableToProceed=false;
            }
        }

         $scope.isValidEffectiveDateEnroll = function(){
            var today = new Date();
            // var today = new Date($scope.bpTree.response.testDate);
            var effDate = new Date($scope.bpTree.response.myFamily.effDateEnroll);
            effDate.setDate(effDate.getDate() + 1); //Add one day
            // console.log('isValidEffectiveDateEnroll, effDate ', effDate.getDate());
            // console.log('isValidEffectiveDateEnroll, today ', today.getDate());
            if((today.getDate()==29 || today.getDate()==30 || today.getDate()==31) && effDate.getDate()==1){
                console.log('isValidEffectiveDateEnroll alert alert');
                $scope.ableToProceed=true;
                $scope.bpTree.response.DateErrorMessage='Your membership cannot start on ' + effDate.toLocaleDateString("en-US") + '. Please select a different date';
                $scope.bpTree.response.DateError = 1; 
            }else{
                $scope.bpTree.response.DateError = 0; 
                $scope.ableToProceed=false;
            }
        }
                
        //scenarios for the Rating Member’s birthday Month
        function calculateDiffDate(){
             if($scope.bpTree.response.ThisisQuote == true){
                 var effectiveDate = new Date($scope.bpTree.response.myFamily.effDate);
                 console.info("effective date variable quote",effectiveDate);
             }else{
                 var effectiveDate = new Date($scope.bpTree.response.myFamily.effDateEnroll);
                 console.info("effective date variable enroll",effectiveDate);
             }
             //console.info("calculateDiffDate from if:",effectiveDate);
             var oldMemberDate = new Date($scope.bpTree.response.oldestMemberList[0].dob);
             if(effectiveDate != null && oldMemberDate != null && effectiveDate != undefined && oldMemberDate != undefined){
                var resultDateYear = moment(effectiveDate).diff(oldMemberDate, 'years',false);
                //console.info("calculateDiffDate oldMemberDate1:",oldMemberDate);
                oldMemberDate.setFullYear(effectiveDate.getFullYear());
                //console.info ("Calculation oldMemberDate.setYear(effectiveDate.getYear())", effectiveDate.getFullYear());
                //console.info("calculateDiffDate effectiveDate2:",effectiveDate);
                //console.info("calculateDiffDate oldMemberDate2:",oldMemberDate);
                var resultDateDays = moment(effectiveDate).diff(oldMemberDate, 'days', false); 
                $scope.bpTree.response.resultDateDaysEffxOld = resultDateDays;
                $scope.bpTree.response.resultDateYearEffxOld = resultDateYear;
                //console.info("calculateDiffDate resultDateDatys:", resultDateDays);
                //console.info("calculateDiffDate resultDateYear:", resultDateYear);
             }
        }

        // .:: Generate oldestMemberList in "Enroll" working with calculateDiffDate() ::.
        $scope.getOldestMemberListForEnroll = function(){                
            if($scope.bpTree.response.ThisisEnroll == true){
                var editFamilyMemberList = $scope.bpTree.response.EditFamilyMember;
                console.info("editFamilyMemberList = ", editFamilyMemberList);
                maximuMemAge = Math.max(...editFamilyMemberList.map(members => members.age));
                console.info("maximuMemAge = ", maximuMemAge);
                var oldestMemberSet = editFamilyMemberList.filter(member => (member.age === maximuMemAge));
                console.info("oldestMemberSet = ", oldestMemberSet);
                var tempArray = [];
                tempArray.push(oldestMemberSet[0]);
                console.info("tempArray", tempArray);
                $scope.bpTree.response.oldestMemberList = tempArray;
                console.info("Scope Json", $scope.bpTree.response.oldestMemberList);
                var effectiveDate = new Date($scope.bpTree.response.myFamily.effDate);
                calculateDiffDate();
                console.info("pasar a funcion", calculateDiffDate);
                $scope.getradioFamilyOption();
                }
        }

        // .:: Generate oldestMemberList in "Enroll" working with calculateDiffDate() ::.
        $scope.getOldestMemberListForQuote = function(){                
            if($scope.bpTree.response.ThisisQuote == true){
                var editFamilyMemberList = $scope.bpTree.response.AddEditFamilyMember;
                //console.info("editFamilyMemberList = ", editFamilyMemberList);
                maximuMemAge = Math.max(...editFamilyMemberList.map(members => members.age));
                //console.info("maximuMemAge = ", maximuMemAge);
                var oldestMemberSet = editFamilyMemberList.filter(member => (member.age === maximuMemAge));
                //console.info("oldestMemberSet = ", oldestMemberSet);
                $scope.bpTree.response.oldestMemberList = oldestMemberSet;
                //console.info("Scope Json", $scope.bpTree.response.oldestMemberList);
                var effectiveDate = new Date($scope.bpTree.response.myFamily.effDateEnroll);
                calculateDiffDate();
                //console.info("pasar a funcion", calculateDiffDate);
                }
        }


        // temporal fix for enrollment price changes starts
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

            console.info('$scope.bpTree.response.radioFamilyOption', $scope.bpTree.response.radioFamilyOption);
            
        }
    //ends
        $scope.ethnicityResult = "";
        $scope.ethnicityUpdateDescripFunction = function(){
            $scope.ethnicityResult = "";
            $scope.bpTree.response.EditFamilyMember.forEach(function(familyMember){
                //console.info("execute fore each",familyMember);                
                var index = $scope.ethnicityAndDesc.findIndex(element => element.name == familyMember.ethnicity);
                if(index != -1 && !$scope.ethnicityResult.includes(familyMember.ethnicity) && $scope.ethnicityAndDesc[index].description != ""){//if founde
                    //console.info("found if ethnicityAndDesc", familyMember.ethnicity);
                    $scope.ethnicityResult += ($scope.ethnicityAndDesc[index].name + ':').bold() + $scope.ethnicityAndDesc[index].description + "<br>";
                }
            });
        }

}]);