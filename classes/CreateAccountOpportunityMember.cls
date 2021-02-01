global without sharing class CreateAccountOpportunityMember implements vlocity_ins.VlocityOpenInterface2{

    //this should create an Account, an Opportunity, and then link the preexisting Lead to the Account
    
    //esa es una List<Object> list = (List<Object>)inputMap.get('Additionalblahblahblah');
    //y accedes con
    //list.get(0);
    //que seria un
    //Map<String,Object> obj = (Map<String,Object>) list.get(0);
    
    
    
    
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    if(methodName == 'createAccountOpportunityForMember') {
            return createAccountOpportunityForMember(inputMap, outMap, options);                
        }
        return false;
    }
    
    
        public Boolean createAccountOpportunityForMember(Map<String, Object> input, Map<String, Object> outMap,Map<String, Object> options){
        
        Map<String, Object> mapLetsGetStarted = (Map<String,Object>)input.get('letsGetStarted');
            
        Map<String, Object> mapMyFamily = (Map<String,Object>)input.get('myFamily');
            
        Map<String, Object> mapAccForOSHEmployees = (Map<String,Object>)input.get('AccountsForOSHEmployees');    
            
        Map<String, Object> mapAddEditFamilyMember = (Map<String,Object>)input.get('AddEditFamilyMember');
        Map<String, Object> mapFirstFamilyMember = (Map<String,Object>)mapAddEditFamilyMember.get('0');
            
        Map<String, Object> mapServicingAgent = (Map<String,Object>)input.get('SelectedServicingAgentDropdown');
        Map<String, Object> mapSelectedServicingAgent = (Map<String,Object>)mapServicingAgent.get('attributes');
            
		Map<String, Object> mapTellUsAboutYou = (Map<String,Object>)input.get('tellUsAboutYou');
        Map<String, Object> mapTellUsAboutYouFields = (Map<String,Object>)mapTellUsAboutYou.get('tellUsAboutYouFields');
            
        Map<String, Object> mapAccountCreation = (Map<String,Object>)input.get('BlkNoExistingInfoPacket');
        Map<String, Object> mapAccountAddress = (Map<String,Object>)mapAccountCreation.get('TAAddressGoogle-Block');
            
        
        String accountFirstName = (String)mapAccountCreation.get('fName');
        String accountLastName = (String)mapAccountCreation.get('lName');
        String accountEmail = (String)mapAccountCreation.get('Email1');
        String accountPhone = (String)mapAccountCreation.get('Telephone1');
            
        Decimal accountMonthlyComissionFee = (Decimal)mapSelectedServicingAgent.get('Monthly_Commission_Fee__c');
        String accountServicingAgent = (String)mapSelectedServicingAgent.get('Name');
        
        String accountMemberRecordType = (String)mapAddEditFamilyMember.get('primaryMemberRecordType');
        String accountPersonGender = (String)mapFirstFamilyMember.get('gender');
        Date accountPersonDOB = (Date)mapFirstFamilyMember.get('dob');
        String accountPersonRelationship = (String)mapFirstFamilyMember.get('relationship');
            
        String accountAgentId = (String)mapAccForOSHEmployees.get('AgentLabel');
        String accountWritingAgentId = (String)mapAccForOSHEmployees.get('WritingAgent');
        
            
        String accountPriLanguage = (String)mapMyFamily.get('WhatPrimaryLanguageSpoken');
        String accountCurrSpecialist = (String)mapTellUsAboutYouFields.get('RadiofamilycurrSpecialist');
        String accountExpectingFamilyGrow = (String)mapTellUsAboutYouFields.get('RadioCurrExpctibgStartfamily');
        String accountHowOftenPCP = (String)mapTellUsAboutYouFields.get('MSHowOftenPCP');
            
        String accountStreet = (String)mapAccountAddress.get('address');
        String accountBldSuiteApart = (String)mapAccountAddress.get('buildingSuiteApartment');
        String accountCity = (String)mapAccountAddress.get('City');
        String accountCountry = (String)mapAccountAddress.get('Country');
        String accountState = (String)mapAccountAddress.get('State');
        String accountGoogaccountdress = (String)mapAccountAddress.get('TAAddressGoogle');
        String accountZipCode = (String)mapAccountAddress.get('zipCode');    
        
        account acc = new account();
            acc.Name = accountFirstName + ' ' + accountLastName;
            acc.FirstName = accountFirstName;
            acc.LastName = accountLastName;
            acc.PersonEmail = accountEmail;
            acc.Phone = accountPhone;
            
            acc.Primary_Language_Spoken__c = accountPriLanguage;
            acc.Currently_see_a_Specialist__c = accountCurrSpecialist;
            acc.Expecting_family_grow__c = accountExpectingFamilyGrow;
            acc.How_often_See_your_PCP__c = accountHowOftenPCP;
            
            acc.Monthly_Commission_Fee__c = accountMonthlyComissionFee;
            acc.Servicing_Agent__c = accountServicingAgent;
            
            acc.RecordTypeId = accountMemberRecordType;
            acc.vlocity_ins__Gender__pc = accountPersonGender;
            acc.PersonBirthdate = accountPersonDOB;
            acc.Relationship__pc = accountPersonRelationship;
            
            acc.Agent_Label__pc = accountAgentId;
            acc.Writing_agent__c = accountWritingAgentId;
            
            acc.BillingStreet = accountStreet;
            acc.BillingState = accountState;
            acc.BillingPostalCode = accountZipCode;
            acc.BillingCountry = accountCountry;
            acc.BillingCity = accountCity;
            acc.Google_Address__c = accountGoogaccountdress;
            
            
        	/*OwnerId = '0058A000005BTnm',
        	LeadSource = 'Reserve',
       		FirstName = accountFirstName,
        	LastName = accountLastName,
        	Email = accountEmail,
        	Phone = accountPhone,
        	Street = accountStreet,
        	Building_Suite_Apartment__c = accountBldSuiteApart,
        	City = accountCity,
            Country = accountCountry,
            State = accountState,
            Google_Address__c = accountGoogaccountdress,
            PostalCode = accountZipCode*/
        	
        insert acc;
        
        
        return true;
    }
    
}