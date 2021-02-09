@isTest global class UpsertOpportunityLeadTest {

    @isTest static void testUpsertOpportunityLeadForMember() {
        UpsertOpportunityLead upsertOL = new UpsertOpportunityLead();

        String leadId = createLeadForAccount();	// This creates a Lead for the account
        Map<String, Object> mapInput = generateVlocityJSON(leadId); // This populates the input with the emulated JSON
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
    
        Integer oppsBefore = [SELECT COUNT() FROM Opportunity];
        Lead leadBefore = [SELECT Parent_Account__c FROM Lead];

        Test.startTest();
		upsertOL.upsertOpportunityLeadForMember(mapInput, mapOutput, mapOptions);
		Test.stopTest();
        
		// This checks if the output was updated with the resultant Opportunity
        Boolean outMapOpp2;
        if (mapOutput.containskey('Opportunity_2')) {
            outMapOpp2 = true;
        } else {
            outMapOpp2 = false;
            System.debug('ERROR => OutMap Opportunity was not created!');
        }
        
        // This checks if the output was updated with the resultant Lead
        Boolean outMapLead3;
        if (mapOutput.containskey('Lead_3')) {
            outMapLead3 = true;
        } else {
            outMapLead3 = false;
            System.debug('ERROR => OutMap Lead was not created!');
        }
        
       	Integer oppsAfter = [SELECT COUNT() FROM Opportunity];     
        Lead leadAfter = [SELECT Parent_Account__c FROM Lead];
        
        System.assertNotEquals(oppsBefore, oppsAfter, 'New Opportunities have not being created');
        System.assertNotEquals(leadBefore.Parent_Account__c, leadAfter.Parent_Account__c, 'Leads have not being updated');
        System.assertEquals(true, outMapOpp2, 'The result Opportunity was not added to the outMap');
        System.assertEquals(true, outMapLead3, 'The result Lead was not added to the outMap');
    }
        
    // This is not a test method, just a data factory one
    private static Map<String, Object> generateVlocityJSON(String leadId) {

        Map<String, Object> mapJSON = new Map<String, Object>{
            'internalLeadRecordType' => '0124P000000uPoZQAU',
            'DRId_Lead' => leadId, //'00Q8A0000040ZgUUAU',
            'Account_1' => new List<Map<String, Object>> {
                new Map<String, Object> {'Id' => '0018A00000U7zteQAB'}
            },
            'letsGetStarted' => new Map<String, Object> {
                'BlkNoExistingInfoPacket' => new Map<String, Object> {
                    'fName' => 'Fuster Test',
                    'lName' => 'Magallanes',
                    'TAAddressGoogle-Block' => new Map<String, Object> {
                        'TAAddressGoogle' => '9840 International Dr, Orlando, FL 32819, USA',
                        'address' => '9840 International Drive',
                        'City' => 'Orlando',
                        'State' => 'FL',
                        'zipCode' => '32819',
                        'Country' => 'United States',
                        'buildingSuiteApartment' => null
                    },
                    'Telephone1' => '8974561235',
                    'Email1' => 'test@testingemail.com',
                    'SelectReferer' => 'Internet Search',
                    'FormulaEegible' => false,
                    'FormulaEegibleMA' => false,
                    'SSNITIN' => '232131231'
                }
            },
           	'AddEditFamilyMember' => new List<Map<String, Object>> {
            	new Map<String, Object> {'id' => '1591280109578', 'parent_id' => '1591280109578', 'fname' => 'Peche Test', 'lname' => 'Magallanes', 'dob' => '1995-06-02', 'defaultNo' => 'false', 'age' => 26, 'relationship' => 'Primary', 'americanIndian' => '', 'eligiblemedicare' => '', 'address' => '', 'city' => '', 'state' => '', 'zipcode' => '', 'phone' => '', 'email' => '', 'gender' => 'Male'},
        		new Map<String, Object> {'id' => '1591280109581', 'parent_id' => '1591280109578', 'fname' => 'Depto Test', 'lname' => 'Magallanes', 'dob' => '1990-06-06', 'defaultNo' => 'false', 'age' => 26, 'relationship' => 'Spouse', 'americanIndian' => '', 'eligiblemedicare' => '', 'address' => '', 'city' => '', 'state' => '', 'zipcode' => '', 'phone' => '', 'email' => '', 'gender' => 'Male'}
            },
            'SelectedServicingAgentDropdown' => new Map<String, Object> {
                'attributes' => new Map<String, Object> {
                    'type' => 'Account',
                    'url' => '/services/data/v49.0/sobjects/Account/0018A00000TyjGAQAZ'
                },
                'Id' => '0018A00000TyjGAQAZ',
                'Name' => 'OSH Enrollment',
                'Monthly_Commission_Fee__c' => 45,
                'RecordTypeId' => '0124P000000uPa9QAE'
            },
            'myFamily' => new Map<String, Object> {
                'effectiveDateforQuote' => '--',
                'Check60daysandTodayPast' => true,
                'Space20x12' => null,
                'WhatPrimaryLanguageSpoken' => 'English',
                'Space21x12' => null,
                'RadioFamily' => 'MyselfMyspouse',
                'effDateEnroll' => null,
                'MsgEffDateEnrollValid' => null,
                'Space22x7' => null,
                'myFamilyTable' => null,
                'Primary18AndOlderError' => false,
                'NeedselectedaSopuse' => null,
                'Spouse65AndOlderError' => null,
                'NoChildGreater27Error' => null,
                'ChildGreaterThan65Error' => null,
                'DisabledChildGreaterThan27AndLess65ErrorMessage' => null,
                'FormulaValidateOldMember' => true,
                'MSGRatingWillBeBasedOn' => true,
                'HaveAdultDependentInfoMessage' => null,
                'MomentaryPigFormula' => 0,
                'Space5x12' => null,
                'Space6x12' => null,
                'effDate' => '2020-06-05'
            }
        };
       	
		return mapJSON;       
	}
    
    private static String createLeadForAccount() {
        Lead newLead = new Lead(
       		FirstName = 'Mateo',
        	LastName = 'Salles'
        );
        insert newLead;
        
        String leadId = String.valueOf( [SELECT Id FROM Lead LIMIT 1].Id );
        return leadId;
    }
    
}