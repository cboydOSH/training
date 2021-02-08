@isTest
public class OSH_AccountMemberCreationTest {
 
    @testSetup
    public static void setup() {
       	//Create Account
        RecordType rtAcct = [SELECT Id from RecordType WHERE SobjectType = 'Account' limit 1];
    	Account acc= new Account(Name = 'Test Account', RecordType = rtAcct);
    	insert acc;
        //Create Contact
        Contact c = new Contact();
   	 	c.AccountId = acc.ID;
    	c.FirstName = 'test';
    	c.LastName = 'test';
    	c.email = 'test@test.com';
    	c.birthdate = Date.newInstance(1992, 04, 12);
        insert c;  
        //Create Opp
        Opportunity opp = new Opportunity (Name = 'Opp Name', StageName= 'Prospecting', CloseDate = Date.newInstance(2024, 12, 9));
        insert opp;
        //Create Quote
        Quote qu = new Quote(Name= 'Quote Test', OpportunityId = opp.Id); 
        insert qu;
        //Create userAccount
        Account userAccount = createSimpleAccount('userAccount2');
        //Create Contact
        Contact con = createContact(userAccount.Id, 'test2', 'test2', 'test2@test2.com', 'English');
        //Get memberCommunityAdminTestProfile
        List<Profile> profileMemberCommunityAdminTest = [SELECT Id FROM Profile WHERE Name = 'Member Community Admin Test' limit 1];//Member Community Admin Test 
        //Create producer user
        User userM = createUserWithContact('standt', 'standt', 'standarduser@testorg.com', 'UTF-8', 'standt', 'en_US', profileMemberCommunityAdminTest[0].Id, 'America/Los_Angeles', con.Id);
        //Get systemadminprofile
        List<Profile> profileSysAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];//Member Community Admin Test 
        //Create guestUser generic
        User guestUser = createUser('guest', 'Owner', 'vicente.martinez@arcsona.com', 'UTF-8', 'Guest User', 'en_US', profileSysAdmin[0].Id, 'America/Los_Angeles');
        //Create Lead
        //create Lead
        Lead newLead = new Lead(FirstName='LeadTestoDaio',LastName='LeadTestoDaio');
        insert newLead;
    }

    @isTest
    static void createUserAccountTest() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Account acc = [SELECT Id, OwnerId FROM Account WHERE Name = 'Test Account'];
        system.debug('acc' + acc);
        Contact con = [SELECT Id, Email FROM Contact WHERE email = 'test@test.com'];
        Map<String,Object> accountMap= new Map<String,Object>();
        Map<String,Object> welcomeMap= new Map<String,Object>();
        
        User userM = [SELECT Id, Alias ,FirstName ,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName,ContactId FROM User WHERE Email = 'standarduser@testorg.com' ];
        

        accountMap.put('Id', acc.Id);
        welcomeMap.put('Email', con.Email);
        inputMap.put('Account', accountMap);
        inputMap.put('Welcome', welcomeMap);
        inputMap.put('Account', accountMap);
        inputMap.put('OwnerId', acc.OwnerId);
        inputMap.put('userId', userM.Id);

        OSH_AccountMemberCreation ins = new OSH_AccountMemberCreation();
        Boolean ret = false;
        ret = ins.invokeMethod('createUserAccount', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
    
    @isTest
    static void createUserAfterQuoteProcessTest() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        User userM = [SELECT Id, Alias ,FirstName ,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,ProfileId ,TimeZoneSidKey,UserName,ContactId FROM User WHERE Email = 'standarduser@testorg.com' ];

        //Fill input
        Quote quote = [SELECT Id, OwnerId FROM Quote WHERE Name = 'Quote Test'];
        Account accTest = [SELECT Id, OwnerId FROM Account WHERE Name = 'Test Account'];
        Lead lead = [SELECT Id, FirstName, LastName FROM Lead Where FirstName = 'LeadTestoDaio'];

        inputMap.put('QuoteIdDecrypted', quote.Id);
        inputMap.put('DRId_Lead', lead.Id);

        Map<String, Object> mapReviewQuote = new Map<String, Object>();
        Map<String,Object> UserCreationBlock = new Map<String, Object>();

        UserCreationBlock.put('UserPassword', 'AABBCCDD2355');
        mapReviewQuote.put('UserCreationBlock', UserCreationBlock);
        options.put('UserDosentExist', mapReviewQuote);

        List<Object> acc= new  List<Object>();
        Map<String, Object> accFirst = new  Map<String, Object>();
        accFirst.put('PersonEmail', 'accTest@gmail.com');
        accFirst.put('Id', accTest.Id);
        acc.add(accFirst);

        inputMap.put('Account_1', acc);

        OSH_AccountMemberCreation ins = new OSH_AccountMemberCreation();
        Boolean ret;
        System.runAs(userM){
            ret = ins.invokeMethod('createUserAfterQuoteProcess', inputMap, outMap, options);
        }
        System.assertEquals(ret, true);
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
            UserName=emailVar,
            ManagerId = UserInfo.getUserId()
        );
        insert userM;
        System.debug('NEW USER => ' + userM);
        return userM;
     }
}