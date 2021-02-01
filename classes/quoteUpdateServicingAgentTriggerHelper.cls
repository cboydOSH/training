public class quoteUpdateServicingAgentTriggerHelper {
     public static void processQuoteAfterCreation(List<Quote> listOfQuotes){
        //Declare the list of quotes to modify
        List<Quote> quotes = new List<Quote>();
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
        for(Quote quoteObj : listOfQuotes){
            //Get Member account data
            Quote quoteBeingModified = [Select Id, CreatedById, Servicing_Agent__c, Agent_Label__c From Quote WHERE Id =: quoteObj.Id];
            //Get user that created the account
            List<User> users = [Select AccountId, Name, LastName, ProfileId, FirstName, Email From User Where Id = :quoteBeingModified.CreatedById];
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
                    if(rt.Id == userAccount.RecordTypeId){
                        producer = true;
                    }
                }
            }
            //Starting comparison
            if(userProfile == memberCommunityProfileId){ // MEMBER
                quoteBeingModified.Servicing_Agent__c = selfServiceAccount.Id;
                quoteBeingModified.Agent_Label__c = genericAssociateAccount.Id;
            }else if(userAccount != null && producer){ // PRODUCER
                OshFindAdditionalFeeHierarchy oshfindObj = new OshFindAdditionalFeeHierarchy();
                oshfindObj.geTopOfAccount(userAccount);
                quoteBeingModified.Servicing_Agent__c = oshfindObj.accountGlobalId;
                quoteBeingModified.Agent_Label__c = userAccount.Id;
            }else if(userProfile ==  guestUserProfileId){ // MEMBER - guest
                quoteBeingModified.Servicing_Agent__c = selfServiceAccount.Id;
                quoteBeingModified.Agent_Label__c = genericAssociateAccount.Id;
            }else{ //OSH EMPLOYEE
                //quoteBeingModified.Servicing_Agent__c = oshEnrollment.Id;
                quoteBeingModified.Agent_Label__c = genericAssociateAccount.Id;
            }
            quotes.add(quoteBeingModified);
        }
        update quotes;
    }
}