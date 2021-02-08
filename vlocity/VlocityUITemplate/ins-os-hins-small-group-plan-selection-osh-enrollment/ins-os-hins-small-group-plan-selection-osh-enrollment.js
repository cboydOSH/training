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
    $scope.selectedPlansCounter = 0;

    $scope.currencyCode = '$';
    if (baseCtrl.prototype.$scope.bpTree.propSetMap.currencyCode) {
        $scope.currencyCode = baseCtrl.prototype.$scope.bpTree.propSetMap.currencyCode;
    } else if (baseCtrl.prototype.$scope.bpTree.oSCurrencySymbol) {
        $scope.currencyCode = baseCtrl.prototype.$scope.bpTree.oSCurrencySymbol;
    }

    // Template initialization
    /**
     * @param {Object} config OmniScript objects
     */
    $scope.insSelectionInit = function(config) {
        bpTreeResponse = config.bpTreeResponse;
        control = config.control;
        scp = config.scp;
        //console.log('insSelectionInit control', control);
        
        $scope.unselectedNewPlans = [];

        if( $scope.bpTree.response.productConfigurationDetail  != null && $scope.bpTree.response.productConfigurationDetail.records ){
            $scope.unselectedNewPlans = $scope.bpTree.response.productConfigurationDetail.records;
        }
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
                //console.log('insSelectionInit remoteResp', remoteResp);
                $scope.filterAttrValues = remoteResp[control.name].filterAttrValues || {};
                $scope.filtersAvailable = _.isEmpty($scope.filterAttrValues) ? false : true;
                try{
                    //let listOfValues = [];
                    angular.forEach($scope.filterAttrValues, function(filter) {
                        // filter.listOfValues.forEach((data) => {
                        //     listOfValues.push(data.value);
                        // });         
                        filter.listOfValues = _.uniq(filter.listOfValues).sort();
                    });
                }catch(e){
                    console.log("Error occoured",e);
                }
                
                const newPlans = remoteResp[control.name].listProducts.records;
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
            //console.log('toggleFilter remoteResp', remoteResp);
            $scope.unselectedNewPlans = [];
            const newPlans = remoteResp[control.name].listProducts.records;
            formatNewPlans(newPlans,false, true);
        })
        .catch(angular.noop);
    };

    $scope.productCodeAndPrices = [];
    //   Update Price in UI and Data vicente martinez 
    $scope.updatePlanPriceOnUI = function(plan){
        // console.info('updatePlanPriceOnUI executed');
        // console.info('!plan.isCalculated', !plan.isCalculated);
        if(!plan.isCalculated){
            plan.Price = plan.Price - $scope.bpTree.response.enrollPrograms.formulaMontlhyFeeAccountvsNewIncoming;
            //plan.PriceDifference = plan.PriceDifference - $scope.bpTree.response.enrollPrograms.formulaMontlhyFeeAccountvsNewIncoming;
            plan.isCalculated = true;
        }
        if($scope.bpTree.response.productConfigurationDetail!=undefined && $scope.bpTree.response.productConfigurationDetail.records!=undefined){
            $scope.bpTree.response.productConfigurationDetail.records.forEach(
                function(element){
                    var obj = {
                        ProductCode: "",
                        Prices: {}
                    };
                    obj.ProductCode = element.ProductCode;
                    obj.Prices = JSON.parse(element.%vlocity_namespace%__CalculatedPriceJSON__c);
                    $scope.productCodeAndPrices.push(obj);

                    // console.log("element",JSON.parse(element.%vlocity_namespace%__CalculatedPriceJSON__c));
                    // console.log("Product",element.ProductCode);
                }
            );
        }
        if($scope.bpTree.response.planSelection!= undefined && $scope.bpTree.response.planSelection.selectedPlans!=undefined){
            $scope.bpTree.response.planSelection.selectedPlans.forEach(
                function(element){
                    var obj = {
                        ProductCode: "",
                        Prices: {}
                    };
                    obj.ProductCode = element.ProductCode;
                    obj.Prices = JSON.parse(element.%vlocity_namespace%__CalculatedPriceJSON__c);
                    $scope.productCodeAndPrices.push(obj);

                    // console.log("element",JSON.parse(element.%vlocity_namespace%__CalculatedPriceJSON__c));
                    // console.log("Product",element.ProductCode);
                }
            );
        }
        //console.log("It's Coming", $scope.productCodeAndPrices);
        /*else{
            plan.Price = plan.Price - $scope.bpTree.response.enrollPrograms.formulaMontlhyFeeAccountvsNewIncoming;
        }*/
        
    }

    $scope.getPriceBasedOnProductCode = function(plan){
        var index = findWithAttr($scope.productCodeAndPrices, 'ProductCode', plan.ProductCode);

        //console.log('looking for plan.ProductCode', plan.ProductCode);
        //console.log('looking in $scope.productCodeAndPrices', $scope.productCodeAndPrices);
        //console.log('index',index);
        if(index!=-1){
            console.log('$scope.bpTree.response.radioFamilyOption',$scope.bpTree.response.radioFamilyOption);
            var prices = $scope.productCodeAndPrices[index].Prices;
            if($scope.bpTree.response.radioFamilyOption=='MySelf'){
                //if($scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo180 == true || $scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo30 == true){
                    console.log("Result MemberDiff", prices.MemberDiff);
                    plan.PriceDiff = prices.MemberDiff;
                    setFlagsPriceDifference(plan);
                    return prices.MemberDiff;                     
                /*}else{
                    console.log("Return price MemberDiff",plan.Price);
                    plan.PriceDiff = plan.Price;
                    setFlagsPriceDifference(plan);
                    return plan.Price;
                }*/
            }else if($scope.bpTree.response.radioFamilyOption=='MyselfMyspouse'){
                //if($scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo180 == true || $scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo30 == true){
                    console.log("Result MemberPlusOneDiff", prices.MemberPlusOneDiff);
                    plan.PriceDiff = prices.MemberPlusOneDiff;
                    setFlagsPriceDifference(plan);
                    return prices.MemberPlusOneDiff;
                /*}else{
                    console.log("Return price MemberPlusOneDiff",plan.Price);
                    plan.PriceDiff = plan.Price;
                    setFlagsPriceDifference(plan);
                    return plan.Price;
                }*/
            }else if($scope.bpTree.response.radioFamilyOption=='MyselfandDependent'){
                //if($scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo180 == true || $scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo30 == true){
                    console.log("Result FamilyDiff", prices.FamilyDiff);
                    plan.PriceDiff = prices.FamilyDiff;
                    setFlagsPriceDifference(plan);
                    return prices.FamilyDiff;
                /*}else{
                    console.log("Return price FamilyDiff",plan.Price);
                    plan.PriceDiff = plan.Price;
                    setFlagsPriceDifference(plan);
                    return plan.Price;
                }*/
            }else if($scope.bpTree.response.radioFamilyOption=='MyselfSpouseDependents'){
                //if($scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo180 == true || $scope.bpTree.response.myFamily.FormulaConForDiplayAddInfo30 == true){
                    console.log("Result radio FamilyDiff", prices.FamilyDiff);
                    plan.PriceDiff = prices.FamilyDiff;
                    setFlagsPriceDifference(plan);
                    return prices.FamilyDiff;
                /*}else{
                    console.log("Return price radio FamilyDiff",plan.Price);
                    plan.PriceDiff = plan.Price;
                    setFlagsPriceDifference(plan);
                    return plan.Price;                    
                }*/
            }
        }else{
            return plan.Price;
        }    
    }

    $scope.recallProducts = function(plan){
        var isaAmount = 0;
        plan.attributeCategories.records[0].productAttributes.records.forEach(element => {
            if(element.code=='ISAAMT'){
                isaAmount = element.userValues;
            }
        });
        //$scope.loading = true;
        var ageTemp =  $scope.bpTree.response.oldestMemberList != null  ?  $scope.bpTree.response.oldestMemberList[0].age : 0 ;
        var className = '%vlocity_namespace%.IntegrationProcedureService';
        var classMethod = 'Calculation_RePrice'; 

        if(className && classMethod) {     
            var input = {
                    AdditionalFees: 125, //Testing only
                    AdditionalFeeMoreThan6: 0, //Testing only
                    Program: plan.ProductCode,
                    Age: ageTemp,
                    ISA: isaAmount,
                    effDate: $scope.bpTree.response.myFamily.effDateEnroll,
            };
            console.log('input', input);
            $scope.repriceData = $scope.bpService.GenericInvoke(className, classMethod, angular.toJson(input), '{}').then(function(result){
                $scope.repriceData = JSON.parse(result);     
                console.log($scope.repriceData);
                if($scope.bpTree.response.radioFamilyOption=='MySelf'){
                    console.log("Result MemberDiff", $scope.repriceData.MemberDiff);
                }else if($scope.bpTree.response.radioFamilyOption=='MyselfMyspouse'){
                    console.log("Result MemberPlusOneDiff", $scope.repriceData.MemberPlusOneDiff);
                }else if($scope.bpTree.response.radioFamilyOption=='MyselfandDependent'){
                    console.log("Result FamilyDiff", $scope.repriceData.FamilyDiff);
                }else if($scope.bpTree.response.radioFamilyOption=='MyselfSpouseDependents'){
                    console.log("Result radio FamilyDiff", $scope.repriceData.FamilyDiff);
                }
            }).catch(function(err){
                console.info("The Error Was...", err)
            });
        }          
    }


    function setFlagsPriceDifference(plan){
        if(plan.Price != plan.PriceDiff){
            plan.flagDifference = true;
        }
        else{
            plan.flagDifference = false;
        }
    } 

    function findWithAttr(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    $scope.recallProductsForBuyUp = function (plan,buyUpValue){

        $scope.loading = true;
        var ageTemp =  $scope.bpTree.response.oldestMemberList != null  ?  $scope.bpTree.response.oldestMemberList[0].age : 0 ;
        var className = '%vlocity_namespace%.IntegrationProcedureService';
        var classMethod = 'Calculation_RePriceBuyUp';  

        if(className && classMethod) {     
            var input = {
                    
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
                        }else if( $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse'){
                            plan.CalculatedPriceData.MemberPlusOne =  plan.CalculatedPriceData.MemberPlusOne + $scope.medicalData.IPResult.Price;
                        }else{
                            plan.CalculatedPriceData.Family =   plan.CalculatedPriceData.Family + $scope.medicalData.IPResult.Price;
                            //console.log("Enter to No");
                        }
                        
                    }else{
                       
                         if( $scope.bpTree.response.myFamily.RadioFamily == 'MySelf'){
                            //console.log("on No"); plan.CalculatedPriceData.Member =   plan.CalculatedPriceData.Member - $scope.medicalData.IPResult.Price;
                        }else if( $scope.bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse'){
                            plan.CalculatedPriceData.MemberPlusOne =  plan.CalculatedPriceData.MemberPlusOne - $scope.medicalData.IPResult.Price;
                        }else{
                            plan.CalculatedPriceData.Family =   plan.CalculatedPriceData.Family - $scope.medicalData.IPResult.Price;
                        }
                    }
                    //bpTree.response.myFamily.RadioFamily == 'MySelf' ? plan.CalculatedPriceData.Member :  bpTree.response.myFamily.RadioFamily == 'MyselfMyspouse' ? plan.CalculatedPriceData.MemberPlusOne :  plan.CalculatedPriceData.Family 
                    //plan.Price = $scope.medicalData.IPResult.output;
                    //console.log('WE ENTER TO THE IP ', JSON.parse(result) );
                   $scope.loading = false;
                }).catch(function(err){
                    console.info("The Error Was...", err);
                });   
        }            
    };

    // Requests additional plans based on lastRecordId
    $scope.getMorePlans = function() {
        bpTreeResponse.lastRecordId = $scope.lastRecordId;
        remoteInvoke()
        .then(function(remoteResp) {
            console.log('getMorePlans remoteResp', remoteResp);
            const newPlans = remoteResp[control.name].listProducts.records;
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
        //console.info("toggleCartPlan::deselect", deselect);
        let newIndex = $scope.displayedCartPlans[0].originalIndex;
        //console.info("toggleCartPlan::newIndex", newIndex);
        plan.selected = !plan.selected;
        //console.info("toggleCartPlan::plan.selected", plan.selected);
        //console.info("plan: ", plan);
        if (plan.renewal) {
            //console.info("plan.renewal true");
            if (deselect) {
                //console.info("1");
                // Renewal plans only get tracked if they are being deleted
                $scope.renewalPlansToDelete[plan.Id] = true;
            } else {
                //console.info("2");
                // If renewal plan is selected nothing needs to be tracked
                delete $scope.renewalPlansToDelete[plan.Id];
            }
        } else if (deselect) {
            //console.info("deselected");
            // Non-renewal plans get removed from selection map
            delete $scope.selectedPlansMap[plan.Id];
            //console.info("plan was deleted");
            if (!plan.multiStepSelected) {
                //console.info("is not multiselected");
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
            // console.info("don't know");
            $scope.selectedPlansMap[plan.Id] = plan;
        }
        dataJsonSync();
    };

    // Add new plan to cart
    // Modified by Vicente Martinez
    /**
     * @param {Object} plan Selected plan
     * @param {Number} planIndex Index in displayedPlans
     */
    $scope.addNewPlan = function(plan, planIndex) {
        //console.info("addNewPlan: ", plan, planIndex);
        plan.selected = true;
        //console.info("selected: ", plan);
        //console.info("before adding plan ", $scope.selectedPlansMap);
        $scope.selectedPlansMap[plan.Id] = plan;
        //console.info("after adding plan ", $scope.selectedPlansMap);
        //console.info("before splice unSelectedPlans ", $scope.unselectedNewPlans);
        $scope.unselectedNewPlans.splice(planIndex, 1);
        //console.info("after splice unSelectedPlans ", $scope.unselectedNewPlans);
        $scope.cartPlans.unshift(plan);
        formatCart(0, true);
    };

    /**
     * Method for available plans counter considering the ones selected in quoting process
     */
    $scope.contSelectedPlansOnQuoteAvaliables = function(){
        //return the substraction of selected plans on quote process and actual plan selected
        var counter=0;
        //console.info("$scope.unselectedNewPlans",$scope.unselectedNewPlans);
        //console.info("scope.bpTree.response.finalList",scope.bpTree.response.finalList);
        $scope.unselectedNewPlans.forEach((unSelectedPlan)=>{
           // console.info("unSelectedPlan", unSelectedPlan);
           if($scope.bpTree.response.finalList !== ""){
               $scope.bpTree.response.finalList.forEach((selectedPlanOnQuote)=>{
                    //console.info("selectedPlanOnQuote", selectedPlanOnQuote);
                    if(unSelectedPlan.Id==selectedPlanOnQuote.Id){
                        //console.info("They are equal", unSelectedPlan, selectedPlanOnQuote);
                        counter++;
                    }
                });
           }
        });
        //console.info("ending process: ");
        return counter; //$scope.bpTree.response.finalList.length - $scope.selectedPlansCount();
    }

    /**
     * Method to know if load more programs will be shown
     */
    $scope.loadMorePlansVisible = function(){
        return control.propSetMap.remoteOptions.pageSize < $scope.contSelectedPlansOnQuoteAvaliables();
    }

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
        //console.info($scope.selectedPlansCounter);
    };

    $scope.addPlan = function(plan) {
        if (!$scope.compareSelectMap[plan.Id] && $scope.selectedPlansCounter<3) {
            $scope.selectedPlansCounter+=1;
            $scope.compareSelectMap[plan.Id] = plan;
        }
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
        //console.info("toggleModalPlan called");
        // console.info("toggleModalPlan called", plan);
        if (plan.selected || plan.renewal || plan.multiStepSelected) {
            //console.info("First If of togglemodalplan - REMOVING");
            $scope.bpTree.response.enrollPrograms.ValidationText='';
            $scope.bpTree.response.selectedPlansFormulaValidateMSG=true;
            plan.multiStepSelected=false;
            $scope.updatePlanPriceOnUI(plan,false);
            $scope.toggleCartPlan(plan);
        } else {
            if(Object.keys($scope.selectedPlansMap).length == 0){
                //console.info("First else of togglemodalplan - ADDING");
                $scope.bpTree.response.enrollPrograms.ValidationText='validationtext';
                for (let i = 0; i < $scope.unselectedNewPlans.length; i++) {
                    const newPlan = $scope.unselectedNewPlans[i];
                    if (plan.Id === newPlan.Id) {
                        $scope.bpTree.response.selectedPlansFormulaValidateMSG=false;
                        $scope.updatePlanPriceOnUI(plan,true);
                        $scope.addNewPlan(plan, i);
                        dataJsonSync();
                        break;
                    }
                }
            }else{
                var confirmed = confirm('Do you want to replace your plan?'), interval = setInterval(function() {
                    if(confirmed === true || confirmed.$$state.status) {
                        clearInterval(interval);
                        if(confirmed === true || confirmed.$$state.value) {
                           // console.log("said yes, this is the selected plans map: ",$scope.selectedPlansMap);
                            $scope.bpTree.response.enrollPrograms.ValidationText='validationtext';
                            angular.forEach($scope.selectedPlansMap, function(selectedPlan) {
                                //console.log("looked for selected plans: ",selectedPlan);
                                selectedPlan.selected=true; 
                                selectedPlan.multiStepSelected=false;
                                $scope.updatePlanPriceOnUI(plan,false);
                                $scope.toggleCartPlan(selectedPlan);
                            });
                                //console.info("$scope.unselectedNewPlans: ",$scope.unselectedNewPlans);
                            for (let i = 0; i < $scope.unselectedNewPlans.length; i++) {
                                const newPlan = $scope.unselectedNewPlans[i];
                                if (plan.Id === newPlan.Id) {
                                   // console.info("plan to add: ", newPlan);
                                    //console.info("plan found on unselectedNewPlans", newPlan);
                                    $scope.bpTree.response.selectedPlansFormulaValidateMSG=false;
                                    $scope.updatePlanPriceOnUI(plan,true);
                                    $scope.addNewPlan(plan, i);
                                    dataJsonSync();
                                    break;
                                }
                            }
                        }
                    }
                }, 200);
            }
        }
    };

    /**
     * Method to know if member is MA
     
     $scope.isFromMassachusettsEnvisionRX = function(obj) {
         if(angular.equals($scope.bpTree.response.Welcome.State,'MA') && obj.userValues.includes("EnvisionRX")){
             obj.userValues = "Access to prescription drug discounts on generic and brand name drugs.";
         }
         return obj.userValues;
     }*/
     

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
    function formatNewPlans(newPlans,isFirstCall, filtersUpdated) {
        const newLastRecordId = newPlans[newPlans.length - 1].Id;
        if ($scope.lastRecordId === newLastRecordId) {
            //console.log('last result reached');
            $scope.lastResultReached = true;
            return;
        }
        try{
            sortOnProductOrderRating(newPlans);
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

        angular.forEach(newPlans, function(plan) {
            if (isNewPlan(plan)) {
                setTierClass(plan);
                $scope.unselectedNewPlans.push(plan);
            }
        });
    }

    // Check if new plan is already being tracked
    /**
     * @param {Object} plan
     */
    function isNewPlan(plan) {
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
            //console.log("control",control);
            //console.log("scp",scp);
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
        if( typeof $scope.bpTree.response.finalList != 'undefined' ){
            var ret = false;
            if(typeof $scope.bpTree.response.finalList.length !== 'undefined' && $scope.bpTree.response.finalList.length > 0){
                for(var i = 0 ; i < $scope.bpTree.response.finalList.length; i++){
                    if($scope.bpTree.response.finalList[i].Id == plan.Id ){
                       plan.Price = $scope.bpTree.response.finalList[i].Price;
                       //plan.PriceDifference = $scope.bpTree.response.finalList[i].PriceDifference;
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
                     //plan.PriceDifference = $scope.bpTree.response.finalList.PriceDifference;
                     return true;
                 }
            }
            return ret;
        }else{
            return false;
        }
        //console.log('PLna: after' , plan);
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
    $scope.fullName = '';

    $scope.getFullnameOSH = function(){
        if($scope.bpTree.response.oldestMemberList != null && $scope.bpTree.response.oldestMemberList != "" && $scope.bpTree.response.oldestMemberList != undefined){
            var firstname =  $scope.bpTree.response.oldestMemberList[0].fname;
            console.info("In Firstname", firstname);
            var lastname = $scope.bpTree.response.oldestMemberList[0].lname;
            console.info("In Lastname", lastname);
            $scope.fullName = firstname + " " +lastname; 
        }
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