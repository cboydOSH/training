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
        
    }

    @isTest
    static void createUserAccountTest() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Account acc = [SELECT Id, OwnerId FROM Account WHERE Name = 'Test Account'];
        Contact con = [SELECT Id, Email FROM Contact WHERE email = 'test@test.com'];
        Map<String,Object> accountMap= new Map<String,Object>();
        Map<String,Object> welcomeMap= new Map<String,Object>();
        accountMap.put('Id', acc.Id);
        welcomeMap.put('Email', con.Email);
        inputMap.put('Account', accountMap);
        inputMap.put('Welcome', welcomeMap);
        inputMap.put('Account', accountMap);
        inputMap.put('OwnerId', acc.OwnerId);

        OSH_AccountMemberCreation ins = new OSH_AccountMemberCreation();
        Boolean ret = ins.invokeMethod('createUserAccount', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
    
    @isTest
    static void createUserAfterQuoteProcessTest() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Quote quote = [SELECT Id, OwnerId FROM Quote WHERE Name = 'Quote Test'];
        Account accTest = [SELECT Id, OwnerId FROM Account WHERE Name = 'Test Account'];
        
        inputMap.put('QuoteIdDecrypted', quote.Id);

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
        Boolean ret = ins.invokeMethod('createUserAfterQuoteProcess', inputMap, outMap, options);
        System.assertEquals(ret, false);
    }
}