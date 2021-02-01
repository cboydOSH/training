@isTest global class TestPostProcessorTest {

    public static TestPostProcessor postProcessor;
    public static final String ADDITIONALFEES='AdditionalFees';
    public static final String ADDITIONALFEESMORETHAN='AdditionalFeeMoreThan6';

    static void testCalculateDiscountsRealData(){
        Test.startTest();
        //Prepare
        postProcessor = new TestPostProcessor();
        Map<String,Object> input = getRealInput();
        Map<String,Object> output = new Map<String,Object>();
        //Execute
        postProcessor.invokeMethod('calculateDiscounts', input, output, null);
        //Validate
        System.assertEquals(true, true);
        Test.stopTest();
    }
    
    @isTest static void testCalculateDiscountsMockData(){
        Test.startTest();
        //Prepare
        postProcessor = new TestPostProcessor();
        //Create contribution promotion
        Program_Promotion__c contributionPromotion = createPromotion('contributionPromotionTest', '10', 
                    '[{"available":"applicable","name":"OneShare Catastrophic - $150,000/$300,000","id":"testID1","code":"OSHCAT150"},{"available":"applicable","name":"OneShare Catastrophic - $500,000/$1,000,000","id":"testID2","code":"OSHCAT500"},{"available":"applicable","name":"OneShare Catastrophic - $250,000/$500,000","id":"01t8A00000496MHQAY","code":"OSHCAT250"},{"available":"not applicable","name":"OneShare Complete - Crown","id":"01t8A00000496MbQAI","code":"OSHCOMPCROWN"},{"available":"not applicable","name":"OneShare Classic - Enhanced","id":"01t8A00000496OOQAY","code":"OSHCLASSENH"},{"available":"not applicable","name":"OneShare Classic - Basic","id":"01t8A00000496RdQAI","code":"OSHCLASSBASIC"},{"available":"not applicable","name":"OneShare Classic - Crown","id":"01t8A00000496ldQAA","code":"OSHCLASSCROWN"},{"available":"not applicable","name":"OneShare Complete - Basic","id":"01t8A0000049Yz8QAE","code":"OSHCOMPBASIC"},{"available":"not applicable","name":"OneShare Complete - Enhanced","id":"01t8A000004A8QRQA0","code":"OSHCOMPENH"},{"available":"not applicable","name":"Thrive Preferred","id":"01t8A000005q4NmQAI","code":"OSHTHRIVEPREF"},{"available":"not applicable","name":"Thrive Premier","id":"01t8A000005q4OuQAI","code":"OSHTHRIVEPREM"}]', 
                    'Monthly Contribution', 'Forever', 'Percentage');
        //Create one time application fee promotion
        Program_Promotion__c onetimePromotion = createPromotion('onetimePromotionTest', '20', 
                    '[{"available":"applicable","name":"OneShare Catastrophic - $150,000/$300,000","id":"testID1","code":"OSHCAT150"},{"available":"applicable","name":"OneShare Catastrophic - $500,000/$1,000,000","id":"testID2","code":"OSHCAT500"},{"available":"applicable","name":"OneShare Catastrophic - $250,000/$500,000","id":"01t8A00000496MHQAY","code":"OSHCAT250"},{"available":"not applicable","name":"OneShare Complete - Crown","id":"01t8A00000496MbQAI","code":"OSHCOMPCROWN"},{"available":"not applicable","name":"OneShare Classic - Enhanced","id":"01t8A00000496OOQAY","code":"OSHCLASSENH"},{"available":"not applicable","name":"OneShare Classic - Basic","id":"01t8A00000496RdQAI","code":"OSHCLASSBASIC"},{"available":"not applicable","name":"OneShare Classic - Crown","id":"01t8A00000496ldQAA","code":"OSHCLASSCROWN"},{"available":"not applicable","name":"OneShare Complete - Basic","id":"01t8A0000049Yz8QAE","code":"OSHCOMPBASIC"},{"available":"not applicable","name":"OneShare Complete - Enhanced","id":"01t8A000004A8QRQA0","code":"OSHCOMPENH"},{"available":"not applicable","name":"Thrive Preferred","id":"01t8A000005q4NmQAI","code":"OSHTHRIVEPREF"},{"available":"not applicable","name":"Thrive Premier","id":"01t8A000005q4OuQAI","code":"OSHTHRIVEPREM"}]',
                     'One Time Application Fee', 'Once', 'Flat-dollar');
        //create Account
        Account newAccount = new Account(
            LastName = 'testAccount'
        );
        insert newAccount;        
        newAccount.Contribution_Discount__c = contributionPromotion.Id;
        newAccount.Application_Fee_Discount__c = onetimePromotion.Id;
        update newAccount;

        Map<String,Object> input = new Map<String,Object>();
        input.put('AccountId', newAccount.Id);
        input.put('input', getRealMockedInput(newAccount.Id));
        Map<String,Object> output = new Map<String,Object>();
        //Execute
        boolean issuccess = postProcessor.invokeMethod('calculateDiscounts', input, output, null);
        //Validate
        System.assertEquals(true, issuccess);
        Test.stopTest();
    }

    @isTest static void testCalculate(){
        Test.startTest();
        //Prepare
        postProcessor = new TestPostProcessor();
        String additionalFeesVar = '125';
        String additionalFeesMoreThanVar = '0';
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outputMap = new Map<String,Object>();
        inputMap.put('ProgramPremium', getSampleInputArray(4));
        inputMap.put('input_1', getInputs(4, 'testAccount', additionalFeesVar, additionalFeesMoreThanVar).get('input_1'));
        //Execute
        postProcessor.invokeMethod('calculate', inputMap, outputMap, null);
        system.debug('outputMap: ' + outputMap);
        system.debug('inputMap: ' + inputMap);
        //Validate
        for(String key: outputMap.keySet()){
            //Validating output elements has the same additional fees
            List<Object> listObj = (List<Object>)outputMap.get(key);
            Map<String, Object> productMap = (Map<String, Object> )listObj.get(0);
            System.assertEquals(additionalFeesVar, productMap.get(ADDITIONALFEES));
            System.assertEquals(additionalFeesMoreThanVar, productMap.get(ADDITIONALFEESMORETHAN));
        }
        Test.stopTest();
    }

    @isTest static void testMatchDiscounts(){
        Test.startTest();
        //Prepare
        postProcessor = new TestPostProcessor();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> programPremiumMap = getSampleInputProgramPremium();
        inputMap.put('ProgramPremium', programPremiumMap);
        inputMap.put('ProgramDiscounts', getProgramDiscounts());
        //Execute
        postProcessor.invokeMethod('matchDiscounts', inputMap, outputMap, null);
        system.debug('outputMap: ' + outputMap);
        system.debug('inputMap: ' + inputMap);
        //Validate
        programPremiumMap = getSampleInputProgramPremium();//reset values?
        List<Object> listFirstProductPricesDiscount = (List<Object>)((Map<String,Object>)outputMap.get('inputModified')).get('input_1');
        Map<String,Object> firstProductMapOutput = (Map<String,Object>)listFirstProductPricesDiscount.get(0);
        List<Object> listFirstProductPricesWithOutDiscount = (List<Object>)programPremiumMap.get('input_1');
        Map<String,Object> firstProductMapInput = (Map<String,Object>)listFirstProductPricesWithOutDiscount.get(0);
        System.assertEquals(Double.valueOf(firstProductMapInput.get('FamilyDiffIn'))-5, Double.valueOf(firstProductMapOutput.get('FamilyDiffIn')));
        System.assertEquals(Double.valueOf(firstProductMapInput.get('2PartyDiffIn'))-5, Double.valueOf(firstProductMapOutput.get('2PartyDiffIn')));
        System.assertEquals(Double.valueOf(firstProductMapInput.get('MemberDiffIn'))-5, Double.valueOf(firstProductMapOutput.get('MemberDiffIn')));
        System.assertEquals(Double.valueOf(firstProductMapInput.get('FamilyIn'))-5, Double.valueOf(firstProductMapOutput.get('FamilyIn')));
        System.assertEquals(Double.valueOf(firstProductMapInput.get('2PartyIn'))-5, Double.valueOf(firstProductMapOutput.get('2PartyIn')));
        System.assertEquals(Double.valueOf(firstProductMapInput.get('MemberIn'))-5, Double.valueOf(firstProductMapOutput.get('MemberIn')));
        System.assertEquals(Double.valueOf(firstProductMapInput.get('AdditionalFees'))-10, Double.valueOf(firstProductMapOutput.get('AdditionalFees')));
        List<Object> listSecoundProductPricesDiscount = (List<Object>)((Map<String,Object>)outputMap.get('inputModified')).get('input_2');
        Map<String,Object> secondProductMapOutput = (Map<String,Object>)listSecoundProductPricesDiscount.get(0);
        List<Object> listSecoundtProductPricesWithOutDiscount = (List<Object>)programPremiumMap.get('input_2');
        Map<String,Object> secondProductMapInput = (Map<String,Object>)listSecoundtProductPricesWithOutDiscount.get(0);
        Double discountPercentage = 100 - Double.valueOf(20);
        discountPercentage = discountPercentage/100;
        System.assertEquals(Double.valueOf(secondProductMapInput.get('FamilyDiffIn'))*discountPercentage, Double.valueOf(secondProductMapOutput.get('FamilyDiffIn')));
        System.assertEquals(Double.valueOf(secondProductMapInput.get('2PartyDiffIn'))*discountPercentage, Double.valueOf(secondProductMapOutput.get('2PartyDiffIn')));
        System.assertEquals(Double.valueOf(secondProductMapInput.get('MemberDiffIn'))*discountPercentage, Double.valueOf(secondProductMapOutput.get('MemberDiffIn')));
        System.assertEquals(Double.valueOf(secondProductMapInput.get('FamilyIn'))*discountPercentage, Double.valueOf(secondProductMapOutput.get('FamilyIn')));
        System.assertEquals(Double.valueOf(secondProductMapInput.get('2PartyIn'))*discountPercentage, Double.valueOf(secondProductMapOutput.get('2PartyIn')));
        System.assertEquals(Double.valueOf(secondProductMapInput.get('MemberIn'))*discountPercentage, Double.valueOf(secondProductMapOutput.get('MemberIn')));
        System.assertEquals(Double.valueOf(secondProductMapInput.get('AdditionalFees')), Double.valueOf(secondProductMapOutput.get('AdditionalFees')));
        Test.stopTest();
    }

    private static Map<String,Object> getSampleInput(Integer howmany, String accountId, String additionalFees, String additionalFeeMoreThan6){
        return new Map<String,Object>{'AccountId'=> accountId,
                                      'input'=> getInputs(howmany, accountId, additionalFees, additionalFeeMoreThan6)};
    }

    private static Map<String,Object> getInputs(Integer howmany, String accountId, String additionalFees, String additionalFeeMoreThan6){
        String modelkey='input';
        Map<String,Object> mapToReturn = new Map<String,Object>();
        for(Integer i = 0; i < howmany; i++){
            List<Object> tempList = new List<Object>();
            Map<String,Object> inputMap = new Map<String,Object>();
            inputMap.put('productKey', 'testproductkey'+i);
            inputMap.put('parentProdKey', 'testproductkey'+i);
            inputMap.put('Age', '30');
            inputMap.put('AccountId',accountId);
            inputMap.put('State', 'TX');
            inputMap.put('ISA', '10000');
            inputMap.put('Program', 'program'+i);
            inputMap.put('AdditionalFees', additionalFees);
            inputMap.put('AdditionalFeeMoreThan6', additionalFeeMoreThan6);
            tempList.add(inputMap);
            mapToReturn.put('input_'+(i+1), tempList);
        }
        return mapToReturn;
    }

    private static List<Object> getSampleInputArray(Integer howmany){
        List<Object> tempList = new List<Object>();
        for(Integer i = 0; i < howmany; i++){
            Map<String,Object> inputMap = new Map<String,Object>();
            inputMap.put('productKey', 'testproductkey'+i);
            inputMap.put('parentProdKey', 'testproductkey'+i);
            inputMap.put('WyomingProgramRates__FamilyDiff', 391.97);
            inputMap.put('WyomingProgramRates__2PartyDiff', 277.97);
            inputMap.put('WyomingProgramRates__MemberDiff', 194.97);
            inputMap.put('WyomingProgramRates__Family', 391.97);
            inputMap.put('WyomingProgramRates__2Party', 277.97);
            inputMap.put('WyomingProgramRates__Member', 194.97);
            tempList.add(inputMap);
        }
        return tempList;
    }

    private static Map<String,Object> getSampleInputProgramPremium(){
        Map<String,Object> mapToReturn = new Map<String,Object>();
        List<Object> tempList = new List<Object>();
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('productKey', 'productKey1');
        inputMap.put('parentProdKey', 'productKey1');
        inputMap.put('FamilyDiffIn', 650.97);
        inputMap.put('2PartyDiffIn', 509.97);
        inputMap.put('MemberDiffIn', 398.97);
        inputMap.put('FamilyIn', 650.97);
        inputMap.put('2PartyIn', 509.97);
        inputMap.put('MemberIn', 398.97);
        inputMap.put('AdditionalFees', '120');
        inputMap.put('AdditionalFeeMoreThan6', '50');
        tempList.add(inputMap);
        mapToReturn.put('input_1', tempList);
        tempList = new List<Object>();
        inputMap = new Map<String,Object>();
        inputMap.put('productKey', 'productKey2');
        inputMap.put('parentProdKey', 'productKey2');
        inputMap.put('FamilyDiffIn', 391.97);
        inputMap.put('2PartyDiffIn', 277.97);
        inputMap.put('MemberDiffIn', 194.97);
        inputMap.put('FamilyIn', 391.97);
        inputMap.put('2PartyIn', 277.97);
        inputMap.put('MemberIn', 194.97);
        inputMap.put('AdditionalFees', '120');
        inputMap.put('AdditionalFeeMoreThan6', '50');
        tempList.add(inputMap);
        mapToReturn.put('input_2', tempList);
        return mapToReturn;
    }

    private static Map<String,Object> getProgramDiscounts(){
        Map<String,Object> mapToReturn = new Map<String,Object>();
        List<Object> tempList = new List<Object>();
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('productKey', 'productKey1');
        inputMap.put('parentProdKey', 'productKey1');
        inputMap.put('MonthlyDiscountType', 'Flat-dollar');
        inputMap.put('MonthlyDiscountValue', 5);
        inputMap.put('AdditionalFeesDiscountValueFlatDollar', 10);
        tempList.add(inputMap);
        mapToReturn.put('input_1', tempList);
        tempList = new List<Object>();
        inputMap = new Map<String,Object>();
        inputMap.put('productKey', 'productKey2');
        inputMap.put('parentProdKey', 'productKey2');
        inputMap.put('MonthlyDiscountType', 'Percentage');
        inputMap.put('MonthlyDiscountValue', 20);
        inputMap.put('AdditionalFeesDiscountValueFlatDollar', 0);
        tempList.add(inputMap);
        mapToReturn.put('input_2', tempList);
        return mapToReturn;
    }

    private static Map<String,Object> getRealInput(){
        Map<String,Object> mapToReturn = new Map<String,Object>();
        mapToReturn.put('AccountId', '0018A00000WbIhQQAV');
        Map<String,Object> input = new Map<String,Object>();
        List<Object> firstInputList = new List<Object>();
        Map<String,Object> firstInputMap = new Map<String,Object>{
            'AccountId'=> '0018A00000WbIhQQAV',
            'AdditionalFeeMoreThan6'=> '50',
            'AdditionalFees'=> '75',
            'Program'=> 'OSHCAT150',
            'ISA'=> '10000',
            'State'=> 'WY',
            'Age'=> '60',
            'MEMBER.instanceKey'=> '1',
            'parentProdKey'=> '01t8A0000043pgeQAA',
            'productKey'=> '01t8A0000043pgeQAA',
            'Availability__c'=> null,
            'Type__c'=> null,
            'SubType__c'=> null
        };
        firstInputList.add(firstInputMap);
        input.put('input_1', firstInputList);

        List<Object> secondInputList = new List<Object>();
        Map<String,Object> secondInputMap = new Map<String,Object>{
            'AdditionalFeeMoreThan6'=> '0',
            'AdditionalFees'=> '0',
            'Program'=> 'OSHCAT500',
            'ISA'=> '10000',
            'State'=> 'WY',
            'Age'=> '60',
            'MEMBER.instanceKey'=> '1',
            'parentProdKey'=> '01t8A0000049Yz8QAE',
            'productKey'=> '01t8A0000049Yz8QAE',
            'Availability__c'=> null,
            'Type__c'=> null,
            'SubType__c'=> null
        };
        secondInputList.add(secondInputMap);
        input.put('input_2', secondInputList);
        mapToReturn.put('input', input);
        return mapToReturn;
    }

    private static Program_Promotion__c createPromotion(String name, String value, String metadata, String applicableItem, String recurrency, String typeOfDiscount){
        DateTime todaysDate = System.today();
        DateTime todayPlusOneMonth = todaysDate.addMonths(1);
        Program_Promotion__c programPromotion = new Program_Promotion__c(
            Name = name,
            Enabled__c = true,
            Start_Date__c =  date.newinstance(todaysDate.year(), todaysDate.month(), todaysDate.day()),
            End_Date__c = date.newinstance(todayPlusOneMonth.year(), todayPlusOneMonth.month(), todayPlusOneMonth.day()),
            Value__c = value,
            Promotions_Program_Metadata__c = metadata,
            Applicable_Item__c = applicableItem,
            Automatic_Discount__c = true,
            Promotion_Channel__c = 'Producer;OSH Employee;Member',
            Recurrency__c = recurrency,
            Type_of_discount__c = typeOfDiscount
        );
        insert programPromotion;
        return programPromotion;
    }

    private static Map<String,Object> getRealMockedInput(String AccountId){
        Map<String,Object> input = new Map<String,Object>();
        List<Object> firstInputList = new List<Object>();
        Map<String,Object> firstInputMap = new Map<String,Object>{
            'AccountId'=> AccountId,
            'AdditionalFeeMoreThan6'=> '0',
            'AdditionalFees'=> '125',
            'Program'=> 'OSHCAT150',
            'ISA'=> '10000',
            'State'=> 'WY',
            'Age'=> '60',
            'MEMBER.instanceKey'=> '1',
            'parentProdKey'=> 'testID1',
            'productKey'=> 'testID1',
            'Availability__c'=> null,
            'Type__c'=> null,
            'SubType__c'=> null
        };
        firstInputList.add(firstInputMap);
        input.put('input_1', firstInputList);

        List<Object> secondInputList = new List<Object>();
        Map<String,Object> secondInputMap = new Map<String,Object>{
            'AccountId'=> AccountId,
            'AdditionalFeeMoreThan6'=> '0',
            'AdditionalFees'=> '125',
            'Program'=> 'OSHCAT500',
            'ISA'=> '10000',
            'State'=> 'WY',
            'Age'=> '60',
            'MEMBER.instanceKey'=> '1',
            'parentProdKey'=> 'testID2',
            'productKey'=> 'testID2',
            'Availability__c'=> null,
            'Type__c'=> null,
            'SubType__c'=> null
        };
        secondInputList.add(secondInputMap);
        input.put('input_2', secondInputList);
        return input;
    }
}