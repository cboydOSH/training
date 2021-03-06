@IsTest global without sharing class accountUpdateServicingAgentTriggerTest {

    @isTest static void testWithUserMemberCommunityAdminTest() {
        Test.startTest();
        //Get applicable record types for primary members and dependents
        RecordType primaryAccountRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Primary_Member'].get(0);
        RecordType dependentAccountRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Dependent'].get(0);
        //Declare producer Record type
        String recordTypeIdProducer= [select Id from RecordType where (Name='Producer') and (SobjectType='Account')].Id; // RecordType Producer
        //Create OSH Account
        Account oshAccount = createAccountWithRecordType('OSH Enrollment', recordTypeIdProducer);
        //Create Self-Service Account
        Account selfServiceAccount = createAccountWithRecordType('Self-Service Enrollment', recordTypeIdProducer);
        //Create associate Account
        Account associateAccount = createAccountWithRecordType('associate', recordTypeIdProducer);
        //Get guest user profile
        List<Profile> profileGuestUser = [SELECT Id FROM Profile where Name = 'Member Community Profile' limit 1];  
        //Create guestUser generic
        User guestUser = createUser('guest', 'Andres', 'vicente.martinez@arcsona.com', 'UTF-8', 'Site Guest User', 'en_US', profileGuestUser[0].Id, 'America/Los_Angeles');
        //Create userAccount
        Account userAccount = createSimpleAccount('userAccount');
        //Create Contact
        Contact c = createContact(userAccount.Id, 'test', 'test', 'test@test.com', 'English');
        //Get memberCommunityAdminTestProfile
        List<Profile> profileMemberCommunityAdminTest = [SELECT Id FROM Profile WHERE Name = 'Member Community Admin Test' limit 1];    //Member Community Admin Test 
        //Create user
        User userM = createUserWithContact('standt', 'standt', 'standarduser@testorg.com', 'UTF-8', 'standt', 'en_US', profileMemberCommunityAdminTest[0].Id, 'America/Los_Angeles', c.Id);
        Boolean success = false;
        //Insert account share to the user
        accountShare(oshAccount.Id, userM.Id);
        accountShare(selfServiceAccount.Id, userM.Id);
        accountShare(associateAccount.Id, userM.Id);
        //run as created user
        System.runAs(userM){
            //Create list of Accounts
            List<Account> listOfAccounts = new List<Account>();
            listOfAccounts.add(createPersonAccountWithRecordType('Test Account 1', primaryAccountRecordType.Id));
            listOfAccounts.add(createPersonAccountWithRecordType('Test Account 2', dependentAccountRecordType.Id));
            try{
                accountUpdateServicingAgentTriggerHelper.processAccountAfterCreation(listOfAccounts);
                success = true;
            }catch(Exception e){
                success = false;
            }
         }
        System.assertEquals(true, success);
        Test.stopTest();
     }

     private static Account createAccountWithRecordType(String nameVar, String recordTypeIdVar){
        Account accountObj = new Account(
            RecordTypeID= recordTypeIdVar,
            Name = nameVar
        );
        insert accountObj;        
        System.debug('NEW '+ nameVar +' ACCOUNT => ' + accountObj);
        return accountObj;
     }
 
     private static Account createSimpleAccount(String nameVar){
        Account accountObj = new Account(
            Name = nameVar
        );
        insert accountObj;        
        System.debug('NEW '+ nameVar +' ACCOUNT => ' + accountObj);
        return accountObj;
     }
 
     private static Contact createContact(String userAccountId, String firstName, String lastName, String email, String language){
        Contact c = new Contact(
            AccountId = userAccountId,
            FirstName = firstName,
            LastName = lastName,
            email = email,
            Language__c = language,
            birthdate = Date.newInstance(1992, 04, 12)
        );
        insert c;
         System.debug('NEW Contact => ' + c);
         return c;
     }
 
     private static User createUser(String aliasVar, String firstName, String emailVar, String encodingVar, String lastName, String localekey, String profileId, String timezone){
        User userM = new User(
            Alias = aliasVar,
            FirstName = firstName,
            Email=emailVar, 
            EmailEncodingKey=encodingVar,
            LastName=lastName,
            LanguageLocaleKey=localekey, 
            LocaleSidKey=localekey,
            ProfileId = profileId, 
            TimeZoneSidKey=timezone,
            UserName=emailVar
        );
        insert userM;
        System.debug('NEW USER => ' + userM);
        return userM;
     }
 
     private static User createUserWithContact(String aliasVar, String firstName, String emailVar, String encodingVar, String lastName, String localekey, String profileId, String timezone, String contactId){
         User userM = new User(
             Alias = aliasVar,
             FirstName = firstName,
             Email=emailVar, 
             EmailEncodingKey=encodingVar,
             LastName=lastName,
             LanguageLocaleKey=localekey, 
             LocaleSidKey=localekey,
             ProfileId = profileId, 
             TimeZoneSidKey=timezone,
             UserName=emailVar,
             ContactId = contactId
         );
         insert userM;
         return userM;
     }
     
     private static User createUserWithContactAndManager(String aliasVar, String firstName, String emailVar, String encodingVar, String lastName, String localekey, String profileId, String timezone, String contactId, String managerId){
         User userM = new User(
             Alias = aliasVar,
             FirstName = firstName,
             Email=emailVar, 
             EmailEncodingKey=encodingVar,
             LastName=lastName,
             LanguageLocaleKey=localekey, 
             LocaleSidKey=localekey,
             ProfileId = profileId, 
             TimeZoneSidKey=timezone,
             UserName=emailVar,
             ContactId = contactId,
             ManagerId = managerId
         );
         insert userM;
         return userM;
     }

     private static Account createPersonAccountWithRecordType(String nameVar, String recordTypeIdVar){
        Account accountObj = new Account(
            RecordTypeID= recordTypeIdVar,
            LastName = nameVar,
            Servicing_Agent__c = null,
            Agent_Label__pc = null
        );
        insert accountObj;        
        System.debug('NEW '+ nameVar +' PERSON ACCOUNT => ' + accountObj);
        return accountObj;
     }

     private static void accountShare(String accountId, String portalUserOnSessionId){
        //Account share object in order to share the account with the partner user
        //https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_accountshare.htm
        AccountShare accountShare = new AccountShare();
        accountShare.AccountId = accountId; // Account to share
        accountShare.UserOrGroupId = portalUserOnSessionId; // Sharing with the user running the process
        //accountShare.RowCause = 'PortalImplicit'; // The Account is associated with the portal user.
        accountShare.OpportunityAccessLevel = 'Edit'; // Sharing opportunity
        accountShare.AccountAccessLevel = 'Edit';// Sharing account
        accountShare.CaseAccessLevel = 'Edit';// Sharing cases
        insert accountShare;// Insert account share
    }
}