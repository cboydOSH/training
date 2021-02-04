@IsTest global class OSHQuoteServiceTest {
	//create Quote, Lead
	//input must have: "quoteId", "leadId", "informationPacketNumber", "addInfo30", "addInfo60", "oldestDOB",
	//"priceChange", "ratingMemberId", "quoteStatus", "quoteStatus", "writingAgent", "enrollerId", "agentLabel"
   
    @isTest static void testEncryptIfNecessary() {
    	Test.startTest(); 
    
        //create User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        List<User> user1id = [SELECT Id FROM User LIMIT 1];
        
    	//create Account
        Account newAccount = new Account(
            LastName = 'testAccount'
        );
        insert newAccount;        
        System.debug('NEW ACCOUNT => ' + newAccount);    
        List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        
        //create Opportunity
        Opportunity newOpportunity = new Opportunity(
            Name = 'testOpportunity',
            StageName='Enrollment',
            CloseDate= Date.Today()
        );
        insert newOpportunity;        
        System.debug('NEW OPPORTUNITY => ' + newOpportunity);
        List<Opportunity> opportunity1id = [SELECT Id FROM Opportunity LIMIT 1];
        
        Date myDate = Date.newInstance(1990, 2, 17);
        
        //create Quote
        Quote newQuote = new Quote(
            Name = 'testQuote',
            OpportunityId = opportunity1id[0].Id,
            Servicing_Agent__c = account1id[0].Id,
            Writing_agent__c = user1id[0].Id,
            Enroller_Id__c = user1id[0].Id,
            Agent_Label__c = account1id[0].Id,
            Age_Period_30d__c = false,
            Age_Period_60d__c = false,
            Rating_Member__c = account1id[0].Id,
            Old_MemBer_Based_Dob__c = myDate,
            Price_Change__c = false,
            Status = 'Draft',
            Information_Packet_Number__c = '10000-84951'
        );
        insert newQuote;        
        System.debug('NEW QUOTE => ' + newQuote);
        List<Quote> quote1id = [SELECT Id FROM Quote LIMIT 1];
        
        //create Lead
        Lead newLead = new Lead(
            FirstName='LeadTestoDaio',
            LastName='LeadTestoDaio'
        );
        insert newLead;        
        System.debug('NEW LEAD => ' + newLead);  
        List<Lead> lead1id = [SELECT Id FROM Lead LIMIT 1];
        
        //create inputs
        String METHOD_NAME = 'updateQuoteAfterCreation';
        Map<String, Object> mapInput = new Map<String, Object> {
                'quoteId' => quote1id[0].Id,
                'leadId' => lead1id[0].Id,
                'informationPacketNumber' => '10000-00213',
                'addInfo30' => true,
                'addInfo60' => true,
				'oldestDOB' => '1994-12-12',
                'priceChange' => false,
                'ratingMemberId' => account1id[0].Id,
                'quoteStatus' => 'Presented',
                'servicingAgent' => account1id[0].Id,
                'writingAgent' => user1id[0].Id,
                'enrollerId' => user1id[0].Id,
                'agentLabel' => account1id[0].Id,
                'leadStatus' => 'New'
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        
        OSHQuoteService oshQuoteService = new OSHQuoteService();
        Boolean success = oshQuoteService.updateQuoteAfterCreation(mapInput, mapOutput, mapOptions);

     
        Test.stopTest(); 
         
        System.assertEquals(success, true);
    }
    
    
    @isTest static void testInvokeMethod() {
        Test.startTest(); 
    
        //create User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        List<User> user1id = [SELECT Id FROM User LIMIT 1];
        
    	//create Account
        Account newAccount = new Account(
            LastName = 'testAccount'
        );
        insert newAccount;        
        System.debug('NEW ACCOUNT => ' + newAccount);    
        List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        
        //create Opportunity
        Opportunity newOpportunity = new Opportunity(
            Name = 'testOpportunity',
            StageName='Enrollment',
            CloseDate= Date.Today()
        );
        insert newOpportunity;        
        System.debug('NEW OPPORTUNITY => ' + newOpportunity);
        List<Opportunity> opportunity1id = [SELECT Id FROM Opportunity LIMIT 1];
        
        Date myDate = Date.newInstance(1990, 2, 17);
        
        //create Quote
        Quote newQuote = new Quote(
            Name = 'testQuote',
            OpportunityId = opportunity1id[0].Id,
            Servicing_Agent__c = account1id[0].Id,
            Writing_agent__c = user1id[0].Id,
            Enroller_Id__c = user1id[0].Id,
            Agent_Label__c = account1id[0].Id,
            Age_Period_30d__c = false,
            Age_Period_60d__c = false,
            Rating_Member__c = account1id[0].Id,
            Old_MemBer_Based_Dob__c = myDate,
            Price_Change__c = false,
            Status = 'Draft',
            Information_Packet_Number__c = '10000-84951'
        );
        insert newQuote;        
        System.debug('NEW QUOTE => ' + newQuote);
        List<Quote> quote1id = [SELECT Id FROM Quote LIMIT 1];
        
        //create Lead
        Lead newLead = new Lead(
            FirstName='LeadTestoDaio',
            LastName='LeadTestoDaio'
        );
        insert newLead;        
        System.debug('NEW LEAD => ' + newLead);  
        List<Lead> lead1id = [SELECT Id FROM Lead LIMIT 1];
        
        //create inputs
        String METHOD_NAME = 'updateQuoteAfterCreation';
        Map<String, Object> mapInput = new Map<String, Object> {
                'quoteId' => quote1id[0].Id,
                'leadId' => lead1id[0].Id,
                'informationPacketNumber' => '10000-00213',
                'addInfo30' => true,
                'addInfo60' => true,
				'oldestDOB' => '1994-12-12',
                'priceChange' => false,
                'ratingMemberId' => account1id[0].Id,
                'quoteStatus' => 'Presented',
                'servicingAgent' => account1id[0].Id,
                'writingAgent' => user1id[0].Id,
                'enrollerId' => user1id[0].Id,
                'agentLabel' => account1id[0].Id,
                'leadStatus' => 'New'
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        
        OSHQuoteService oshQuoteService = new OSHQuoteService();
        Boolean success = oshQuoteService.invokeMethod(METHOD_NAME, mapInput, mapOutput, mapOptions);

     
        Test.stopTest(); 
         
        System.assertEquals(success, true);
        
    }
    
    
}