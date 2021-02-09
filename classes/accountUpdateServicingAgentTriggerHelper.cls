public class accountUpdateServicingAgentTriggerHelper {
    public static void processAccountAfterCreation(List<Account> listOfAccounts){
        //Get applicable record types
        RecordType primaryAccountRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Primary_Member'].get(0);
        RecordType dependentAccountRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Dependent'].get(0);
        //Declare the list of accounts to modify
        List<Account> accounts = new List<Account>();
        //Stalish the member community profile id
        String memberCommunityProfileId = [SELECT Id FROM Profile where Name = 'Member Community Admin Test' limit 1].Id;
        //Stablish the guest user profile id
        String guestUserProfileId = [SELECT Id FROM Profile where Name = 'Member Community Profile'].get(0).Id;
        //Stablish generic account associate
        Account genericAssociateAccount = null;
        List<Account> listOfAssociateAccount =[SELECT Id, Name, LastName, FirstName, Contract_Level__c FROM Account where Name = 'associate'];
        if(listOfAssociateAccount.size()>0){
            genericAssociateAccount = listOfAssociateAccount.get(0);
        }
        //Stablish self-service generic account applicable for member / guest users
        Account selfServiceAccount = null;
        List<Account> listOfSelfServiceAccount = [SELECT Id, Name, Monthly_Commission_Fee__c, ParentId FROM Account Where Name = 'Self-Service Enrollment'];
        if(listOfSelfServiceAccount.size()>0){
            selfServiceAccount = listOfSelfServiceAccount.get(0);
        }
        //Stablish self-service generic account applicable for member / guest users
        Account oshEnrollment = null;
        List<Account> listOfSOHAccount = [SELECT Id, Name, Monthly_Commission_Fee__c, ParentId FROM Account Where Name = 'OSH Enrollment'];
        if(listOfSOHAccount.size()>0){
            oshEnrollment = listOfSOHAccount.get(0);
        }
        //Stablish entire record types related with the producer
        List<RecordType> producerRecordTypeIds = [SELECT Id  FROM RecordType WHERE Name = 'Producer'];
        //for each account created
        for(Account accountObj : listOfAccounts){
            //Get Member account data
            Account accountBeingModified = [Select Id, CreatedById, Servicing_Agent__c, Agent_Label__pc, RecordTypeId From Account WHERE Id =: accountObj.Id];
            if(accountBeingModified.RecordTypeId == primaryAccountRecordType.Id || accountBeingModified.RecordTypeId == dependentAccountRecordType.Id ){
                //Get user that created the account
                List<User> users = [Select AccountId, Name, LastName, ProfileId, FirstName, Email From User Where Id = :accountBeingModified.CreatedById];
                User userObj = users.get(0);
                String userProfile = userObj.ProfileId;
                Boolean producer = false;
                Account userAccount = null;
                // Get Account Id OF THE USER THAT CREATED THE ACCOUNT
                String accountIdValue = userObj.AccountId;
                if(accountIdValue != null && accountIdValue != ''){
                    // Get Account Object
                    userAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId, RecordTypeId, Contract_Level__c From Account Where Id =:accountIdValue];
                    system.debug('userAccount: ' + userAccount);
                    for(RecordType rt:producerRecordTypeIds){
                        system.debug('Comparing');
                        if(rt!=null && rt.Id == userAccount.RecordTypeId){
                            producer = true;
                        }
                    }
                }
                system.debug('After If: '+ userProfile + ' , ' +memberCommunityProfileId+' , '+ guestUserProfileId);
                system.debug('After If selfServiceAccount: '+ selfServiceAccount);
                system.debug('After If genericAssociateAccount: '+ genericAssociateAccount);
                //Starting comparison
                if(userProfile == memberCommunityProfileId){ // MEMBER
                    accountBeingModified.Servicing_Agent__c = selfServiceAccount.Id;
                    accountBeingModified.Agent_Label__pc = genericAssociateAccount.Id;
                }else if(userAccount != null && producer){// PRODUCER
                    OshFindAdditionalFeeHierarchy oshfindObj = new OshFindAdditionalFeeHierarchy();
                    oshfindObj.geTopOfAccount(userAccount);
                    accountBeingModified.Servicing_Agent__c = oshfindObj.accountGlobalId;
                    accountBeingModified.Agent_Label__pc = userAccount.Id;
                }else if(userProfile ==  guestUserProfileId){// MEMBER - GUEST
                    accountBeingModified.Servicing_Agent__c = selfServiceAccount.Id;
                    accountBeingModified.Agent_Label__pc = genericAssociateAccount.Id;
                }else{ // OSH EMPLOYEE
                    //accountBeingModified.Servicing_Agent__c = oshEnrollment.Id;
                    //accountBeingModified.Agent_Label__pc = genericAssociateAccount.Id;
                }
                accounts.add(accountBeingModified);
            }
        }
        if(accounts.size()>0){
            update accounts;
        }
    }
}