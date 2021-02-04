/**
* @Attentis Consulting Inc 
* Mauricio Diaz - mauricio@attentisconsulting.com / Vicente Martinez - vicente.martinez@arcsona.com
* Apex Class to handle all Individual / Medicare Remote Action Methods 
***/
global without sharing class OshFindAdditionalFeeHierarchy implements vlocity_ins.VlocityOpenInterface2 { 

    public OshFindAdditionalFeeHierarchy(){
        accounts = new List<Account>();
    }

    public String accountGlobalId {get;set;}
    public List<Account> accounts {get;set;}

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
   { 
       Boolean result = false;
       if('sgsFeeHierarchy'.equalsIgnoreCase(methodName)) {
           system.debug('1');
           result = sgsFeeHierarchy(input,outMap,options);
       }
       return result;
       
   }

   /*
       @descp: Method Search Montlhy Fee of Hierarcy from Apex. 
   */
   public Boolean sgsFeeHierarchy(Map<String, Object> input, Map<String, Object> outMap,Map<String, Object> options){
        //Get User Id from input
        String userId = (String) options.get('userId');  
        String userProfile = '';    
        Decimal monthlyFeeTemp = 0;
        Account userAccount = null;
        Map<String, Object> writingAgentGetMap = new Map<String, Object>();
        accounts = new List<Account>();
        //String partnerCommunityUserId = [SELECT Id FROM Profile where Name = 'Partner Community Login User'].get(0).Id;
        Account genericAccount = [SELECT Id, Name, LastName, FirstName, Contract_Level__c FROM Account where Name = 'associate'].get(0);
        List<RecordType> producerRecordTypeIds = [SELECT Id  FROM RecordType WHERE Name = 'Producer'];
        //system.debug('partnerCommunityUserId: ' + partnerCommunityUserId);
        system.debug('producerRecordTypeIds: ' + producerRecordTypeIds);
        system.debug('userId: ' + userId);
        //If present
        if(userId != null && userId != ''){
            //User
            List<User> users = [Select AccountId, Name, LastName, ProfileId, FirstName, Email From User Where Id = :userId];
            User userObj = users.get(0);
            userProfile = userObj.ProfileId;
            system.debug('userObj: ' + userObj);
            system.debug('userObj.ProfileId: ' + userObj.ProfileId);
            system.debug('userObj.AccountId: ' + userObj.AccountId);
            if(userObj.Email!=null){
                outMap.put('UserEmail', userObj.Email);
            }
            // Get Account Id
            String accountIdValue = userObj.AccountId;
            Boolean producer = false;
            // If user has an account asociated
            if(accountIdValue != null && accountIdValue != ''){
                // Get Account Object
                userAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId, RecordTypeId, Contract_Level__c  From Account Where Id =:accountIdValue];
                system.debug('userAccount: ' + userAccount);
                for(RecordType rt:producerRecordTypeIds){
                    if(rt.Id == userAccount.RecordTypeId){
                        producer = true;
                    }
                }
            }
            Account topAccount = null;
            if(userProfile == [SELECT Id FROM Profile where Name = 'Member Community Admin Test' limit 1].Id ){
                //topAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Name = 'OSH Enrollment'];
                topAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Name = 'Self-Service Enrollment'];
                outMap.put('UserType', 'Member');
                outMap.put('MonthlyFee', topAccount.Monthly_Commission_Fee__c);
                outMap.put('ServicingAgent', topAccount.Id);
                outMap.put('WritingAgent', userId);
                outMap.put('AgentLabel', genericAccount.Id);
                outMap.put('AgentFirstName', genericAccount.FirstName);
                outMap.put('AgentLastName', genericAccount.LastName);
               
                Profile guestPorfile = [SELECT Id FROM Profile WHERE Name = 'Member Community Profile' LIMIT 1];
                if ( guestPorfile != null ) {
                    User guestUser  = [Select Id From User Where ProfileId =: guestPorfile.Id LIMIT 1];
                    outMap.put('guestUserId', guestUser.Id);
                }

                writingAgentGetMap.put('AccountId', genericAccount.Id);
                writingAgentGetMap.put('ProfileId', userObj.ProfileId);
                writingAgentGetMap.put('Name', userObj.Name);
                writingAgentGetMap.put('LastName', userObj.LastName);
                writingAgentGetMap.put('FirstName', userObj.FirstName);
                writingAgentGetMap.put('Email', userObj.Email);
                writingAgentGetMap.put('ContractLevel', genericAccount.Contract_Level__c);

                outMap.put('writingAgentGet', writingAgentGetMap);

                Map<String, Object> attributesMap2 = new Map<String, Object>();
                attributesMap2.put('Monthly_Commission_Fee__c', topAccount.Monthly_Commission_Fee__c);
                attributesMap2.put('Name', topAccount.Name);
                attributesMap2.put('Id', topAccount.Id);

                outMap.put('SelectedServicingAgentDropdown', attributesMap2);
                System.debug('userProfile is Member Community Admin Test ><');
            }else if(userAccount != null && producer){
            // Compare if is a producer.
            // if(userAccount != null && userProfile == partnerCommunityUserId && producer){
                try{
                    // Get top Account
                    geTopOfAccount(userAccount);
                    // Get top Account Object
                    topAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Id =:accountGlobalId];
                    Contact agentContact = [Select Id, Name, FirstName, LastName from Contact Where AccountId =: userAccount.Id];
                    outMap.put('UserType', 'Producer');
                    outMap.put('MonthlyFee', topAccount.Monthly_Commission_Fee__c);
                    outMap.put('ServicingAgent', topAccount.Id);
                    outMap.put('WritingAgent', userId);
                    outMap.put('AgentLabel', userAccount.Id);
                    Map<String,Object> genAcc = new Map<String,Object>();
                    genAcc.put('id', userAccount.Id);
                    genAcc.put('AgentFirstName', agentContact.FirstName);
                    genAcc.put('AgentLastName', agentContact.LastName);
                    genAcc.put('FullName', agentContact.Name);
                    outMap.put('Agent', genAcc);
                    //outMap.put('ContractLevel', userAccount.Contract_Level__c);

                    writingAgentGetMap.put('AccountId', userAccount.Id);
                    writingAgentGetMap.put('ProfileId', userObj.ProfileId);
                    writingAgentGetMap.put('Name', userObj.Name);
                    writingAgentGetMap.put('LastName', userObj.LastName);
                    writingAgentGetMap.put('FirstName', userObj.FirstName);
                    writingAgentGetMap.put('Email', userObj.Email);
                    writingAgentGetMap.put('ContractLevel', userAccount.Contract_Level__c);

                    outMap.put('writingAgentGet', writingAgentGetMap);

                    Map<String, Object> attributesMap2 = new Map<String, Object>();
                    attributesMap2.put('Monthly_Commission_Fee__c', topAccount.Monthly_Commission_Fee__c);
                    attributesMap2.put('Name', topAccount.Name);
                    attributesMap2.put('Id', topAccount.Id);

                    outMap.put('SelectedServicingAgentDropdown', attributesMap2);

                    outMap.put('AccountHierarchy', accounts);
                    System.debug('userProfile is Producer ><');
                }catch(Exception e){
                    outMap.put('MonthlyFee', 'Not Found');
                    outMap.put('ServicingAgent', 'Not Found');
                    outMap.put('WritingAgent', 'Not Found');
                    outMap.put('WritingAgent', 'Not Found');
                }
            // else if is a guest user
            }else if(userProfile == [SELECT Id FROM Profile where Name = 'Member Community Profile'].get(0).Id ){
                    //topAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Name = 'OSH Enrollment'];
                    topAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Name = 'Self-Service Enrollment'];
                    outMap.put('UserType', 'Guest');
                    outMap.put('MonthlyFee', topAccount.Monthly_Commission_Fee__c);
                    outMap.put('ServicingAgent', topAccount.Id);
                    outMap.put('WritingAgent', userId);
                    outMap.put('AgentLabel', genericAccount.Id);
                    //outMap.put('ContractLevel', genericAccount.Contract_Level__c);

                    writingAgentGetMap.put('AccountId', genericAccount.Id);
                    writingAgentGetMap.put('ProfileId', userObj.ProfileId);
                    writingAgentGetMap.put('Name', userObj.Name);
                    writingAgentGetMap.put('LastName', userObj.LastName);
                    writingAgentGetMap.put('FirstName', userObj.FirstName);
                    writingAgentGetMap.put('Email', userObj.Email);
                    writingAgentGetMap.put('ContractLevel', genericAccount.Contract_Level__c);

                    outMap.put('writingAgentGet', writingAgentGetMap);

                    Map<String, Object> attributesMap2 = new Map<String, Object>();
                    attributesMap2.put('Monthly_Commission_Fee__c', topAccount.Monthly_Commission_Fee__c);
                    attributesMap2.put('Name', topAccount.Name);
                    attributesMap2.put('Id', topAccount.Id);

                    outMap.put('SelectedServicingAgentDropdown', attributesMap2);
                    System.debug('userProfile is Guest ><');
            //else it is a OSH employee
            }else{
                Account oshAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Name = 'OSH Enrollment' LIMIT 1];
                outMap.put('UserType', 'OSH Employee');
                outMap.put('MonthlyFee', 0);
                outMap.put('ServicingAgent', 'Needs Dropdown selection');
                outMap.put('WritingAgent', userId);
                outMap.put('AgentLabel', genericAccount.Id);
                
                //outMap.put('ContractLevel', genericAccount.Contract_Level__c);
                outMap.put('AccountsForOSHEmployees', getAllTopOfAccounts());
                outMap.put('OSHServicingAgent', oshAccount.Id);

                writingAgentGetMap.put('AccountId', genericAccount.Id);
                writingAgentGetMap.put('ProfileId', userObj.ProfileId);
                writingAgentGetMap.put('Name', userObj.Name);
                writingAgentGetMap.put('LastName', userObj.LastName);
                writingAgentGetMap.put('FirstName', userObj.FirstName);
                writingAgentGetMap.put('Email', userObj.Email);
                writingAgentGetMap.put('ContractLevel', genericAccount.Contract_Level__c);

                outMap.put('writingAgentGet', writingAgentGetMap);
                System.debug('userProfile is not Member, Producer, nor Guest ><');
            }
        }
        return true;
     }    

    // Recursive method to find Top Account (ParentId)
    public void geTopOfAccount (Account acc){
        accounts.add(acc);
        String parentId = acc.ParentId;
        if( parentId  == null || parentId == '' ){
            accountGlobalId = acc.Id;
        }else{
            if(parentId != null){
                Account accParent = [Select Id, Name, Monthly_Commission_Fee__c, ParentId, RecordTypeId, Contract_Level__c  From Account Where Id =:parentId];
                geTopOfAccount(accParent);
            }
        }
   }

   // Method to find Top Account (ParentId)
   public List<Account> getAllTopOfAccounts (){
       return [SELECT Id, Name, Monthly_Commission_Fee__c FROM Account where RecordTypeId IN (SELECT Id  FROM RecordType WHERE Name = 'Producer') AND ParentId ='' AND Allow_Enrollment_by_OSH__c = 'Yes'];
   }
}