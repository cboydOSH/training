// $(function () {
//   $('[data-toggle="popover"]').popover()
// });

let insSgpsCustomEventName = 'vloc-os-ins-small-group-plan-selection-' + Math.round((new Date()).getTime() / 1000);
let insSgpsLoadedOnce = false;
// Called when template loads
/**
 * @param {Object} bpTree baseCtrl.$scope.bpTree
 * @param {Object} control Element control
 * @param {Object} scp Element scope
 */
baseCtrl.prototype.setSmallGroupPlans = function(bpTree, control, scp) {
    const event = new CustomEvent(insSgpsCustomEventName, {
        detail: {
            bpTreeResponse: bpTree.response,
            insSgpsKey: bpTree.propSetMap.insSgpsKey,
            control: control,
            scp: scp
        }
    });
    document.dispatchEvent(event);
};

vlocity.cardframework.registerModule.controller('insOsHinsSmallGroupPlanSelectionCtrl', ['$scope', '$rootScope', '$timeout', '$q', '$document', '$sldsModal', function($scope, $rootScope, $timeout, $q, $document, $sldsModal) {
    'use strict';
    $document.on(insSgpsCustomEventName, function(e) {
        $scope.insSelectionInit(e.detail);
    });
    
    $scope.callInit=function(){
         console.log("Init is called");
    }
    const cartPageSize = 1;
    let control;
    let bpTreeResponse;
    let scp;
    let insSgpsNode;
    $scope.selectedPlansCounter = $scope.compareSelectMap != undefined? $scope.compareSelectMap.length:0;
    //**Testing start*/
    console.log("$scope.compareSelectMap",$scope.compareSelectMap);
    console.log("$scope.displayedCartPlans", $scope.displayedCartPlans);
    console.log("$scope.unselectedNewPlans", $scope.unselectedNewPlans);
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

    // Template initialization
    /**
     * @param {Object} config OmniScript objects
     */
    $scope.insSelectionInit = function(config) {
        bpTreeResponse = config.bpTreeResponse;
        control = config.control;
        scp = config.scp;
        console.log('insSelectionInit control', control);
        
        $scope.unselectedNewPlans = [];
        $scope.cartPlans = [];
        $scope.selectedPlansMap = {};
        $scope.selectedFilters = {};
        // Used by the remote method to apply selected filters
        bpTreeResponse.attributeFilters = $scope.selectedFilters;
        $scope.compareSelectMap = {};
        // This is defined in the OS Script Configuration JSON
        //const insSgpsKey = config.insSgpsKey;
        const insSgpsKey = 'planSelection';
        // This creates a special node in the dataJSON to track plan selections across multiple OS steps
        bpTreeResponse[insSgpsKey] = bpTreeResponse[insSgpsKey] || {};
        insSgpsNode = bpTreeResponse[insSgpsKey];
        if (insSgpsNode.selectedPlans) {
            // Initialization for multistep OS
            multistepInit();
        }
        const selectableItems = control.vlcSI[control.itemsKey];
        if (selectableItems.length) {
            // Initialization for renewal OS
            renewalInit(selectableItems);
        }
        $scope.collapsedCart = false;
        formatCart(0, true);
        // Initial call to get available plans, wrapped in timeout so $rootScope.loading gets set after page is ready
        $timeout(function() {
            remoteInvoke()
            .then(function(remoteResp) {
                console.log('insSelectionInit remoteResp', remoteResp);
                $scope.filterAttrValues = remoteResp[control.name].filterAttrValues || {};
                $scope.filtersAvailable = _.isEmpty($scope.filterAttrValues) ? false : true;
                try{
                    //let listOfValues = [];
                    angular.forEach($scope.filterAttrValues, function(filter) {
                        // filter.listOfValues.forEach((data) => {
                        //     listOfValues.push(data.value);
                        // }); 
                        filter.listOfValues = _.uniq(filter.listOfValues).sort();
                        if(angular.equals(filter.attributeName,"Program Code")){
                            console.log("testing testing 2: ",filter.listOfValues);
                            listOfProducts = filter.listOfValues;
                        }
                    });
                }catch(e){
                    console.log("Error occoured",e);
                }
                
                const newPlans = remoteResp[control.name].ratedProducts.records;
                console.log('newPlans', newPlans);
                formatNewPlans(newPlans,true);
                dataJsonSync();
            })
            .catch(angular.noop);
        });
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
        console.log("updatePlanPriceOnUI");
        console.info("Calculated price data",plan.CalculatedPriceData);
        plan.selectedPrice = $scope.bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.Member :  $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOne :  plan.CalculatedPriceData.Family;
        // plan.selectedPrice += $scope.bpTree.response.monthlyCommissionFee;
        plan.Price = plan.selectedPrice;
        plan.selectedPriceDifference = $scope.bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.MemberDiff :  $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOneDiff :  plan.CalculatedPriceData.FamilyDiff;
        plan.PriceDifference = plan.selectedPriceDifference;
        console.info("Diference Incoming",plan.PriceDifference,plan.Price);
        
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
            $scope.unselectedNewPlans = [];
            const newPlans = remoteResp[control.name].ratedProducts.records;
            formatNewPlans(newPlans,false, true);
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
    $scope.getMorePlans = function() {
        bpTreeResponse.lastRecordId = $scope.lastRecordId;
        remoteInvoke()
        .then(function(remoteResp) {
            //console.log('getMorePlans remoteResp', remoteResp);
            const newPlans = remoteResp[control.name].ratedProducts.records;
            formatNewPlans(newPlans,false);
        })
        .catch(angular.noop);
    };

    // Handle renewal plans and new plans in cart
    /**
     * @param {Object} plan Cart plan
     */
    $scope.toggleCartPlan = function(plan) {
        // Flag to determine whether to select or deselect
        const deselect = plan.selected;
        let newIndex = $scope.displayedCartPlans[0].originalIndex;
        plan.selected = !plan.selected;
        if (plan.renewal) {
            if (deselect) {
                // Renewal plans only get tracked if they are being deleted
                $scope.renewalPlansToDelete[plan.Id] = true;
            } else {
                // If renewal plan is selected nothing needs to be tracked
                delete $scope.renewalPlansToDelete[plan.Id];
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
                $scope.unselectedNewPlans.unshift(plan);
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
    $scope.addNewPlan = function(plan, planIndex) {
        plan.selected = true;
        $scope.selectedPlansMap[plan.Id] = plan;
        $scope.unselectedNewPlans.splice(planIndex, 1);
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
    $scope.removePlan = function(plan) {
        if ($scope.compareSelectMap[plan.Id]) {
             $scope.selectedPlansCounter-=1;
            delete $scope.compareSelectMap[plan.Id];
        }
        if($scope.selectedPlansCounter<1){
             $scope.bpTree.response.selectedPlansFormulaValidateMSGNoProgram=true;
        }
       // console.info($scope.selectedPlansCounter);
    };

    $scope.addPlan = function(plan) {
        if (!$scope.compareSelectMap[plan.Id] && $scope.selectedPlansCounter<3) {
            $scope.selectedPlansCounter+=1;
            $scope.compareSelectMap[plan.Id] = plan;
        }
        $scope.bpTree.response.selectedPlansFormulaValidateMSGNoProgram=false;
       // console.info($scope.selectedPlansCounter);
    };

    // verify if plan exist in list for compare modal
    /**
     * @param {Object} plan Can be either a renewal or new plan
     */
    $scope.isAddedForCompare = function(plan) {
        if (!$scope.compareSelectMap[plan.Id]) {
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
        let newIndex = 0;
        if (direction === 'prev') {
            newIndex = currentIndex - cartPageSize;
        } else if (direction === 'next') {
            newIndex = currentIndex + cartPageSize;
        }
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
    $scope.openCompareModal = function(plan) {
        if (plan) {
            $scope.modalRecords = [plan, plan.originalPlan.records[0]];
            $scope.isSelectable = false;
        } else {
            $scope.modalRecords = _.values($scope.compareSelectMap);
            $scope.isSelectable = true;
        }
        //console.info(control.propSetMap.modalHTMLTemplateId);
        //console.info("plan",$scope.modalRecords);
        //console.info("plan",plan);
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
    $scope.openDetailModal = function(plan) {
        $scope.modalRecords = [plan];//modalProducts = list of product and last years
        $scope.isSelectable = false;
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
    $scope.toggleModalPlan = function(plan) {
        if (plan.selected || plan.renewal || plan.multiStepSelected) {
            $scope.toggleCartPlan(plan);
        } else {
            for (let i = 0; i < $scope.unselectedNewPlans.length; i++) {
                const newPlan = $scope.unselectedNewPlans[i];
                if (plan.Id === newPlan.Id) {
                    $scope.addNewPlan(plan, i);
                    break;
                }
            }
        }
    };

    /**
     * Method to know if load more programs will be shown
     */
    $scope.loadMorePlansVisible = function(){
        if (typeof(listOfProducts) !== "undefined" && listOfProducts !== null && typeof($scope.unselectedNewPlans) !== "undefined" && $scope.unselectedNewPlans !== null) {
            // console.info("listOfProducts.length", listOfProducts.length);
            // console.info("$scope.unselectedNewPlans.length", $scope.unselectedNewPlans.length);
            // console.info("$scope.selectedPlansCounter", $scope.selectedPlansCounter);
            // console.info("listOfProductsAdded", listOfProductsAdded);
            if($scope.bpTree.response.UserType == "Producer"){ // If producer just count the number of programs(listOfProductsAdded) he/she can offer
                return listOfProductsAdded > ($scope.unselectedNewPlans.length + $scope.selectedPlansCounter);
            }else{ // If osh employee OR guest then use listOfProducts as they can see ALL PRODUCTS
                return listOfProducts.length > ($scope.unselectedNewPlans.length + $scope.selectedPlansCounter);
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
        $scope.renewalPlansToDelete = {};
        angular.forEach(insSgpsNode.unselectedIds, function(id) {
            $scope.renewalPlansToDelete[id] = true;
        });
        angular.forEach($scope.quotedPlans, function(plan) {
            plan.selected = true;
            plan.renewal = true;
            setTierClass(plan);
            if ($scope.renewalPlansToDelete[plan.Id]) {
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
       // console.log("formatCart executed");
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
    function formatNewPlans(newPlans,isFirstCall, filtersUpdated) {
        const newLastRecordId = newPlans[newPlans.length - 1].Id;
        //console.info("$scope.lastRecordId: "+$scope.lastRecordId);
       // console.info("newLastRecordId: "+newLastRecordId);
        if ($scope.lastRecordId === newLastRecordId) {
            console.log('last result reached');
            $scope.lastResultReached = true;
            return;
        }
        try{
            //sortOnProductOrderRating(newPlans);
           // console.info('newPlans old fashion', newPlans);
            newPlans = angular.copy(orderProgramsBasedOnPlansOrder(newPlans));
           // console.info('newPlans new after being updated', newPlans);
        if(ifReverse()){
            newPlans.reverse(); 
        }
        if(isFirstCall){
            bpTreeResponse.bestMedicalPlans = [];
            for(let i=0;i<newPlans.length ;i++){
                if(i>1) break;
                newPlans[i]["bestMatch"]=true;
                bpTreeResponse.bestMedicalPlans[i] = newPlans[i].ProductCode;
            }
        }
        if (filtersUpdated) {
            for(let i=0;i<newPlans.length ;i++){
                if (bpTreeResponse.bestMedicalPlans.includes(newPlans[i].ProductCode))
                    newPlans[i]["bestMatch"]=true;
            }
        }
        }catch(e){}
        $scope.lastRecordId = newLastRecordId;
        // console.log("before is new plan newPlans", newPlans);
        // console.log("newPlans", newPlans);
        angular.forEach(newPlans, function(plan) {
            if (isNewPlan(plan)) {
                setTierClass(plan);
                $scope.unselectedNewPlans.push(plan);
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
        console.log("isNewPlan executed", plan);
        for (let i = 0; i < $scope.cartPlans.length; i++) {
            const cartPlan = $scope.cartPlans[i];
            if (plan.Id === cartPlan.Id || plan.Id === cartPlan.productId) {
                return false;
            }
        }
        return true;
    }

    // Calls OmniScript buttonClick method, which invokes remote method defined on the Selectable Items action
    function remoteInvoke() {
        const deferred = $q.defer();
        $rootScope.loading = true;
        
        if (control.name.includes('Medical') || control.name.includes('Dental')){
            bpTreeResponse.userInputs = undefined; 
        }
        
        scp.buttonClick(bpTreeResponse, control, scp, undefined, 'typeAheadSearch', undefined, function(remoteResp) {
            deferred.resolve(remoteResp);
        });
        return deferred.promise;
    }

    // Keep plan selections in sync across OS steps
    function dataJsonSync() {
        insSgpsNode.selectedPlans = [];
        angular.forEach($scope.selectedPlansMap, function(selectedPlan) {
            insSgpsNode.selectedPlans.push(selectedPlan);
        });
        // For renewal OS - need to track quote line item ids for deletion from quote
        if (!_.isEmpty($scope.renewalPlansToDelete)) {
            insSgpsNode.unselectedIds = Object.keys($scope.renewalPlansToDelete);
        }
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
            console.log("Error Occoured",e);
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
            console.info("In Firstname", firstname);
            var lastname = $scope.bpTree.response.oldestMemberList[0].lname;
            console.info("In Lastname", lastname);
            $scope.fullName = firstname + " " +lastname;
        }
        return;
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