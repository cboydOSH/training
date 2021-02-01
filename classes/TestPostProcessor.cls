global without Sharing class TestPostProcessor implements vlocity_ins.VlocityOpenInterface2{

  static final String FAMILY_DIFF = 'FamilyDiff';
  static final String PARTY_DIFF = '2PartyDiff';
  static final String MEMBER_DIFF = 'MemberDiff';
  static final String FAMILY = 'Family';
  static final String PARTY = '2Party';
  static final String MEMBER = 'Member';
  static final String IN_CONS = 'In';
  static final String PARENT_PROD_KEY = 'parentProdKey';
  static final String PRODUCT_KEY = 'productKey';
  static final String ADDITIONAL_FEES = 'AdditionalFees';
  static final String ADDITIONAL_FEES_DISCOUNT = 'AdditionalFeesDiscountApplied';
  static final String ADDITIONAL_FEES_MORE = 'AdditionalFeeMoreThan6';

    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
      Boolean success = true;
      try{
        if(methodName == 'calculate') {
          calculate(inputMap, outMap, options);
        }
        if(methodName == 'calculateDiscounts') {
          calculateDiscounts(inputMap, outMap, options);
        }
        if(methodName == 'matchDiscounts') {
          matchDiscounts(inputMap, outMap, options);
        }
      }catch(Exception e){
        success=false;
      }
      return success;        
     }
     
     /**
      * Method that copies over the additional fees into each and every input node.
      */
     private static void calculate(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
       system.debug('inputMap'+ inputMap.keySet());
       List<Object> listObjForFees = (List<Object>)inputMap.get('input_1');
       Map<String,Object> objForFees = (Map<String,Object>)listObjForFees.get(0);
       Integer counter = 1;
       String additionalFees = (String)inputMap.get(ADDITIONAL_FEES);
       String additionalFeesMore = (String)inputMap.get(ADDITIONAL_FEES_MORE);
          List<Object> inputProgramPremiumObjects = (List<Object>)inputMap.get('ProgramPremium');
          //system.debug('inputProgramPremiumObject'+ inputProgramPremiumObjects);
          for(Object programPremiumMap: inputProgramPremiumObjects){
            Map<String,Object> premiumMap = (Map<String,Object>)programPremiumMap;
            Map<String,Object> outIndividualProgramPremium = new Map<String,Object>();
            List<Map<String,Object>> outputProgramPremium = new List<Map<String,Object>>();
            for(String key : premiumMap.keySet()){
              //system.debug('key ' + key + ', value ' + premiumMap.get(key));
              if(key.contains(FAMILY_DIFF) && premiumMap.get(key)!=null && premiumMap.get(key)!='0'){
                outIndividualProgramPremium.put(FAMILY_DIFF+IN_CONS, premiumMap.get(key));
              }else if(key.contains(PARTY_DIFF) && premiumMap.get(key)!=null && premiumMap.get(key)!='0'){
                outIndividualProgramPremium.put(PARTY_DIFF+IN_CONS, premiumMap.get(key));
              }else if(key.contains(MEMBER_DIFF) && premiumMap.get(key)!=null && premiumMap.get(key)!='0'){
                outIndividualProgramPremium.put(MEMBER_DIFF+IN_CONS, premiumMap.get(key));
              }else if(key.contains(FAMILY) && premiumMap.get(key)!=null && premiumMap.get(key)!='0'){
                outIndividualProgramPremium.put(FAMILY+IN_CONS, premiumMap.get(key));
              }else if(key.contains(PARTY) && premiumMap.get(key)!=null && premiumMap.get(key)!='0'){
                outIndividualProgramPremium.put(PARTY+IN_CONS, premiumMap.get(key));
              }else if(key.contains(MEMBER) && premiumMap.get(key)!=null && premiumMap.get(key)!='0'){
                outIndividualProgramPremium.put(MEMBER+IN_CONS, premiumMap.get(key));
              }else if(key==PARENT_PROD_KEY){
                outIndividualProgramPremium.put(PARENT_PROD_KEY, premiumMap.get(key));
              }else if(key==PRODUCT_KEY){
                outIndividualProgramPremium.put(PRODUCT_KEY, premiumMap.get(key));
              }
              outIndividualProgramPremium.put(ADDITIONAL_FEES, objForFees.get(ADDITIONAL_FEES));
              outIndividualProgramPremium.put(ADDITIONAL_FEES_MORE, objForFees.get(ADDITIONAL_FEES_MORE));
          }
          // outIndividualProgramPremium.put(ADDITIONAL_FEES, additionalFees);
          // outIndividualProgramPremium.put(ADDITIONAL_FEES_MORE, additionalFeesMore);
          //system.debug('adding, '+ outIndividualProgramPremium);
          outputProgramPremium.add(outIndividualProgramPremium);
          outMap.put('input_'+counter, outputProgramPremium);
          counter++;
          }
        }

        private void calculateDiscounts(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
          //Get account Id
          String accountId = (String)inputMap.get('AccountId');
          //Get input for calculation
          Map<String,Object> inputProductsMap = (Map<String,Object>)inputMap.get('input');
          //Get account logged in
          Account account = [SELECT Id, Application_Fee_Discount__c, Contribution_Discount__c FROM Account WHERE Id =: accountId LIMIT 1];
          //Initialize promotions object
          Program_Promotion__c OTAPDiscount = null;
          Program_Promotion__c contributionDiscount = null;
          //If there is a promotion for ONE TIME APPLICATION let's get it 
          if(account.Application_Fee_Discount__c!=null){
            OTAPDiscount = [SELECT Id, Enabled__c, Start_Date__c, End_Date__c, Value__c, Promotions_Program_Metadata__c,
                            Applicable_Item__c, Automatic_Discount__c, Promotion_Channel__c, Recurrency__c, Type_of_discount__c 
                            FROM Program_Promotion__c
                            WHERE Automatic_Discount__c = true AND Start_Date__c <= today AND End_Date__c >= today AND Enabled__c = true AND Id =: account.Application_Fee_Discount__c ].get(0);
          }
          //If there is a promotion for MONTHLY CONTRIBUTION let's get it 
          if(account.Contribution_Discount__c != null){
            contributionDiscount = [SELECT Id, Enabled__c, Start_Date__c, End_Date__c, Value__c, Promotions_Program_Metadata__c,
                            Applicable_Item__c, Automatic_Discount__c, Promotion_Channel__c, Recurrency__c, Type_of_discount__c 
                            FROM Program_Promotion__c
                            WHERE Automatic_Discount__c = true AND Start_Date__c <= today AND End_Date__c >= today AND Enabled__c = true AND Id =: account.Contribution_Discount__c LIMIT 1].get(0);
          }
          //If there is a discount for OTAF let's deserialize the json String
          List<Object> OTAPProgramsList = null;
          if(OTAPDiscount!=null){
            OTAPProgramsList = (List<Object>)JSON.deserializeUntyped(OTAPDiscount.Promotions_Program_Metadata__c);
          }
          //Same for Contribution discounts
          List<Object> ContributionProgramsList = null;
          if(contributionDiscount!=null){
            ContributionProgramsList = (List<Object>)JSON.deserializeUntyped(contributionDiscount.Promotions_Program_Metadata__c);
          }
          //Once we have all the discounts and the input, let's build the new input
          system.debug('inputMap-> ' + inputMap);
          //Iterate the input map
          for(String key : inputProductsMap.keySet()){ 
            //For each product look for a promotion
            List<Object> tempProductInfo = (List<Object>)inputProductsMap.get(key);
            Map<String,Object> productMap = (Map<String,Object>)tempProductInfo.get(0);
            system.debug('productMap stock -> ' + productMap);
            //Let's start for one time application fee
            checkDiscount(OTAPProgramsList, OTAPDiscount, productMap);
            //then with contribution
            checkDiscount(ContributionProgramsList, contributionDiscount, productMap);
            //Print for validation
            system.debug('productMap modified -> ' + productMap);
          }
          outMap.put('inputModified', inputProductsMap);
        }

        private void matchDiscounts(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
          //system.debug('matchDiscounts');
          //system.debug('inputMap keys : ' + inputMap.keySet());
          //system.debug('inputMap' + inputMap);
          Map<String, Object> inputProgramPremiumObjects = (Map<String, Object>)inputMap.get('ProgramPremium');
          inputProgramPremiumObjects.remove('errorCode');
          inputProgramPremiumObjects.remove('error');
          Map<String, Object> inputProgramDiscounts = (Map<String, Object>)inputMap.get('ProgramDiscounts');
          Map<String,Object> outputMapWithDiscounts = new Map<String,Object>();
          /**debugging starts */
          //system.debug('programs discount maps');
          //for(String key: inputProgramDiscounts.keySet()){
            //system.debug('key: ' + key);
            //system.debug('value: ' + inputProgramDiscounts.get(key));
          //}
           /**debugging ends */
          for(String key: inputProgramDiscounts.keySet()){
            if(key.contains('input_')){
              List<Object> programDiscountList = (List<Object>)inputProgramDiscounts.get(key);
              Map<String,Object> programDiscountMap = (Map<String,Object>)programDiscountList.get(0);
              //system.debug('key: ' + key + ', value: ' + programDiscountMap);
              String valueToSearch = (String)programDiscountMap.get('productKey');
              //system.debug('searching productKey: ' + valueToSearch);
              Map<String,Object> programMapToDiscount = null;
              if(programDiscountMap.get('AdditionalFeesDiscountValueFlatDollar')!=null){
                /**debugging starts */
                //system.debug('there was a discount 1 looking for key: '+key);
                //system.debug('about to get program premium');
                /**debugging ends */
                programMapToDiscount = getProgramPremium(valueToSearch, 'productKey', inputProgramPremiumObjects);
                /**debugging starts */
                //system.debug('got program premium' + programMapToDiscount);
                //system.debug('program gotten: '+programMapToDiscount.get('Program'));
                /**debugging ends */
                Double discountToApplyValue = Double.valueOf(programMapToDiscount.get(ADDITIONAL_FEES))-Double.valueOf(programDiscountMap.get('AdditionalFeesDiscountValueFlatDollar'));
                programMapToDiscount.put(ADDITIONAL_FEES, discountToApplyValue+'');
                programMapToDiscount.put(ADDITIONAL_FEES_DISCOUNT+IN_CONS, Double.valueOf(programDiscountMap.get('AdditionalFeesDiscountValueFlatDollar'))+'');
              }
              if(programDiscountMap.get('MonthlyDiscountValue')!=null && programDiscountMap.get('MonthlyDiscountType')!=null){
                system.debug('there was a discount 2');
                if(programMapToDiscount==null){
                  programMapToDiscount = getProgramPremium(valueToSearch, 'productKey', inputProgramPremiumObjects);
                }
                if(programDiscountMap.get('MonthlyDiscountType')=='Flat-dollar'){
                  Double discountAmount = Double.valueOf(programDiscountMap.get('MonthlyDiscountValue'));
                  programMapToDiscount.put(FAMILY_DIFF+IN_CONS, Double.valueOf(programMapToDiscount.get(FAMILY_DIFF+IN_CONS))-discountAmount);
                  programMapToDiscount.put(PARTY_DIFF+IN_CONS, Double.valueOf(programMapToDiscount.get(PARTY_DIFF+IN_CONS))-discountAmount);
                  programMapToDiscount.put(MEMBER_DIFF+IN_CONS, Double.valueOf(programMapToDiscount.get(MEMBER_DIFF+IN_CONS))-discountAmount);
                  programMapToDiscount.put(FAMILY+IN_CONS, Double.valueOf(programMapToDiscount.get(FAMILY+IN_CONS))-discountAmount);
                  programMapToDiscount.put(PARTY+IN_CONS, Double.valueOf(programMapToDiscount.get(PARTY+IN_CONS))-discountAmount);
                  programMapToDiscount.put(MEMBER+IN_CONS, Double.valueOf(programMapToDiscount.get(MEMBER+IN_CONS))-discountAmount);
                }else if(programDiscountMap.get('MonthlyDiscountType')=='Percentage'){
                  Double discountPercentage = 100 - Double.valueOf(programDiscountMap.get('MonthlyDiscountValue'));
                  discountPercentage = discountPercentage/100;
                  programMapToDiscount.put(FAMILY_DIFF+IN_CONS, Double.valueOf(programMapToDiscount.get(FAMILY_DIFF+IN_CONS))*discountPercentage);
                  programMapToDiscount.put(PARTY_DIFF+IN_CONS, Double.valueOf(programMapToDiscount.get(PARTY_DIFF+IN_CONS))*discountPercentage);
                  programMapToDiscount.put(MEMBER_DIFF+IN_CONS, Double.valueOf(programMapToDiscount.get(MEMBER_DIFF+IN_CONS))*discountPercentage);
                  programMapToDiscount.put(FAMILY+IN_CONS, Double.valueOf(programMapToDiscount.get(FAMILY+IN_CONS))*discountPercentage);
                  programMapToDiscount.put(PARTY+IN_CONS, Double.valueOf(programMapToDiscount.get(PARTY+IN_CONS))*discountPercentage);
                  programMapToDiscount.put(MEMBER+IN_CONS, Double.valueOf(programMapToDiscount.get(MEMBER+IN_CONS))*discountPercentage);
                }
              }
            }
          }
          outMap.put('inputModified', inputProgramPremiumObjects);
        }

        private Map<String,Object> getProgramPremium(String value, String key, Map<String,Object> productsMap){
          Map<String,Object> mapToReturn = null;
          for(String inputKey: productsMap.keySet()){
            if(inputKey.contains('input_')){
              List<Object> programList = (List<Object>)productsMap.get(inputKey);
              Map<String,Object> programMap = (Map<String,Object>)programList.get(0);
              system.debug('inputkey: ' + inputKey + ' value: '+ programMap + ', looking for: ' + key + 'which needs to have value of: '+value);
              system.debug('value comparison: '+ programMap.get(key)+''==value);
              if(programMap.get(key)+''==value){
                mapToReturn = programMap;
              }
            }
          }
          return mapToReturn;
        }

        private void checkDiscount(List<Object> promotionList, Program_Promotion__c discountToApply, Map<String,Object> productMap){
          if(promotionList!=null){
            //Iterate the list to find out if there is a specific promotion for the program
            for(Object promotionObj : promotionList){
              Map<String,Object> promotionMap = (Map<String,Object>)promotionObj;
              if(promotionMap.get('available')=='applicable'){
                if(promotionMap.get('code')==productMap.get('Program')){
                  //Let's differenciate between the possible discounts
                  if(discountToApply.Applicable_Item__c=='One Time Application Fee'){
                    Double discountToApplyValue = 0;
                    if(discountToApply.Type_of_discount__c=='Flat-dollar'){
                      discountToApplyValue = Double.valueOf(discountToApply.Value__c);
                    }else if(discountToApply.Type_of_discount__c=='Percentage'){
                      Double percentage = Double.valueOf(discountToApply.Value__c);
                      discountToApplyValue = ((Double.valueOf(productMap.get(ADDITIONAL_FEES))*percentage)/100);
                    }
                    system.debug('Adding discount for: ' + productMap.get('Program'));
                    productMap.put('AdditionalFeesDiscountValueFlatDollar', discountToApplyValue);
                  }else if(discountToApply.Applicable_Item__c=='Monthly Contribution'){
                    productMap.put('MonthlyDiscountValue', Double.valueOf(discountToApply.Value__c));
                    productMap.put('MonthlyDiscountType', discountToApply.Type_of_discount__c);
                  }
                }
              }
            }
          }
        }
   }