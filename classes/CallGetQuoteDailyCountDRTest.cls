@IsTest global class CallGetQuoteDailyCountDRTest {

    @IsTest global static void testCallDR() {
        
        Test.startTest();    
        
        //create Opportunity
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
        
     	String methodName1 = 'callDR';
        Map<String, Object> mapInput = generateVlocityJSON();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        CallGetQuoteDailyCountDR callGetQuote1 = new CallGetQuoteDailyCountDR();
        Boolean success = callGetQuote1.invokeMethod(methodName1, mapInput, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success, true);
    }
    
    @isTest static void testGetNextInfoPacketNumber() {
        Test.startTest();
     	String methodName2 = 'getNextInfoPacketNumber';
        Map<String, Object> mapInput = new Map<String, Object>();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        CallGetQuoteDailyCountDR callGetQuote2 = new CallGetQuoteDailyCountDR();
        Boolean success = callGetQuote2.invokeMethod(methodName2, mapInput, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success, true);
    }
    
     // This is not a test method, just a data factory one
    private static Map<String, Object> generateVlocityJSON() {
        Map<String, Object> mapJSON = new Map<String, Object> {
                'letsGetStarted' => new Map<String, Object> {
					'RadioExistingInfoPacket' => 'No',
        			'BlkExistingInfoPacket' => null,
                    'BlkNoExistingInfoPacket' => new Map<String, Object> {
                    	'fName' => 'dsasdasd',
            			'lName' => 'asdasd',
						'TAAddressGoogle-Block' => new Map<String, Object> {
                        	'TAAddressGoogle' => '8525 Page Ave, St. Louis, MO 63114, USA',
                            'address' => '8525 Page Avenue',
                            'City' => 'St. Louis',
                            'State' => 'MO',
                            'zipCode' => '63114',
                            'Country' => 'United States',
                            'buildingSuiteApartment' => 'as'
                        },
                        'Telephone1' => '3333333333',
                        'Email1' => '654564@654564.com',
                        'SelectReferer' => null,
                        'FormulaEegible' => false,
                        'FormulaEegibleMA' => false,
                        'SSNITIN' => '333333333'
                    },
                    'stateofBeliefs' => new Map<String, Object> {
                    	'qualification' => null,
                        'msg' => null,
                        'MessagingStatesoff' => null,
                        'Space2x4' => null,
                        'Space3x4' => null
                    },
                    'NumOfEmployeeInternal' => 1,
                    'ThisisQuote' => true
                }
            };
        
        return mapJSON;
    }
    
}