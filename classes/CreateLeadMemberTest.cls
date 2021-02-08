@IsTest global class CreateLeadMemberTest {
     
    @isTest static void testCreateLeadForMember() {
        Map<String, Object> mapInput = generateVlocityJSON();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
       	Integer leadsBefore = [SELECT COUNT() FROM Lead];
        
        Test.startTest();
        Boolean methodResult = CreateLeadMember.createLeadForMember(mapInput, mapOutput, mapOptions);
		Test.stopTest();
        
       	Integer leadsAfter = [SELECT COUNT() FROM Lead];     
        System.assertNotEquals(leadsBefore, leadsAfter, 'Leads have not being created');
    }
    
    @isTest static void testCreateLeadForMemberWithEmptyJSON() {
        Map<String, Object> mapInput = new Map<String, Object>();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        String expectedExceptionMsg = 'Attempt to de-reference a null object';
        String actualExceptionMsg;
        
        Test.startTest();
        try {
            CreateLeadMember.createLeadForMember(mapInput, mapOutput, mapOptions);
        } catch (System.NullPointerException npex) {
            actualExceptionMsg = npex.getMessage();
        }
		Test.stopTest();
       
        System.assertEquals(expectedExceptionMsg, actualExceptionMsg, 'Leads should not being created with an empty JSON');
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