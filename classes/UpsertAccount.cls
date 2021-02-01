global without sharing class UpsertAccount implements vlocity_ins.VlocityOpenInterface2 {
    
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if(methodName == 'upsertAccountForProducers') {
            return upsertAccountForProducers(inputMap, outMap, options);
        }else if(methodName == 'callOriginalDR') {
            return callOriginalDR(inputMap, outMap, options);
        }
        return false;
    }

    private Boolean upsertAccountForProducers(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        //Get lets get started json block
        Map<String, Object> mapLetsGetStarted = (Map<String,Object>)inputMap.get('letsGetStarted');
        //Get lead/primary account basic data
        Map<String, Object> mapBlkNoExistingInfoPacket = (Map<String,Object>)mapLetsGetStarted.get('BlkNoExistingInfoPacket');
        //Get lead/primary account address data
        Map<String, Object> mapBlkTAAdressGoogle = (Map<String,Object>)mapBlkNoExistingInfoPacket.get('TAAddressGoogle-Block');
        //Get AddEditFamilyMember block
        List<Object> listAddeditFamilyMember = (List<Object>)inputMap.get('AddEditFamilyMember');
        Map<String,Object> firstAddEditFamilyMember = (Map<String,Object>)listAddeditFamilyMember.get(0);
        //Create Account
        Account accountObj = new Account();
        //Map Lets get started block
        accountObj.PersonEmail = (String)mapBlkNoExistingInfoPacket.get('Email1');
        accountObj.FirstName = (String)mapBlkNoExistingInfoPacket.get('fName');
        accountObj.LastName = (String)mapBlkNoExistingInfoPacket.get('lName');
        accountObj.SSN_ITIN__c = (String)mapBlkNoExistingInfoPacket.get('SSNITIN');
        accountObj.BillingStreet = (String)mapBlkTAAdressGoogle.get('address');
        accountObj.Building_Suite_Apartment__c = (String)mapBlkTAAdressGoogle.get('buildingSuiteApartment');
        accountObj.BillingCity = (String)mapBlkTAAdressGoogle.get('City');
        accountObj.BillingCountry = (String)mapBlkTAAdressGoogle.get('Country');
        accountObj.BillingState = (String)mapBlkTAAdressGoogle.get('State');
        accountObj.Google_Address__c = (String)mapBlkTAAdressGoogle.get('TAAddressGoogle');
        accountObj.BillingPostalCode = (String)mapBlkTAAdressGoogle.get('zipCode');
        accountObj.Phone = (String)mapBlkNoExistingInfoPacket.get('Telephone1');
        //Map addeditfamilymember block
        accountObj.PersonBirthdate = (Date)firstAddEditFamilyMember.get('dob');
        accountObj.Gender__pc = (String)firstAddEditFamilyMember.get('gender');
        accountObj.vlocity_ins__Gender__pc = (String)firstAddEditFamilyMember.get('gender');
        accountObj.Relationship__pc = (String)firstAddEditFamilyMember.get('relationship');
        return false;
    }

    private Boolean callOriginalDR(Map <String, Object> drInput, Map <String, Object> drOutput, Map <String, Object> drOptions) {
        /* Specify DataRaptor load or transform to call */
        String bundleName = 'CreateDummyAccountAndOpportunity'; 
        /* Call the DataRaptor */
        Map<String,Object> bodyData = new Map<String,Object>();
        bodyData.put('bundleName',bundleName);
        bodyData.put('objectList',JSON.serialize(drInput));
        vlocity_ins.DRProcessResult result = vlocity_ins.DRGlobal.processObjectsJSON(JSON.serialize(drInput), bundleName);
        /* Deserialize the DataRaptor output for processing in Apex */ 
        Map<String, Object> resultMap = result.convertToMap();
        Map<String, Object> createdObjectsByType = (Map<String, Object>)resultMap.get('createdObjectsByType'); 
        Map<String, Object> createdObjectsByTypeForBundle = (Map<String, Object>)createdObjectsByType.get(bundleName);
        //Opportunity transformation starts
        List<Object> opportunityList = (List<Object>)createdObjectsByTypeForBundle.get('Opportunity');
        String opportunityId = (String)opportunityList.get(0);
        // drOutput.put('opportunityId', opportunityId);
        // Opportunity opportunityObj = [SELECT Id, StageName, RecordTypeId, Name, CloseDate, AccountId, Monthly_Contribution__c FROM Opportunity where  Id =: opportunityId];
        Map<String,Object> opportunityMap = new Map<String,Object>();
        opportunityMap.put('Id',opportunityId);
        // opportunityMap.put('StageName',opportunityObj.StageName);
        // opportunityMap.put('RecordTypeId',opportunityObj.RecordTypeId);
        // opportunityMap.put('Name',opportunityObj.Name);
        // opportunityMap.put('CloseDate',opportunityObj.CloseDate);
        // opportunityMap.put('AccountId',opportunityObj.AccountId);
        // opportunityMap.put('Monthly_Contribution__c',opportunityObj.Monthly_Contribution__c);
        List<Object> newOpportunityList = new List<Object>();
        newOpportunityList.add(opportunityMap);
        //Opportunity transformation ends
        //Lead transformation starts
        List<Object> leadList = (List<Object>)createdObjectsByTypeForBundle.get('Lead');
        String leadId = (String)leadList.get(0);
        Map<String,Object> leadMap = new Map<String,Object>();
        leadMap.put('Id', leadId);
        List<Object> newLeadList = new List<Object>();
        newLeadList.add(leadMap);
        //Lead transformation ends
        //Accounts transformation starts
        List<Object> accountList = (List<Object>)createdObjectsByTypeForBundle.get('Account');
        String accountId = (String)accountList.get(0);
        Map<String,Object> accountMap = new Map<String,Object>();
        List<Object> newAccountList = new List<Object>();
        accountMap.put('Id', accountId);
        newAccountList.add(accountMap);
        //Accounts transformation ends
        drOutput.put('Lead_3', newLeadList);
        drOutput.put('Opportunity_2', newOpportunityList);
        drOutput.put('Account_1', newAccountList);
        //drOutput = resultMap;
        return true;
    }
    
    /**
    "Account_1": [
    {
      "UpsertSuccess": true,
      "Id": "0018A00000adKP1QAM",
      "Is_Hippa_Authorized__c": true,
      "Writing_agent__c": "0058A000006EWAYQA4",
      "RecordTypeId": "0124P000000uS4rQAE",
      "Agent_Label__pc": "0018A00000acQ06QAE",
      "Servicing_Agent__c": "0018A00000acPzOQAU",
      "Relationship__pc": "Primary",
      "PersonBirthdate": "1990-12-07",
      "vlocity_ins__Gender__pc": "Male",
      "Monthly_Commission_Fee__c": 100,
      "How_often_See_your_PCP__c": "0-1",
      "Expecting_family_grow__c": "No",
      "Currently_see_a_Specialist__c": "Yes",
      "Primary_Language_Spoken__c": "English",
      "Phone": "1232132132",
      "PersonEmail": "micasdasdhael@testasdsa.com",
      "LastName": "Lenovo",
      "FirstName": "Michael",
      "Google_Address__c": "3242 Hampton St, Corpus Christi, TX 78414, USA",
      "Building_Suite_Apartment__c": "asdasd",
      "BillingStreet": "3242 Hampton Street",
      "BillingState": "TX",
      "BillingPostalCode": "78414",
      "BillingCountry": "United States",
      "BillingCity": "Corpus Christi"
    }
  ]
    */
}