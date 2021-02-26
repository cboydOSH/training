@IsTest global class GetEnvelopesSentTodayTest {

    @isTest static void testGetEnvelopes() {
    	Test.startTest();
    	
        //create Envelope
        // dfsle__Envelope__c newEnvelope = new dfsle__Envelope__c();
        // insert newEnvelope;        
        // System.debug('NEW ENVELOPE => ' + newEnvelope);
        
        //create Account
        Account newAccount = new Account(
            LastName = 'testAccount'
        );
        insert newAccount;        
        System.debug('NEW ACCOUNT => ' + newAccount);
        
        //create Contract
        // List<dfsle__Envelope__c> envelope1id = [SELECT Id FROM dfsle__Envelope__c LIMIT 1];
        List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        Contract newContract = new Contract(
            // Envelope_Id__c = envelope1id[0].Id,
            Envelope_Id__c = '0ad322f4-f362-4192-8d52-42d8f3055c73',
            AccountId = account1id[0].Id,
            Status = 'Draft'
        	);
        insert newContract;        
        System.debug('NEW CONTRACT => ' + newContract);
        
        Contract contract1 = new Contract();
        contract1 = [SELECT Id, Name, Status FROM Contract LIMIT 1];
        contract1.Status = 'Awaiting Signature';
        update contract1;
        
        String METHOD_NAME_ENVELOPES = 'getEnvelopes';
        Map<String, Object> mapInput = new Map<String, Object>();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        GetEnvelopesSentToday envelope = new GetEnvelopesSentToday();
        boolean isSuccess = envelope.invokeMethod(METHOD_NAME_ENVELOPES, mapInput, mapOutput, mapOptions);
        
        System.assertEquals(isSuccess, true);
        
        Test.stopTest();
                        
    }
   
}