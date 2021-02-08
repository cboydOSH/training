@IsTest global class CallDRLoadmemberTest {
    @IsTest global static void testCallDR() {
        
        Test.startTest();    
        
        /*create Opportunity
        Opportunity newOpportunity = new Opportunity(
            Name = 'TestOppt',
            StageName='Draft',
            CloseDate= Date.today()+1
        );
        insert newOpportunity;        
        System.debug('NEW OPPORTUNITY => ' + newOpportunity);
        List<Opportunity> opportunity1id = [SELECT Id FROM Opportunity LIMIT 1];
        
        
        //create Quote
        Quote newQuote = new Quote(
            OpportunityId = opportunity1id[0].Id,
            Name='testQuote'
        );
        insert newQuote;        
        System.debug('NEW QUOTE => ' + newQuote);
        */
     	String methodName1 = '';
        Map<String, Object> mapInput = new Map<String, Object> {
            'Input' => new Map<String, Object> {
            }};
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        CallDRLoadmember cs = new CallDRLoadmember();   
        Boolean success = cs.invokeMethod(methodName1, mapInput, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success, true);
    }

}