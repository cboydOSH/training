vlocity.cardframework.registerModule.controller('oshControllerBillingInformation', ['$scope', function($scope) {

        $scope.$watch("bpTree.response.bill.formulaCompareTodayvsEffdate", function(){
                if($scope.bpTree.response.bill!= undefined && $scope.bpTree.response.bill.formulaCompareTodayvsEffdate!=undefined && $scope.bpTree.response.bill.formulaCompareTodayvsEffdate!=''){
                        // console.log('initiating init for billing dates from watcher');
                        $scope.initBillingDates();
                }
        });

        $scope.initBillingDates = function () {
                console.log('init executed for billing dates');
                if($scope.bpTree.response.bill.billingDatePlan!= undefined && $scope.bpTree.response.bill.billingDatePlan!= ''){
                        var billingDateArray =  $scope.bpTree.response.bill.billingDatePlan.split('-');
                        var billingDate = $scope.getDate(parseInt(billingDateArray[0]), parseInt(billingDateArray[1])-1, parseInt(billingDateArray[2]));
                        var firstContributionMaxDate = new Date();
                        firstContributionMaxDate.setDate(firstContributionMaxDate.getDate() + parseInt($scope.bpTree.response.bill.formulaCompareTodayvsEffdate));
                        var today = new Date();
                        if(today <= billingDate && billingDate<firstContributionMaxDate){

                        }else{
                                $scope.bpTree.response.bill.billingDatePlan = '';
                                $scope.bpTree.response.bill.customBillingDateAppFee = '';
                        }
                }
        }
    
        $scope.Math = window.Math;
        $scope.emptyPromotion = { 'Coupon': 'No Selection', 'ShortDescription': '', 'Recurrency': 'Never'};
        $scope.bpTree.response.selectedOneTimeApplicationDiscount = {};
        $scope.bpTree.response.selectedMonthlyContributionDiscount = {};
        $scope.oneTimeDiscounts=[];
        $scope.monthlyDiscounts=[];
        $scope.bpTree.response.selectedPlan='';
        $scope.bpTree.response.manualCoupon='';
        

        $scope.$watch("bpTree.response.ApplicablePromotions", function(){ 
                if($scope.bpTree.response.ApplicablePromotions!= undefined && $scope.bpTree.response.ApplicablePromotions!= []){
                        //console.log('watcher executed for applicable promotions', $scope.bpTree.response.ApplicablePromotions); 
                }
                if($scope.bpTree.response.planSelection!= undefined && $scope.bpTree.response.selectedPlan!=$scope.bpTree.response.planSelection.selectedPlans[0].Id){
                        //console.log('$scope.bpTree.response.selectedPlan', $scope.bpTree.response.selectedPlan);
                        //console.log('$scope.bpTree.response.planSelection.selectedPlans[0].Id', $scope.bpTree.response.planSelection.selectedPlans[0].Id);
                        $scope.initializePromotions();
                }else{
                        //console.log('there was no change, yuju');
                } 
        });

        $scope.initializePromotions = function () {
                console.log('initializePromotions');
                $scope.bpTree.response.selectedOneTimeApplicationDiscount = $scope.emptyPromotion;
                $scope.bpTree.response.selectedMonthlyContributionDiscount = $scope.emptyPromotion;
                $scope.oneTimeDiscounts=[];
                $scope.monthlyDiscounts=[];
                console.log('initializePromotions starting');
                if($scope.bpTree.response.ApplicablePromotions!= undefined && $scope.bpTree.response.ApplicablePromotions!= []){
                        $scope.oneTimeDiscounts.push($scope.emptyPromotion);
                        $scope.monthlyDiscounts.push($scope.emptyPromotion);
                        $scope.bpTree.response.ApplicablePromotions.forEach(promotion => {
                                //console.log(promotion);
                                if(promotion.ApplicableItem =='One Time Application Fee'){
                                        $scope.oneTimeDiscounts.push(promotion);
                                }else if (promotion.ApplicableItem =='Monthly Contribution'){
                                        $scope.monthlyDiscounts.push(promotion);
                                }
                       }); 
                }
        }

        $scope.selectPlan = function(){
                console.log('selected plan: ', $scope.bpTree.response.planSelection.selectedPlans[0].Id);
                $scope.bpTree.response.selectedPlan = $scope.bpTree.response.planSelection.selectedPlans[0].Id;
        }

        $scope.addCoupon = function(){
                var added=false;
                if($scope.bpTree.response.manualCoupon!=''){
                        if($scope.bpTree.response.ApplicablePromotions!= undefined && $scope.bpTree.response.ApplicablePromotions!= []){
                                $scope.bpTree.response.ApplicablePromotions.forEach(promotion => {
                                        // console.log('promotion', promotion);
                                        // console.log('$scope.bpTree.response.manualCoupon', $scope.bpTree.response.manualCoupon);
                                        // console.log('$scope.bpTree.response.selectedOneTimeApplicationDiscount', $scope.bpTree.response.selectedOneTimeApplicationDiscount);
                                        // console.log('$scope.emptyPromotion', $scope.emptyPromotion);
                                        if($scope.bpTree.response.manualCoupon === promotion.Coupon){
                                                if(promotion.ApplicableItem =='One Time Application Fee'){
                                                        if($scope.bpTree.response.selectedOneTimeApplicationDiscount.Coupon!=$scope.emptyPromotion.Coupon){
                                                                var message = "You can only use one coupon per applicable item. Do you want to replace the current one?";
                                                                added=true;
                                                                var confirmed = confirm(message), interval = setInterval(function() {
                                                                        if(confirmed === true || confirmed.$$state.status) {
                                                                                clearInterval(interval);
                                                                                if(confirmed === true || confirmed.$$state.value) {
                                                                                        $scope.selectPlan();
                                                                                        $scope.bpTree.response.selectedOneTimeApplicationDiscount =  promotion;
                                                                                }
                                                                        }
                                                                }, 200);
                                                        }else{
                                                                $scope.selectPlan();
                                                                $scope.bpTree.response.selectedOneTimeApplicationDiscount =  promotion;
                                                                added=true;
                                                        }
                                                }else if (promotion.ApplicableItem =='Monthly Contribution'){
                                                        if($scope.bpTree.response.selectedMonthlyContributionDiscount.Coupon!=$scope.emptyPromotion.Coupon){
                                                                var message = "You can only use one coupon per applicable item. Do you want to replace the current one?";
                                                                added=true;
                                                                var confirmed = confirm(message), interval = setInterval(function() {
                                                                        if(confirmed === true || confirmed.$$state.status) {
                                                                                clearInterval(interval);
                                                                                if(confirmed === true || confirmed.$$state.value) {
                                                                                        $scope.selectPlan();
                                                                                        $scope.bpTree.response.selectedMonthlyContributionDiscount =  promotion;
                                                                                }
                                                                        }
                                                                }, 200);
                                                        }else{
                                                                $scope.selectPlan();
                                                                $scope.bpTree.response.selectedMonthlyContributionDiscount =  promotion;
                                                                added=true;
                                                        }
                                                }
                                        }
                                });
                        }
                        if(!added){
                                alert('The coupon you have entered does not exist');
                        }
                }else{
                        alert('Your coupon is empty!');
                }
        }

        $scope.print = function(){
                console.log('selectedOneTimeApplicationDiscount', $scope.bpTree.response.selectedOneTimeApplicationDiscount);
                console.log('selectedMonthlyContributionDiscount', $scope.bpTree.response.selectedMonthlyContributionDiscount);
        }

        $scope.dateChange = function(){
                //Stablish Min date, min date if same as effective date plus one month because is the next payment
                $scope.dateMinInScope = $scope.bpTree.response.myFamily.effDateEnroll;
                var effectiveDateArray =  $scope.bpTree.response.myFamily.effDateEnroll.split('-');

                //Stablish MAX date for date picker
                var effDateEnrollArray = $scope.bpTree.response.myFamily.effDateEnroll.split('-');
                var maxDate =$scope.getDate(parseInt(effDateEnrollArray[0]), parseInt(effDateEnrollArray[1]), parseInt(effDateEnrollArray[2])-1);
                $scope.dateMaxInScope = maxDate;

                //Get default date for date picker
                var billingDatePlanArray = $scope.bpTree.response.bill.billingDatePlan.split('-');
                var minDay = parseInt(billingDatePlanArray[2]) < 28? parseInt(billingDatePlanArray[2]): 28;
                var billingStartDate = $scope.getDate(parseInt(billingDatePlanArray[0]), parseInt(effectiveDateArray[1])-1, minDay);
                var effectiveDate = $scope.getDate(parseInt(effectiveDateArray[0]), parseInt(effectiveDateArray[1])-1, parseInt(effectiveDateArray[2]));

                console.log('billingDatePlanArray', billingDatePlanArray);
                console.log('minDay', minDay);
                console.log('billingStartDate 1', billingStartDate);
                console.log('effectiveDate', effectiveDate);

                if(billingStartDate < effectiveDate){
                        billingStartDate.setMonth(billingStartDate.getMonth()+1);
                }

                console.log('billingStartDate 2', billingStartDate);

                if(billingStartDate.getDate() > 28 && billingStartDate.getDate() < effectiveDate.getDate()){
                        billingStartDate = $scope.getDate(billingStartDate.getFullYear(), billingStartDate.getMonth()+1, 1);
                        $scope.dateMaxInScope = billingStartDate;
                }

                console.log('billingStartDate 3', billingStartDate);
                $scope.bpTree.response.bill.customBillingDateAppFee = $scope.getStringDate(billingStartDate); //$scope.bpTree.response.bill.billingDatePlan;
                
        }

        $scope.getDate = function(year, month, day){
                var dateToReturn = new Date();
                dateToReturn.setFullYear(year);
                dateToReturn.setMonth(month); //not to add month as js manages the dates from 0(january) to 11(december)
                dateToReturn.setDate(day);
                return dateToReturn;
        }

        $scope.getStringDate = function(dateVar){
                var dateToReturn = '';
                dateToReturn = dateVar.getFullYear() + '-' +('0' + (dateVar.getMonth()+1)).slice(-2) + '-' + ('0' + dateVar.getDate()).slice(-2) ;
                return dateToReturn;
        }

}]);