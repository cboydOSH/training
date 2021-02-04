global without sharing class UpsertOpportunityLead implements vlocity_ins.VlocityOpenInterface2 {
    
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    if(methodName == 'upsertOpportunityLeadForMember') {
            return upsertOpportunityLeadForMember(inputMap, outMap, options);                
        }
        return false;
    }
    
    public Boolean upsertOpportunityLeadForMember(Map<String, Object> input, Map<String, Object> outMap,Map<String, Object> options){ 

        List<Object> accounts = (List<Object>) input.get('Account_1');
        Map<String, Object> mapAccount = (Map<String,Object>) accounts[0];
        
        Map<String, Object> mapLetsGetStarted = (Map<String,Object>)input.get('letsGetStarted');
        Map<String, Object> BlkNoExistingInfoPacket = (Map<String,Object>)mapLetsGetStarted.get('BlkNoExistingInfoPacket');
        
        List<Object> addEditFamMember = (List<Object>) input.get('AddEditFamilyMember');
        Map<String, Object> mapAddEditFamilyMember = (Map<String,Object>) addEditFamMember[0];
        
        Map<String, Object> mapSelectedServicingAgent = (Map<String,Object>)input.get('SelectedServicingAgentDropdown');
        Map<String, Object> mapMyFamily = (Map<String,Object>)input.get('myFamily');
        
        String accountId = (String) mapAccount.get('Id');
        String accountFirstName = (String) BlkNoExistingInfoPacket.get('fName');
        String accountLastName = (String) BlkNoExistingInfoPacket.get('lName');
        DateTime dt = DateTime.now();
        String todayFormatted = dt.format('yyyy-MM-dd HH:mm:ss');
        String opportunityRecordType = (String) mapAddEditFamilyMember.get('opportunityRecordType');
        Date closeDate = Date.today();
        Decimal monthlyCommissionFee = (Decimal) mapSelectedServicingAgent.get('Monthly_Commission_Fee__c');
        String leadID = (String) input.get('DRId_Lead');
        String leadRecordType = (String) input.get('internalLeadRecordType');
        String language = (String) mapMyFamily.get('WhatPrimaryLanguageSpoken');
            
        Opportunity opp = new Opportunity();
        
        System.debug('Input'+ input);
        opp.AccountId = accountId;
        opp.StageName = 'Qualification';
        //opp.StageName = 'Prospecting';
        opp.Name = accountFirstName + ' ' + accountLastName + ' ' + todayFormatted;
        opp.CloseDate = closeDate;
        //opp.RecordTypeId = opportunityRecordType;
        opp.Monthly_Contribution__c = monthlyCommissionFee;
        opp.AcctOpp_Lock__c = true;
        
        Database.SaveResult result = Database.insert(opp);       
        
        
        if (result.isSuccess()){
            Map<String, Object> opportunity_2 = new Map<String,Object>();
            opportunity_2.put('UpsertSuccess', true);
            opportunity_2.put('Id', opp.Id);
            opportunity_2.put('StageName', opp.StageName);
            //opportunity_2.put('RecordTypeId', opp.RecordTypeId);
            opportunity_2.put('Name', opp.Name);
            opportunity_2.put('CloseDate', opp.CloseDate);
            opportunity_2.put('AccountId', opp.AccountId);
            opportunity_2.put('Monthly_Contribution__c', opp.Monthly_Contribution__c);
            String oppJSON = JSON.serialize(opportunity_2);
            outMap.put('Opportunity_2', opportunity_2);
        } else {
            Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs)
                    System.debug(err.getStatusCode() + ' - ' + err.getMessage());
       }
        
        
       Lead accLead = [SELECT Id, Parent_Account__c FROM Lead WHERE Id = :leadID LIMIT 1];
       System.debug('LEAD => ' + accLead);

       if (accLead != null){
            accLead.RecordTypeId = leadRecordType;
            accLead.Primary_Language_Spoken__c = language;
            accLead.Parent_Account__c = accountId;
            
            Database.SaveResult leadResult = Database.update(accLead);
            
            if (leadResult.isSuccess()){
                Map<String, Object> lead_3 = new Map<String,Object>();
                lead_3.put('UpsertSuccess', true);
                lead_3.put('RecordTypeId', accLead.RecordTypeId);
                lead_3.put('Primary_Language_Spoken__c', accLead.Primary_Language_Spoken__c);
                lead_3.put('Parent_Account__c', accLead.Parent_Account__c);
                lead_3.put('Id', accLead.Id);
                //String leadJSON = JSON.serialize(lead_3);
                outMap.put('Lead_3', lead_3);
            } else {
                Database.Error[] errors = leadResult.getErrors();
                    for(Database.Error err : errors)
                        System.debug(err.getStatusCode() + ' - ' + err.getMessage());
            }
        } else {
            System.debug('Unable to find lead for this account');
        }
  
        return true;
    }

}