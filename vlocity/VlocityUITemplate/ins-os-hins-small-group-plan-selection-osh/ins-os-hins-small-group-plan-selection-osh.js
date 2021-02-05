// $(function () {
//   $('[data-toggle="popover"]').popover()
// });

let insSgpsCustomEventName;

baseCtrl.prototype.orderProgramsBasedOnPlansOrder= function(newPlans, bpTreeResponse){
    var result = []; //Store plans based on order
    //console.log('$scope.bpTree.response.AccountProductPrivileges', bpTreeResponse.AccountProductPrivileges);
    bpTreeResponse.orderPlans[0]["Orderby"].forEach(function(productCode) { //Iterate plans order
    //console.log('productCode', productCode);
    var found = false; 
        newPlans = newPlans.filter(function(plan) {
        // console.info('plan.Name: ' , plan.Name);
            if(!found && plan["ProductCode"] == productCode) { 
                if(bpTreeResponse.AccountProductPrivileges!=undefined){
                    //console.log('producer on, plan: ', plan);
                    bpTreeResponse.AccountProductPrivileges.forEach( productPrivilege => {
                    //for each productPrivilege compare
                        if(plan.Id==productPrivilege.id && productPrivilege.selectPrivilegie=="allowed"){
                            //console.log('pushed', plan);
                            result.push(plan);
                            found = true;
                            return false;
                        }else{
                            return true;
                        }
                    });
                }else{
                    result.push(plan); //If found push it into the result array
                    found = true; //found as true in order to break the filter [for performance purposes]
                    return false; // return
                }
                //Custom producer logic ends
            } else //if not found
                return true; //go to next one
        });
    });
    return result; //sending result ordered to original array using angular utility
}

/**
 * Evaluates when the stepInitKey in the OS Set Values step changes
 * @param {Object} control Element control
 */
baseCtrl.prototype.shouldReinitTemplate = function(control) {
    //console.log('shouldReinitTemplate executed');
    const bpTreeResponse = baseCtrl.prototype.$scope.bpTree.response;
    const insSgpsKey = baseCtrl.prototype.$scope.bpTree.propSetMap.insSgpsKey;
    const insSgpsNode = bpTreeResponse[insSgpsKey];
    const stepInitKey = control.name + 'Init';
    //console.info('insSgpsNode[stepInitKey]' , insSgpsNode[stepInitKey]);
    //console.info('bpTreeResponse[stepInitKey]' , bpTreeResponse[stepInitKey]);
    if (insSgpsNode[stepInitKey] !== bpTreeResponse[stepInitKey]) {
        return true;
    }else{
        //console.log('Order Programs');
        if(control[control.name].unselectedNewPlans!=undefined){
            control[control.name].unselectedNewPlans = baseCtrl.prototype.orderProgramsBasedOnPlansOrder(control[control.name].unselectedNewPlans, bpTreeResponse);
        }
    }
};

/**
 * Triggers reinitialization of step's template, with option to reinitialize shared cart data as well
 * @param {Object} control Element control
 */
baseCtrl.prototype.reinitTemplate = function(control) {
    console.log('reinitTemplate executed');
    //baseCtrl.loading=true;
    const bpTreeResponse = baseCtrl.prototype.$scope.bpTree.response;
    const insSgpsKey = baseCtrl.prototype.$scope.bpTree.propSetMap.insSgpsKey;
    const insSgpsNode = bpTreeResponse[insSgpsKey];
    //console.info('insSgpsNode.insSgpsCartInit' , insSgpsNode.insSgpsCartInit);
    //console.info('bpTreeResponse.insSgpsCartInit' , bpTreeResponse.insSgpsCartInit);
    if (insSgpsNode.insSgpsCartInit !== bpTreeResponse.insSgpsCartInit) {
        control.cartReinit = true;
    }
    const event = new CustomEvent(insSgpsCustomEventName, {'detail': control});
    document.dispatchEvent(event);
};

