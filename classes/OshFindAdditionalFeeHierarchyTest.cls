@IsTest global with sharing class OshFindAdditionalFeeHierarchyTest {

    @isTest static void testWithUserMemberCommunityAdminTest() {
       Test.startTest();
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
       //Method name
       String method = 'sgsFeeHierarchy';
       //Input
       Map<String,Object> input = new Map<String,Object>();
       //output
          Map<String,Object> outMap = new Map<String,Object>();
       //options map
       Map<String,Object> optionsMap = new Map<String,Object>{
           'userId'=> userM.Id
       };
       Boolean success = false;
       //run as created user
       System.runAs(userM){
            OshFindAdditionalFeeHierarchy class1 = new OshFindAdditionalFeeHierarchy();
            success = class1.invokeMethod(method, input, outMap, optionsMap);
        }
       System.assertEquals(true, success);
       Test.stopTest();
    }

    @isTest static void testWithGuestUser() {
        Test.startTest();
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
        //Method name
        String method = 'sgsFeeHierarchy';
        //Input
        Map<String,Object> input = new Map<String,Object>();
        //output
           Map<String,Object> outMap = new Map<String,Object>();
        //options map filled with guest user
        Map<String,Object> optionsMap = new Map<String,Object>{
            'userId'=> guestUser.Id
        };
        Boolean success = false;
        //run as created user
        System.runAs(guestUser){
             OshFindAdditionalFeeHierarchy class1 = new OshFindAdditionalFeeHierarchy();
             success = class1.invokeMethod(method, input, outMap, optionsMap);
         }
        System.assertEquals(true, success);
        Test.stopTest();
     }
    
    
     @isTest static void testWithProducerUser() {
       Test.startTest();
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
       Contact c = createContact(userAccount.Id, 'prodtest', 'prodtest', 'prod@test.com', 'English');
       //Get memberCommunityAdminTestProfile
       List<Profile> profileProducer = [SELECT Id FROM Profile WHERE Name = 'Data Model Producer' limit 1];    //Producer
       //Create user
       User userP = createUserWithContactAndManager('produc', 'prodc', 'produceruser@testorg.com', 'UTF-8', 'produc', 'en_US', profileProducer[0].Id, 'America/Los_Angeles', c.Id, guestUser.Id);
       //Method name
       String method = 'sgsFeeHierarchy';
       //Input
       Map<String,Object> input = new Map<String,Object>();
       //output
          Map<String,Object> outMap = new Map<String,Object>();
       //options map
       Map<String,Object> optionsMap = new Map<String,Object>{
           'userId'=> userP.Id
       };
       Boolean success = false;
       //run as created user
       System.runAs(userP){
            OshFindAdditionalFeeHierarchy class1 = new OshFindAdditionalFeeHierarchy();
            success = class1.invokeMethod(method, input, outMap, optionsMap);
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
}