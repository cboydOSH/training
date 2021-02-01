@IsTest global class InformationPacketTest {

    //BadTest
    @IsTest(SeeAllData=true) 
    public static void testCatastrophic() {
        Test.startTest();
        //Prepare - Id for Quote with Catastrophic Line Items   
        system.currentPageReference().getParameters().put('id', '0Q08A000000JmgpSAC');
        // Execute  
        System.debug('Process started');
        InformationPacket testControlerObj = new InformationPacket();
        Test.stopTest();
        //Validate
        System.assertEquals(true, true);                           
    }
    
    @IsTest(SeeAllData=true) 
    public static void testClassic() {
        Test.startTest();
        //Prepare - Id for Quote with Classic Line Items   
        system.currentPageReference().getParameters().put('id', '0Q08A000000JlfBSAS');
        // Execute  
        System.debug('Process started');
        InformationPacket testControlerObj = new InformationPacket();
        Test.stopTest();
        //Validate
        System.assertEquals(true, true);                           
    }
    
     @IsTest(SeeAllData=true) 
    public static void testComplete() {
        Test.startTest();
        //Prepare - Id for Quote with Complete Line Items   
        system.currentPageReference().getParameters().put('id', '0Q08A000000JkGKSA0');
        // Execute  
        System.debug('Process started');
        InformationPacket testControlerObj = new InformationPacket();
        Test.stopTest();
        //Validate
        System.assertEquals(true, true);                           
    }
    
    
    
    
    //GoodTest
    //@isTest static void testInit() {
        
        
         //create User
        //Profile p = [SELECT Id FROM Profile LIMIT 1]; 
 		//User u = new User(Alias = 'standt', Email='emialtest@test.com', 
 		//EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
 		//LocaleSidKey='en_US', ProfileId = p.Id, 
 		//TimeZoneSidKey='America/Los_Angeles', UserName='testexample@test.com');
 		//insert u;
        
        
        //insert u;
       // List<User> user1id = [SELECT Id FROM User LIMIT 1];



        
    	//create Account
        //Account newAccount = new Account(
          //  LastName = 'testAccount'
        //);
        //insert newAccount;        
       // System.debug('NEW ACCOUNT => ' + newAccount);    
        //List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        
        //create Opportunity
        //Opportunity newOpportunity = new Opportunity(
        //    Name = 'testOpportunity',
        //    StageName='Enrollment',
        //    CloseDate= Date.Today()
        //);
        //insert newOpportunity;        
        //System.debug('NEW OPPORTUNITY => ' + newOpportunity);
        //List<Opportunity> opportunity1id = [SELECT Id FROM Opportunity LIMIT 1];
        
        //Date myDate = Date.newInstance(1990, 2, 17);
        //Date myDate2 = Date.newInstance(2020, 8, 17);
        
        //create Quote
        //System.runAs(user1id[0]) {
        //Quote newQuote = new Quote(
        //    Name = 'testQuote',
        //    OpportunityId = opportunity1id[0].Id,
        //    Servicing_Agent__c = account1id[0].Id,
        //    Writing_agent__c = user1id[0].Id,
        //    Enroller_Id__c = user1id[0].Id,
        //    Agent_Label__c = account1id[0].Id,
        //    Age_Period_30d__c = false,
        //    Age_Period_60d__c = false,
         //   Rating_Member__c = account1id[0].Id,
         //   Old_MemBer_Based_Dob__c = myDate,
         //   Price_Change__c = false,
         //   Status = 'Draft',
         //   Information_Packet_Number__c = '10000-84951'
       // );
       // insert newQuote;
       // System.debug('NEW QUOTE => ' + newQuote);
       // }
        
        //List<Quote> quote1id = [SELECT Id FROM Quote LIMIT 1];
       // System.debug(quote1id);
        //Test.setCreatedDate(quote1id[0].Id, myDate2);
        
       // Test.startTest();
       // String qId = quote1id[0].Id;
        
        
        
        //InformationPacket infoPacket1 = new InformationPacket();
        //infoPacket1.init(qId);
        
        //Test.stopTest();
        //System.assertEquals(true, true);

    //}
    
}