vlocity.cardframework.registerModule.controller('insOsHinsSmallGroupPlanSelectionCtrl', ['$scope', '$rootScope', '$timeout', '$q', '$document', '$sldsModal', function($scope, $rootScope, $timeout, $q, $document, $sldsModal) {
    'use strict';
    const cartPageSize = 1;
    let control;
    let bpTreeResponse;
    let scp;
    let remotePageSize;
    let configvar;
    let insSgpsNode;
    $scope.selectedPlansCounter = $scope.insSgpsNode != undefined && $scope.cartCompareSelectMap!=undefined? $scope.cartCompareSelectMap.length:0;
    //**Testing start*/
    //console.log("$scope.cartCompareSelectMap",$scope.cartCompareSelectMap);
    //console.log("$scope.displayedCartPlans", $scope.displayedCartPlans);
    //console.log("$scope.unselectedNewPlans", control[control.name].unselectedNewPlans);
    /* Testing ends */
    $scope.currencyCode = '$';
    if (baseCtrl.prototype.$scope.bpTree.propSetMap.currencyCode) {
        $scope.currencyCode = baseCtrl.prototype.$scope.bpTree.propSetMap.currencyCode;
    } else if (baseCtrl.prototype.$scope.bpTree.oSCurrencySymbol) {
        $scope.currencyCode = baseCtrl.prototype.$scope.bpTree.oSCurrencySymbol;
    }
    var listOfProducts = null;
    var listOfProductsAdded = 0;
    var listOfProductsRemoved = 0;

    function reinitEventHandler(e) {
        console.log('reinitEventHandler executed');
        const control = e.detail;
        console.log('reinitEventHandler control', control);
        //$scope.loading = true;
        //baseCtrl.loading = true;
        //console.info('custom $scope.loading called for true 1');
        document.removeEventListener(insSgpsCustomEventName, reinitEventHandler);
        $scope.insSelectionInit(baseCtrl.prototype, control, control.cartReinit);
        //$scope.loading = false;
        //baseCtrl.loading = false;
        //console.info('custom $scope.loading called for false 1');
    }

    // Template initialization
    /**
     * @param {Object} baseCtrl OS baseCtrl
     * @param {Object} control Element control
     * @param {Boolean} [initializeCart] Flag when user moves back and forth from template step
     */
    $scope.insSelectionInit = function(baseCtrl, control, initializeCart) {
        //console.log('custom call for loading screen 1');
        baseCtrl.loading = true;
        $scope.loading = true;
        $rootScope.loading = true;

        // console.log('insSelectionInit executed');
        // console.log('baseCtrl', baseCtrl);
        // console.log('control', control);
        // console.log('initializeCart', initializeCart);
        insSgpsCustomEventName = 'vloc-os-ins-small-group-selection-' + control.name + Math.round((new Date()).getTime() / 1000);
        // Listens for template reinit
        //console.log('addEventListener to be executed', insSgpsCustomEventName, reinitEventHandler);
        document.addEventListener(insSgpsCustomEventName, reinitEventHandler);
        // OS dataJSON object
        bpTreeResponse = baseCtrl.$scope.bpTree.response;
        delete bpTreeResponse.lastRecordId;
        delete $scope.lastRecordId;
        // OS scope
        scp = baseCtrl.$scope;
        //console.log('insSelectionInit control', control);
        // Determines minimum number of plans that should be added to the page each time you request more
        remotePageSize = control.propSetMap.remoteOptions.pageSize;
        // This key must be defined in the OS Script Configuration JSON for the template to work
        const insSgpsKey = baseCtrl.$scope.bpTree.propSetMap.insSgpsKey;
        //console.log('baseCtrl.$scope.bpTree', baseCtrl.$scope.bpTree);

        //Testing loading animation
        //console.log('custom call for loading screen 2');
        baseCtrl.loading = true;
        $scope.loading = true;
        $rootScope.loading = true;

        // This creates a custom node in the dataJSON to track plan selections across multiple OS steps
        bpTreeResponse[insSgpsKey] = bpTreeResponse[insSgpsKey] || {};
        $scope.insSgpsNode = bpTreeResponse[insSgpsKey];
        // This key must be defined in an OS Set Values step before the template step
        $scope.insSgpsNode.insSgpsCartInit = bpTreeResponse.insSgpsCartInit;
        const stepInitKey = control.name + 'Init';
        $scope.insSgpsNode[stepInitKey] = bpTreeResponse[stepInitKey];
        $scope.selectedPlansMap = initializeCart ? {} : $scope.selectedPlansMap || {};
        $scope.cartCompareSelectMap = initializeCart ? {} : $scope.cartCompareSelectMap || {};
        // Initialize data on the first OS step this template is used
        if (!$scope.cartPlans || initializeCart) {
            $scope.cartPlans = [];
            const selectableItems = control.vlcSI[control.itemsKey];
            if (selectableItems.length) {
                // Initialization if renewal OS
                renewalInit(selectableItems);
            }
        }
        control[control.name] = {};
        formatCart(0, true);
        //console.log('custom call for loading screen 3');
        baseCtrl.loading = true;
        $scope.loading = true;
        $rootScope.loading = true;
        //console.log('custom call for loading screen 3.1');
        
        // Initial call to get available plans, wrapped in timeout so $rootScope.loading gets set after page is ready
        $timeout(function() {
            //console.log('custom call for loading screen 4');
            baseCtrl.loading = true;
            $scope.loading = true;
            $rootScope.loading = true;
            //console.log('custom call for loading screen 4.1');
            //console.info('custom $scope.loading called for true 2');
            remoteInvoke(control)
            .then(function(remoteResp) {
                console.log('insSelectionInit remoteResp', remoteResp);
                control[control.name].unselectedNewPlans = [];
                control[control.name].selectedFilters = {};
                control[control.name].filterAttrValues = remoteResp[control.name].filterAttrValues || {};
                control[control.name].filtersAvailable = _.isEmpty(control[control.name].filterAttrValues) ? false : true;
                control[control.name].newCompareSelectMap = {};
                angular.forEach(control[control.name].filterAttrValues, function(filter) {
                    filter.listOfValues = _.uniq(filter.listOfValues).sort();
                });
                const newPlans = remoteResp[control.name].listProducts;
                formatNewPlans(newPlans, control);
                dataJsonSync();
                //$scope.loading = false;
                //$rootScope.loading = false;
                //console.info('custom $scope.loading called for false 2');
            })
            .catch(angular.noop);
        }, 2000);
        //console.log('after timeout');
        // baseCtrl.loading = true;
        // $scope.loading = true;
        // $rootScope.loading = true;
    };

    // Toggles whether filters dropdown is open
    $scope.toggleMedicalFiltersDropdown = function() {
        $scope.openMedicalFilterDropdown = !$scope.openMedicalFilterDropdown;
    };

    /* Tests for price vicente martinez */
    $scope.printprice = function(plan){
        console.log("plan",plan);
    }

    /* Tests for price vicente martinez */
    $scope.updatePlanPriceOnUI = function(plan){
        //console.log("updatePlanPriceOnUI");
        //console.info("Calculated price data",plan.CalculatedPriceData);
        plan.selectedPrice = $scope.bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.Member :  $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOne :  plan.CalculatedPriceData.Family;
        // plan.selectedPrice += $scope.bpTree.response.monthlyCommissionFee;
        plan.Price = plan.selectedPrice;
        plan.selectedPriceDifference = $scope.bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.MemberDiff :  $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOneDiff :  plan.CalculatedPriceData.FamilyDiff;
        plan.PriceDifference = plan.selectedPriceDifference;
        //console.info("Diference Incoming",plan.PriceDifference,plan.Price);
        
        if(plan.Price != plan.PriceDifference){
            plan.flagDifference = true;
        }
        else{
            plan.flagDifference = false;
        }
    }

    // Toggles selected filter and makes remote call to refresh list of available products
    /**
     * @param {String} filterKey Name of filter type
     * @param {String} value User selected filter value
     */
    $scope.toggleFilter = function(filterKey, value) {
        $scope.lastResultReached = false;
        $scope.selectedFilters[filterKey] = $scope.selectedFilters[filterKey] || [];
        const valueIndex = $scope.selectedFilters[filterKey].indexOf(value);
        if (valueIndex > -1) {
            $scope.selectedFilters[filterKey].splice(valueIndex, 1);
            if (!$scope.selectedFilters[filterKey].length) {
                delete $scope.selectedFilters[filterKey];
            }
        } else {
            $scope.selectedFilters[filterKey].push(value);
        }
        if(Object.keys($scope.selectedFilters).length > 0){
            delete bpTreeResponse.lastRecordId;
        }else{
            bpTreeResponse.lastRecordId = $scope.lastRecordId;
        }
        
        remoteInvoke()
        .then(function(remoteResp) {
            console.log('toggleFilter remoteResp', remoteResp);
            control[control.name].unselectedNewPlans = [];
            const newPlans = remoteResp[control.name].listProducts.records;
            formatNewPlans(newPlans,control,false,true);
        })
        .catch(angular.noop);
    };

    $scope.recallProducts = function (plan,amount){

        $scope.loading = true;
        var ageTemp =  $scope.bpTree.response.oldestMemberList != null  ?  $scope.bpTree.response.oldestMemberList[0].age : 0 ;
        var className = '%vlocity_namespace%.IntegrationProcedureService';
        var classMethod = 'Calculation_RePrice'; 
        console.log('plan', plan); 
        console.log('amount', amount); 
        if(className && classMethod) {     
            var inputArray=[];

            var inputObject = {
                    productKey : plan.Id,
                    'MEMBER.instanceKey': "1",
                    parentProdKey : plan.Id,
                    AdditionalFees: $scope.bpTree.response.tellUsAboutYou.additionalFees,
                    AdditionalFeeMoreThan6: $scope.bpTree.response.tellUsAboutYou.formulaMoreThan6FamilyMemberAdtionalFee,
                    Program: plan.ProductCode,
                    Age: ageTemp,
                    ISA: amount,
                    State: $scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].State,
                    AccountId:''
            };
            if($scope.bpTree.response.UserType == "Producer"){
                inputObject.AccountId = $scope.bpTree.response.AgentLabel;
            }
            if($scope.bpTree.response.UserType == "Member"){
                inputObject.AccountId = $scope.bpTree.response.ServicingAgent;
            }
            if($scope.bpTree.response.UserType == "Guest"){
                inputObject.AccountId = $scope.bpTree.response.ServicingAgent;
            }
            if($scope.bpTree.response.UserType == "OSH Employee"){
                inputObject.AccountId = $scope.bpTree.response.OSHServicingAgent;
            }
            inputArray.push(inputObject);

            var input = {
                'input_1':inputArray
            };

            //console.log('recallProducts', input);
            $scope.medicalData = $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(input), '{}').then(function(result){
                //console.log('result', result);
                    var jsonParsed = JSON.parse(result);      
                    if(jsonParsed.error != "OK"){
                         alert(jsonParsed.IPResult.error);
                    }else{                  
                        $scope.medicalData = jsonParsed.IPResult.output[0].calculationResults[0];   
                        //console.log('$scope.medicalData',$scope.medicalData);   
                        //Check existance of Tobbaco members
                        if( $scope.bpTree.response.myFamily.RadioFamily == 'MySelf'){
                            plan.CalculatedPriceData.Member = $scope.medicalData.Member;
                            plan.CalculatedPriceData.MemberDiff = $scope.medicalData.MemberDiff;
                            $scope.updatePlanPriceOnUI(plan);
                        }else if( $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse'){
                            plan.CalculatedPriceData.MemberPlusOne = $scope.medicalData.MemberPlusOne;
                            plan.CalculatedPriceData.MemberPlusOneDiff = $scope.medicalData.MemberPlusOneDiff;
                            $scope.updatePlanPriceOnUI(plan);
                        }else{
                            plan.CalculatedPriceData.Family = $scope.medicalData.Family;
                            plan.CalculatedPriceData.FamilyDiff = $scope.medicalData.FamilyDiff;
                            $scope.updatePlanPriceOnUI(plan);
                        }
                        //bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.Member :  bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOne :  plan.CalculatedPriceData.Family 
                        //plan.Price = $scope.medicalData.IPResult.output;
                        //console.log('WE ENTER TO THE IP ', JSON.parse(result) );  
                    }
                   $scope.loading = false;
                  // console.log('new isa logic starts 1');
                   plan.attributeCategories.records.forEach(attCat =>{
                       if(attCat.Name=='Program Card Attributes'){
                           attCat.productAttributes.records.forEach(prodAtt =>{
                               if(prodAtt.label=='ISA Amount'){
                                   prodAtt.userValues =  amount;
                                   if(prodAtt.formattedValues!=undefined){
                                       delete prodAtt.formattedValues;
                                   }
                               }
                           });
                       }
                   });
                  // console.log('new isa logic starts 2');
                   plan.childProducts.records.forEach(childProd =>{
                       if(childProd.Name.includes('Member Responsibility')){
                           childProd.attributeCategories.records.forEach(attCategories =>{
                               if(attCategories.Name=='Level 2 Program Attributes'){
                                   attCategories.productAttributes.records.forEach(catProdAtt => {
                                       //console.log('catProdAtt', catProdAtt);
                                       if(catProdAtt.label == 'Individual Sharing Amount (ISA)'){
                                           catProdAtt.userValues = 1 * amount;
                                          // console.log('Individual Sharing Amount (ISA)', catProdAtt.userValues);
                                       }else if(catProdAtt.label == 'Individual + 1 ISA'){
                                           catProdAtt.userValues = 2 * amount;
                                          // console.log('Individual + 1 ISA', catProdAtt.userValues);
                                       }else if(catProdAtt.label == 'Family ISA'){
                                           catProdAtt.userValues = 3 * amount;
                                          // console.log('Family ISA', catProdAtt.userValues);
                                       }else if(catProdAtt.label == 'Individual Out of Pocket Max'){
                                           catProdAtt.userValues = 1 * amount * 3;
                                           //console.log('Individual Out of Pocket Max', catProdAtt.userValues);
                                       }else if(catProdAtt.label == 'Individual + 1 Out of Pocket'){
                                           catProdAtt.userValues = 2 * amount * 3;
                                          // console.log('Individual + 1 Out of Pocket', catProdAtt.userValues);
                                       }else if(catProdAtt.label == 'Family Out of Pocket'){
                                           catProdAtt.userValues = 3 * amount * 3;
                                          // console.log('Family Out of Pocket', catProdAtt.userValues);
                                       }
                                       if(catProdAtt.formattedValues!=undefined){
                                           delete catProdAtt.formattedValues;
                                        }
                                   });
                               }
                           });
                       }
                   });
                  // console.log('new isa logic ends');
                //    $scope.$apply(function () {
                //     $scope.val1 = 'tutlane.com';
                //     });
                }).catch(function(err){
                    console.info("The Error Was...", err)
                });
        }          
    };


      $scope.recallProductsForBuyUp = function (plan,buyUpValue){

        $scope.loading = true;
        var ageTemp =  $scope.bpTree.response.oldestMemberList != null  ?  $scope.bpTree.response.oldestMemberList[0].age : 0 ;
        var className = '%vlocity_namespace%.IntegrationProcedureService';
        var classMethod = 'Calculation_RePriceBuyUp';  

        if(className && classMethod) {     
            var input = {
                    AdditionalFees: $scope.bpTree.response.tellUsAboutYou.additionalFees,
                    AdditionalFeeMoreThan6: $scope.bpTree.response.tellUsAboutYou.formulaMoreThan6FamilyMemberAdtionalFee,
                    effDate: $scope.bpTree.response.myFamily.effDate,
                    radiofamilyType: $scope.bpTree.response.myFamily.RadioFamily,
                    BuyUp: 'Yes'
                    //familyType: $scope.bpTree.response.myFamily ELCHEBKOX CHEADO
            };
            $scope.medicalData = $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(input), '{}').then(function(result){
                    $scope.medicalData = JSON.parse(result);            
                    //Check existance of Tobbaco members

                    if(buyUpValue == 'Yes'){
                        if( $scope.bpTree.response.myFamily.RadioFamily == 'MySelf'){
                            plan.CalculatedPriceData.Member =   plan.CalculatedPriceData.Member + $scope.medicalData.IPResult.Price;
                            plan.CalculatedPriceData.MemberDiff =   plan.CalculatedPriceData.MemberDiff + $scope.medicalData.IPResult.PriceDifference;
                            $scope.updatePlanPriceOnUI(plan);
                        }else if( $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse'){
                            plan.CalculatedPriceData.MemberPlusOne =  plan.CalculatedPriceData.MemberPlusOne + $scope.medicalData.IPResult.Price;
                            plan.CalculatedPriceData.MemberPlusOneDiff =  plan.CalculatedPriceData.MemberPlusOneDiff + $scope.medicalData.IPResult.PriceDifference;
                            $scope.updatePlanPriceOnUI(plan);
                        }else{
                            plan.CalculatedPriceData.Family =   plan.CalculatedPriceData.Family + $scope.medicalData.IPResult.Price;
                            plan.CalculatedPriceData.FamilyDiff =   plan.CalculatedPriceData.FamilyDiff + $scope.medicalData.IPResult.PriceDifference;
                            $scope.updatePlanPriceOnUI(plan);
                            //console.log("Enter to No");
                        }
                        
                    }else{
                       
                         if( $scope.bpTree.response.myFamily.RadioFamily == 'MySelf'){
                            //console.log("on No"); 
                            plan.CalculatedPriceData.Member =   plan.CalculatedPriceData.Member - $scope.medicalData.IPResult.Price;
                            plan.CalculatedPriceData.MemberDiff =   plan.CalculatedPriceData.MemberDiff - $scope.medicalData.IPResult.PriceDifference;
                            $scope.updatePlanPriceOnUI(plan);
                        }else if( $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse'){
                            plan.CalculatedPriceData.MemberPlusOne =  plan.CalculatedPriceData.MemberPlusOne - $scope.medicalData.IPResult.Price;
                            plan.CalculatedPriceData.MemberPlusOneDiff =  plan.CalculatedPriceData.MemberPlusOneDiff - $scope.medicalData.IPResult.PriceDifference;
                            $scope.updatePlanPriceOnUI(plan);
                        }else{
                            plan.CalculatedPriceData.Family =   plan.CalculatedPriceData.Family - $scope.medicalData.IPResult.Price;
                            plan.CalculatedPriceData.FamilyDiff =   plan.CalculatedPriceData.FamilyDiff - $scope.medicalData.IPResult.PriceDifference;
                            $scope.updatePlanPriceOnUI(plan);
                        }


                    }

                    //bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.Member :  bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOne :  plan.CalculatedPriceData.Family 
                    //plan.Price = $scope.medicalData.IPResult.output;
                   // console.log('WE ENTER TO THE IP ', JSON.parse(result) );
                   $scope.loading = false;
                }).catch(function(err){
                    console.info("The Error Was...", err)
                });   
        }            
    };

    // Requests additional plans based on lastRecordId
    $scope.getMorePlans = function(control) {
        bpTreeResponse.lastRecordId = $scope.lastRecordId;
        remoteInvoke(control)
        .then(function(remoteResp) {
            //console.log('getMorePlans remoteResp', remoteResp);
            const newPlans = remoteResp[control.name].listProducts;
            formatNewPlans(newPlans,control,false);
        })
        .catch(angular.noop);
    };

    // Handle renewal plans and new plans in cart
    /**
     * @param {Object} plan Cart plan
     */
    $scope.toggleCartPlan = function(plan, control) {
        // Flag to determine whether to select or deselect
        const deselect = plan.selected;
        let newIndex = $scope.displayedCartPlans[0].originalIndex;
        plan.selected = !plan.selected;
        if (plan.renewal) {
            if (deselect) {
                // Renewal plans only get tracked if they are being deleted
                $scope.insSgpsNode.renewalPlansToDelete[plan.Id] = true;
            } else {
                // If renewal plan is selected nothing needs to be tracked
                delete $scope.insSgpsNode.renewalPlansToDelete[plan.Id];
            }
        } else if (deselect) {
            // Non-renewal plans get removed from selection map
            delete $scope.selectedPlansMap[plan.Id];
            if (!plan.multiStepSelected) {
                // If plan isn't renewal or from previous step (multiStepSelected), move back to unselected list
                $scope.cartPlans.splice(plan.originalIndex, 1);
                if(newIndex >= $scope.cartPlans.length - 1  && newIndex > 0){
                    newIndex = $scope.displayedCartPlans[0].originalIndex - 1;
                }
                formatCart(newIndex, true);
                control[control.name].unselectedNewPlans.unshift(plan);
            }
        } else {
            // This block is reached by toggling a previous step plan (new plans can only be selected with addNewPlan)
            $scope.selectedPlansMap[plan.Id] = plan;
        }
        dataJsonSync();
    };

    // Add new plan to cart
    /**
     * @param {Object} plan Selected plan
     * @param {Number} planIndex Index in displayedPlans
     */
    $scope.addNewPlan = function(plan, planIndex, control) {
        console.log('addNewPlan executed', planIndex);
        plan.selected = true;
        $scope.selectedPlansMap[plan.Id] = plan;
        control[control.name].unselectedNewPlans.splice(planIndex, 1);
        $scope.cartPlans.unshift(plan);
        formatCart(0, true);
        dataJsonSync();
    };

    // Helper method to display number of selected filters
    $scope.selectedFiltersCount = function() {
        let count = 0;
        angular.forEach($scope.selectedFilters, function(array) {
            count += array.length;
        });
        return count;
    };

    // Helper method to display filter checkbox
    /**
     * @param {String} filterKey Filter type
     * @param {String} value Filter value
     */
    $scope.isFilterSelected = function(filterKey, value) {
        if ($scope.selectedFilters[filterKey] && $scope.selectedFilters[filterKey].indexOf(value) > -1) {
            return true;
        }
    };

    // Adds plan to list for compare modal
    /**
     * @param {Object} plan Can be either a renewal or new plan
     */
    $scope.removePlan = function(control, plan) {
        if ($scope.cartCompareSelectMap[plan.Id]) {
             $scope.selectedPlansCounter-=1;
            delete $scope.cartCompareSelectMap[plan.Id];
        }
        // if (control[control.name].newCompareSelectMap[plan.Id]) {
        //      $scope.selectedPlansCounter-=1;
        //     delete control[control.name].newCompareSelectMap[plan.Id];
        //     plan.vlcCompSelected = false;
        // }
        if($scope.selectedPlansCounter<1){
             $scope.bpTree.response.selectedPlansFormulaValidateMSGNoProgram=true;
        }
       // console.info($scope.selectedPlansCounter);
    };

    $scope.addPlan = function(control, plan) {
        if (!$scope.cartCompareSelectMap[plan.Id] && $scope.selectedPlansCounter<3) {
            $scope.selectedPlansCounter+=1;
            $scope.cartCompareSelectMap[plan.Id] = plan;
        }
        // if (!control[control.name].newCompareSelectMap[plan.Id] && $scope.selectedPlansCounter<3) {
        //     $scope.selectedPlansCounter+=1;
        //     control[control.name].newCompareSelectMap[plan.Id] = plan;
        //     plan.vlcCompSelected = true;
        // }
        $scope.bpTree.response.selectedPlansFormulaValidateMSGNoProgram=false;
    };

    // verify if plan exist in list for compare modal
    /**
     * @param {Object} plan Can be either a renewal or new plan
     */
    $scope.isAddedForCompare = function(control, plan) {
        if (!$scope.cartCompareSelectMap[plan.Id]) {
            return false;
        } else {
            return true;
        }
    };

    // Gets called when clicking next/previous directional buttons at top
    /**
     * @param {String} direction Prev or Next
     */
    $scope.paginateItems = function(direction) {
        const currentIndex = $scope.displayedCartPlans[0].originalIndex;
        console.log('currentIndex', currentIndex);
        let newIndex = 0;
        if (direction === 'prev') {
            newIndex = currentIndex - cartPageSize;
        } else if (direction === 'next') {
            newIndex = currentIndex + cartPageSize;
        }
        console.log('newIndex', newIndex);
        formatCart(newIndex);
    };

    // Count how many cart plans are selected
    $scope.selectedPlansCount = function() {
        let count = 0;
        angular.forEach($scope.cartPlans, function(plan) {
            if (plan.selected) {
                count += 1;
            }
        });
        return count;
    };

    //Launch compare modal - right now it is a fixed template but this is exposed js, to-do: use OS modal template
    $scope.openCompareModal = function(plan, control, dropdowns) {
        if (plan) {
            $scope.modalRecords = [plan, plan.originalPlan.records[0]];
            $scope.isSelectable = false;
        } else {
            $scope.modalRecords = _.values($scope.cartCompareSelectMap);
            $scope.isSelectable = true;
        }
        //console.info(control.propSetMap.modalHTMLTemplateId);
        //console.info("plan",$scope.modalRecords);
        //console.info("plan",plan);
        $scope.showDropdowns = dropdowns;
        $sldsModal({
            backdrop: 'static',
            title: 'Compare Plans',
            scope: $scope,
            showLastYear: true,
            animation: true,
            templateUrl: control.propSetMap.modalHTMLTemplateId,
            show: true
        });
    };

    //Launch compare modal - right now it is a fixed template but this is exposed js, to-do: use OS modal template
    $scope.openDetailModal = function(plan, control, dropdowns) {
        $scope.modalRecords = [plan];//modalProducts = list of product and last years
        $scope.isSelectable = false;
        $scope.showDropdowns = dropdowns;
        $sldsModal({
            backdrop: 'static',
            title: 'View Details',
            scope: $scope,
            showLastYear: true,
            animation: true,
            templateUrl: control.propSetMap.modalHTMLTemplateId,
            show: true
        });
    };

    // Toggles plan selection from within compare modal
    /**
     * @param {Object} plan Can be either a renewal or new plan
     */
    $scope.toggleModalPlan = function(plan, control) {
        if (plan.selected || plan.renewal || plan.multiStepSelected) {
            console.log('plan.selected || plan.renewal || plan.multiStepSelected');
            $scope.toggleCartPlan(plan, control);
        } else {
             console.log('for');
            for (let i = 0; i < control[control.name].unselectedNewPlans.length; i++) {
                const newPlan = control[control.name].unselectedNewPlans[i];
                if (plan.Id === newPlan.Id) {
                    console.log('addnewplanmethod');
                    $scope.addNewPlan(plan, i, control);
                    break;
                }
            }
        }
    };

    /**
     * Method to know if load more programs will be shown
     */
    $scope.loadMorePlansVisible = function(){
        if (typeof(listOfProducts) !== "undefined" && listOfProducts !== null && typeof(control[control.name].unselectedNewPlans) !== "undefined" && control[control.name].unselectedNewPlans !== null) {
            // console.info("listOfProducts.length", listOfProducts.length);
            // console.info("$scope.unselectedNewPlans.length", $scope.unselectedNewPlans.length);
            // console.info("$scope.selectedPlansCounter", $scope.selectedPlansCounter);
            // console.info("listOfProductsAdded", listOfProductsAdded);
            if($scope.bpTree.response.UserType == "Producer"){ // If producer just count the number of programs(listOfProductsAdded) he/she can offer
                return listOfProductsAdded > (control[control.name].unselectedNewPlans.length + $scope.selectedPlansCounter);
            }else{ // If osh employee OR guest then use listOfProducts as they can see ALL PRODUCTS
                return listOfProducts.length > (control[control.name].unselectedNewPlans.length + $scope.selectedPlansCounter);
            }     

            //return listOfProductsRemoved +  listOfProductsAdded       
        }
    }

    // Initialize data when template is used in multiple steps
    function multistepInit() {
        $scope.cartPlans = insSgpsNode.selectedPlans;
        angular.forEach($scope.cartPlans, function(plan) {
            plan.selected = true;
            plan.multiStepSelected = true;
            $scope.selectedPlansMap[plan.Id] = plan;
        });
    }

    // Initialize data for renewal OS
    /**
    * @param {Object} selectableItems control.vlcSI[control.itemsKey]
    */
    function renewalInit(selectableItems) {
        $scope.quotedPlans = selectableItems;
        $scope.insSgpsNode.renewalPlansToDelete = {};
        angular.forEach(insSgpsNode.unselectedIds, function(id) {
            $scope.insSgpsNode.renewalPlansToDelete[id] = true;
        });
        angular.forEach($scope.quotedPlans, function(plan) {
            plan.selected = true;
            plan.renewal = true;
            setTierClass(plan);
            if ($scope.insSgpsNode.renewalPlansToDelete[plan.Id]) {
                plan.selected = false;
            }
        });
        if ($scope.cartPlans) {
            $scope.cartPlans = $scope.cartPlans.concat($scope.quotedPlans);
        } else {
            $scope.cartPlans = $scope.quotedPlans;
        }
    }

    // Set tier for default icon color
    /**
    * @param {Object} plan
    */
    function setTierClass(plan) {
        //info('setTierClass', plan);
        const name = plan.Name || plan.productName;
        if (plan[baseCtrl.prototype.$scope.nsPrefix + 'Tier__c']) {
            plan.tierClass = plan[baseCtrl.prototype.$scope.nsPrefix + 'plan.TierClass__c'].toLowerCase();
        } else if (name.toLowerCase().indexOf('gold') > -1) {
            plan.tierClass = 'gold';
        } else if (name.toLowerCase().indexOf('silver') > -1) {
            plan.tierClass = 'silver';
        } else if (name.toLowerCase().indexOf('bronze') > -1) {
            plan.tierClass = 'bronze';
        }
    };

    // Index cart items
    /**
    * @param {Number} newIndex Starting index of cart plans subset
    * @param {Boolean} [reindex] Flag to refresh original indexes
    */
    function formatCart(newIndex, reindex) {
        if (reindex) {
            angular.forEach($scope.cartPlans, function(plan, i) {
                plan.originalIndex = i;
            });
        }
        $scope.displayedCartPlans = $scope.cartPlans.slice(newIndex, newIndex + cartPageSize);
        $scope.prevDisabled = newIndex === 0 ? true : false;
        $scope.nextDisabled = newIndex + cartPageSize >= $scope.cartPlans.length ? true : false;
    }



    // Dedupes and sets tiers for new plans
    /**
     * @param {Array} newPlans Plans returned from remote method
     */
    function formatNewPlans(newPlans, control, isFirstCall, filtersUpdated) {
        const newPlansRecords = newPlans.records;
        //console.log('newPlansRecords', newPlansRecords);
        //console.log('formatNewPlans executed');
        const newLastRecordId = newPlansRecords ? newPlansRecords[newPlansRecords.length - 1].Id : null;
        //console.log("$scope.lastRecordId: "+$scope.lastRecordId);
        //console.log("newLastRecordId: "+newLastRecordId);
        if ($scope.lastRecordId === newLastRecordId) {
            console.log('last result reached');
            $scope.lastResultReached = true;
            control[control.name].lastResultReached = true;
            return;
        }
        //console.log('After if before order programs');
        try{
            //sortOnProductOrderRating(newPlans);
           // console.info('newPlans old fashion', newPlans);
            //newPlansRecords = angular.copy(orderProgramsBasedOnPlansOrder(newPlans));
           // console.info('newPlans new after being updated', newPlans);
        if(ifReverse()){
            newPlansRecords.reverse(); 
        }
        // if(isFirstCall){
        //     bpTreeResponse.bestMedicalPlans = [];
        //     for(let i=0;i<newPlans.length ;i++){
        //         if(i>1) break;
        //         newPlans[i]["bestMatch"]=true;
        //         bpTreeResponse.bestMedicalPlans[i] = newPlans[i].ProductCode;
        //     }
        // }
        // if (filtersUpdated) {
        //     for(let i=0;i<newPlans.length ;i++){
        //         if (bpTreeResponse.bestMedicalPlans.includes(newPlans[i].ProductCode))
        //             newPlans[i]["bestMatch"]=true;
        //     }
        // }
        }catch(e){}
        $scope.lastRecordId = newLastRecordId;
        control[control.name].lastRecordId = newLastRecordId;
        // console.log("before is new plan newPlans", newPlans);
        // console.log("newPlans", newPlans);
        //console.info('newPlansRecords', newPlansRecords);
        //console.info('control', control);
        //console.info('control[control.name]', control[control.name]);
        angular.forEach(newPlansRecords, function(plan) {
            var booleanpass = isNewPlan(plan);
            //console.info('booleanpass', booleanpass);
            if (booleanpass) {
                setTierClass(plan);
                control[control.name].unselectedNewPlans.push(plan);
            }else{
                //console.log("Else executed, check data");
                plan.selected=true;
                $scope.addPlan(plan);
            }
        });
        //console.log("after is new plan newPlans", newPlans);
    }

    /**
     * Method for organize the programs on quoting process - vicente martinez
     */
    function orderProgramsBasedOnPlansOrder(newPlans){
        var result = []; //Store plans based on order
        console.log('$scope.bpTree.response.AccountProductPrivileges', $scope.bpTree.response.AccountProductPrivileges);
        console.log('bpTreeResponse.orderPlans', bpTreeResponse.orderPlans);

        bpTreeResponse.orderPlans[0]["Orderby"].forEach(function(productCode) { //Iterate plans order
        console.log('productCode', productCode);
        var found = false; //beginning with found as false
            newPlans = newPlans.filter(function(plan) { //filter newPlans in order to REMOVE the plan found
           // console.info('plan.Name: ' , plan.Name);
                if(!found && plan["ProductCode"] == productCode) { //Compare based on product code
                    //Custom producer logic starts
                    //if($scope.bpTree.response.UserType == "Producer" && $scope.bpTree.response.AccountProductPrivileges!=undefined){ LINE COMMENTED ON 30/10/20 due to account product privileges
                    if($scope.bpTree.response.AccountProductPrivileges!=undefined){
                        //console.log('producer on, plan: ', plan);
                        $scope.bpTree.response.AccountProductPrivileges.forEach( productPrivilege => {
                        //for each productPrivilege compare
                            if(plan.Id==productPrivilege.id && productPrivilege.selectPrivilegie=="allowed"){
                                console.log('pushed', plan);
                                result.push(plan);
                                found = true;
                                listOfProductsAdded++;
                                return false;
                            }else{
                                listOfProductsRemoved++;
                                return true;
                            }
                        });
                    }else{
                        result.push(plan); //If found push it into the result array
                        found = true; //found as true in order to break the filter [for performance purposes]
                        listOfProductsAdded++;
                        return false; // return
                    }
                    //Custom producer logic ends
                } else //if not found
                   // console.info('plan["ProductCode"]', plan["ProductCode"]);
                    //console.info('productCode', productCode);
                    return true; //go to next one
            });
        });
        return result; //sending result ordered to original array using angular utility
    }

    // Check if new plan is already being tracked
    /**
     * @param {Object} plan
     */
    function isNewPlan(plan) {
        //console.log("isNewPlan executed", plan);
        for (let i = 0; i < $scope.cartPlans.length; i++) {
            const cartPlan = $scope.cartPlans[i];
            if (plan.Id === cartPlan.Id || plan.Id === cartPlan.productId) {
                return false;
            }
        }
        return true;
    }

    // Calls OmniScript buttonClick method, which invokes remote method defined on the Selectable Items action
    /**
     * @param {Object} control Element control} control
     */
    function remoteInvoke(control) {
        console.log('remoteInvoke executed');
        const deferred = $q.defer();
        $rootScope.loading = true;
        bpTreeResponse.attributeFilters = control[control.name].selectedFilters;
        scp.buttonClick(bpTreeResponse, control, scp, undefined, 'typeAheadSearch', undefined, function(remoteResp) {
            deferred.resolve(remoteResp);
        });
        return deferred.promise;
    }

    // Keep plan selections in sync across OS steps
    function dataJsonSync() {
        console.log('dataJsonSync');
        $scope.insSgpsNode.selectedPlans = [];
        angular.forEach($scope.selectedPlansMap, function(selectedPlan) {
            $scope.insSgpsNode.selectedPlans.push(selectedPlan);
        });
        // For renewal OS - need to track quote line item ids for deletion from quote
        // if (!_.isEmpty($scope.insSgpsNode.renewalPlansToDelete)) {
        //     insSgpsNode.unselectedIds = Object.keys($scope.insSgpsNode.renewalPlansToDelete);
        // }
    }

     $scope.existInSelected = function(plan){

         //console.log('BRUNNO AND MAURI');
         debugger;
        if( typeof $scope.bpTree.response.finalList != 'undefined' ){
            var ret = false;

            if(typeof $scope.bpTree.response.finalList.length !== 'undefined' && $scope.bpTree.response.finalList.length > 0){

                for(var i = 0 ; i < $scope.bpTree.response.finalList.length; i++){
                    if($scope.bpTree.response.finalList[i].Id == plan.Id ){
                        
                        plan.Price = $scope.bpTree.response.finalList[i].Price;
                        plan.PriceDifference = $scope.bpTree.response.finalList[i].PriceDifference;
                        ret = true;
                        break;
                    }
                }
                return ret;
            }else{
                 //console.log('$scope.bpTree.response.finalList.Id: ' , $scope.bpTree.response.finalList.Id);
                 //console.log('plan.Id: ' , plan.Id);
                 if($scope.bpTree.response.finalList.Id == plan.Id ){
                     plan.Price = $scope.bpTree.response.finalList.Price;
                     plan.PriceDifference = $scope.bpTree.response.finalList.PriceDifference;
                     return true;
                 }
            }
           
          
            return ret;
        }else{
            return false;
        }
        console.log('PLna: after' , plan);
    }

    //sort based on ProductOrder__Rating
    function sortOnProductOrderRating(newPlans){
        newPlans.sort(function(a,b){
            if(a["CalculatedPriceData"]["ProductOrder__Rating"]<b["CalculatedPriceData"]["ProductOrder__Rating"]){
                return -1;
            }else if(a["CalculatedPriceData"]["ProductOrder__Rating"]>b["CalculatedPriceData"]["ProductOrder__Rating"]){
                return 1;
            }else{
                return 0;
            }
        });
    }

    

    function ifReverse(){
        try{
        let stmAcc=$scope.bpTree.response.HelpMeShop.Questionaries.StatementAccurate;
        if(!stmAcc) return false;
        if(stmAcc==='PayLittle' || stmAcc==='PayLess'){
            return false;
        }else {
            return true;
        }
        }catch(e){
            //console.log("Error Occoured",e);
            return false;
            }
      
    }

    $scope.getNumberUnselected = function(numunsel){
        return _.range(numunsel);
    }

    
     /* Method to know if member is MA*/
    
     /*$scope.isFromMassachusettsEnvisionRX = function(obj) {
         /*if(angular.equals($scope.bpTree.response.letsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].State,'MA') && obj.userValues.includes("EnvisionRX")){
             obj.userValues = "Access to prescription drug discounts on generic and brand name drugs.";
         }
         return obj.userValues;z
     }*/
         //function to adquire the full name for plan.selectedPriceDifference
    $scope.getFullnameOSH = function(){
        if($scope.bpTree.response.oldestMemberList != null && $scope.bpTree.response.oldestMemberList != "" && $scope.bpTree.response.oldestMemberList != undefined){
            var firstname =  $scope.bpTree.response.oldestMemberList[0].fname;
            //console.info("In Firstname", firstname);
            var lastname = $scope.bpTree.response.oldestMemberList[0].lname;
            //console.info("In Lastname", lastname);
            $scope.fullName = firstname + " " +lastname;
        }
        return;
    }

   $scope.testMethod = function(control){
        console.info(control);
        console.log('worked');
    }

}]);

vlocity.cardframework.registerModule.directive('insOsDropdownHandler', function($document) {
    'use strict';
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            let isFocused = false;
            const dropdownElement = angular.element(element.find('.nds-dropdown')[0]);
            const onClick = function(event) {
                const isChild = dropdownElement.has(event.target).length > 0;
                if (!isChild) {
                    scope.$apply(attrs.insOsDropdownToggle);
                    $document.off('click', onClick);
                    isFocused = false;
                }
            };
            element.on('click', function(e) {
                if (!isFocused) {
                    e.stopPropagation();
                    scope.$apply(attrs.insOsDropdownToggle);
                    $document.on('click', onClick);
                    isFocused = true;
                }
            });
        }
    };
});