@IsTest public with sharing class OSHMemberCardUtilitiesTest {
    
   // @IsTest public static void testInvokeMethod(){
        //Test.startTest();
        
        
        //create Account
        //Account newAccount = new Account(
         //   LastName = 'testAccount',
         //   FirstName = 'test',
         //   Member_ID__pc = '798465411321'
        //);
        //insert newAccount;        
       // System.debug('NEW ACCOUNT => ' + newAccount);
       // List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        
        
        //create chargent order
        //ChargentOrders__ChargentOrder__c newChargentOrder = new ChargentOrders__ChargentOrder__c(
       // );
        //insert newChargentOrder;
       // List<ChargentOrders__ChargentOrder__c> chargent1id = [SELECT Id FROM ChargentOrders__ChargentOrder__c LIMIT 1];
        
       // Date myDate = Date.newInstance(2020, 12, 17);
        
        //create Contract
       /// Contract newContract = new Contract(
       //     Name = 'testContract',
       //     AccountId = account1id[0].Id,
       //     StartDate = myDate
       // );
      //  insert newContract;        
       // System.debug('NEW CONTRACT => ' + newContract);
      //  List<Contract> contract1id = [SELECT Id FROM Contract LIMIT 1];
        
        
        //create Asset
       // Asset newAsset = new Asset(
         //   Name = 'testAsset',
          //  AccountId = account1id[0].Id,
          //  Contract__c = contract1id[0].Id,
		//Status = 'Active',
         //   Group_Code__c = '1NAKCOC05'
       // );
        //insert newAsset;        
        //System.debug('NEW ASSET => ' + newAsset);
        //List<Asset> asset1id = [SELECT Id FROM Asset LIMIT 1];
        
        
        
        
        
        //create ContractLineItem
       // vlocity_ins__ContractLineItem__c contractLineItem = new vlocity_ins__ContractLineItem__c(
        //	vlocity_ins__attributeselectedvalues__c = 'TELEMED',
       //     vlocity_ins__ContractId__c = contract1id[0].Id
       // );
        
        
       // String method1 = 'getMemberCardPDFData';
       //  Map<String, Object> mapInput = new Map<String, Object> {
       //         'AccountId' => account1id[0].Id
        
       // };
      //  Map<String, Object> mapOutput = new Map<String, Object>();
      //  Map<String, Object> mapOptions = new Map<String, Object>();
        
      // OSHMemberCardUtilities newOshMemCardUt = new OSHMemberCardUtilities();
      // Boolean success = newOshMemCardUt.invokeMethod(method1, mapInput, mapOutput, mapOptions);
        
        
      // Test.stopTest();
      // System.assertEquals(success, true); 
    //}
    
    
    //@IsTest(SeeAllData=true) 
    //public static void validTestWithJohnCenaAccount() {
        //Prepare
        //String methodName = 'getMemberCardPDFData';
        //Boolean result = false;
        //Map<String,Object> input = new Map<String,Object>{'AccountId'=>'0018A00000ZJcbWQAT'};
        //Map<String,Object> outMap = new Map<String,Object>();
        //try{
          //  OSHMemberCardUtilities obj = new OSHMemberCardUtilities();
            // Execute  
            //result = obj.invokeMethod(methodName, input, outMap, null);
        //}catch(Exception e){
          //  system.debug(e);
        //}
        //Validate                     
        //System.assertEquals(true, result);//Execution result
        //System.assertEquals(true, outMap.containsKey('pdfData')); //Main node
        //System.assertEquals(true, outMap.containsKey('state')); //State at the main node level
        //Map<String,Object> pdfDataMap = (Map<String,Object>)outMap.get('pdfData');//If success get pdfDataMap
        //System.assertEquals(true, pdfDataMap.containsKey('Fee1'));//Verify fee1
        //System.assertEquals(true, pdfDataMap.containsKey('Fee2'));//Verify fee2
        //System.assertEquals(true, pdfDataMap.containsKey('Fee3'));//Verify fee3
        //System.assertEquals(true, pdfDataMap.containsKey('Fee4'));//Verify fee4        
    //}
    //@Istest
    //public static void invalidTestWithJohnCenaAccount() {
        //Prepare
        //String methodName = 'getMemberCardPDFDataInvalid';
        //Boolean result = false;
      //  Map<String,Object> input = new Map<String,Object>{'AccountId'=>'INVALID'};
        //try{
       //     OSHMemberCardUtilities obj = new OSHMemberCardUtilities();
            // Execute  
         //   result = obj.invokeMethod(methodName, input, null, null);
        //}catch(Exception e){
         //   system.debug(e);
        //}
        //Validate                     
       // System.assertEquals(false, result);//Execution result
    //}

    @Istest static void validTestWithMockedData() {
        Test.startTest();
        //Prepare
        String methodName = 'getMemberCardPDFData';
        Boolean result = false;
        //Create account
        Account newAccount = new Account(
            LastName = 'testAccount'
        );
        insert newAccount;
        newAccount.Member_ID__pc = newAccount.Id;
        update newAccount;
        //Create contract
        DateTime todaysDate = System.today();
        Contract contractObj = new Contract(
            StartDate = date.newinstance(todaysDate.year(), todaysDate.month(), todaysDate.day()),
            AccountId = newAccount.Id
            );
        insert contractObj;
        //Create asset
       Asset assetObj = new Asset(
            Name= 'AssetTest', 
            AccountId = newAccount.Id, 
            Status = 'Active', 
            Contract__c = contractObj.Id, 
            Group_Code__c = '1NCACLC05'
            ); 
        insert assetObj;   
        //Create contract line items
        vlocity_ins__ContractLineItem__c contractLineItem = new vlocity_ins__ContractLineItem__c(
           vlocity_ins__contractid__c = contractObj.Id, 
            vlocity_ins__attributeselectedvalues__c = '{"DISCLAIMERMEMBERDISC2":"Discount Programs Not Owned or Operated by OneShare Health and  are made available to members by a fee from the contributions","DISCPROGRAM":"Dental, Diabetic Suplies, Durable Medical Equipement, Lab Testing, Hearing Aids, Vision, Vitamins & Supplements Discounts","DISCLAIMERCARD4":"Prescription Discount Programs Not Owned or Operated by OneShare Health","DISCLAIMERCARD3":"(MAP) is not a shared service and is not owned or operated by OneShare Health, LLC, but made available to OneShare Members by Integrated Behavioral Health Solutions (IBH).","DISCLAIMERCARD2":"Telemedicine is not owned or operated by OneShare Health, LLC","DISCLAIMERCARD":"*Out-of-network member sharing reimbursement is based on the lesser of the Out-of-network provider actual billed amount or Maximum Reasonable Guidelines for the Eligible Services provided","BEHAVHEALTH":"24/7 Crisis Management - 4 Counseling Sessions","PROCODE":"OSHCLASSCROWN","ISAAMT":"5000","PRESDISPROG":"Access to Prescription Drug Discounts on Generic and Brand Name Drugs","LIFESHARMAX":"$1,000,000","MAXLIMITINC":"$500,000","HOSTP":"Eligible","INOUTSURG":"Eligible - 90 day wait","MATERNITY":"Eligible - Conception must be after Effective Date","EMERGROOM":"$300 Visit Fee","TELEMED":"Doctor Access 24/7 ( Consult Fee 100% Shared)","SPEC":"$75 Visit Fee","DIAGXLAB":"Eligible","URGCAREFAC":"$20 Visit Fee - 2 Per Program Year","PRICAREPHY":"$20 Visit Fee - 5 Per Program Year","PREVSVCS":"Eligible Expenses 100% Shared up to $1,000 Maximum per program year","PROVNET":"First Health Provider Network"}', 
            name = 'OneShare Classic - Crown'
            );
        insert contractLineItem;
        Map<String,Object> input = new Map<String,Object>{'AccountId'=>newAccount.Id};
       Map<String,Object> outMap = new Map<String,Object>();
        try{
            OSHMemberCardUtilities obj = new OSHMemberCardUtilities();
            // Execute  
           result = obj.invokeMethod(methodName, input, outMap, null);
        }catch(Exception e){
            system.debug(e);
        }
        //Validate                     
        System.assertEquals(true, result);//Execution result
        System.assertEquals(true, outMap.containsKey('pdfData')); //Main node
        System.assertEquals(true, outMap.containsKey('state')); //State at the main node level
        Map<String,Object> pdfDataMap = (Map<String,Object>)outMap.get('pdfData');//If success get pdfDataMap
        System.assertEquals(true, pdfDataMap.containsKey('Fee1'));//Verify fee1
        System.assertEquals(true, pdfDataMap.containsKey('Fee2'));//Verify fee2
        System.assertEquals(true, pdfDataMap.containsKey('Fee3'));//Verify fee3
        System.assertEquals(true, pdfDataMap.containsKey('Fee4'));//Verify fee4    
       Test.stopTest();    
    }
}