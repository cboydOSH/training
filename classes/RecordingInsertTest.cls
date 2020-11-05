@isTest(seealldata = false)
public class RecordingInsertTest { 
    
    @isTest
    public static void testRecordingDependentAccountTest() {

        Test.startTest();

        String parentRecordType;

        String dependentRecordType;
        
        List<RecordType> accountRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];

        for(RecordType recordTypeInfo : accountRecordTypes) {
            if(recordTypeInfo.Name == 'Dependent') {
                dependentRecordType = recordTypeInfo.Id;
            }
            else if (recordTypeInfo.Name == 'Primary Member') {
                parentRecordType = recordTypeInfo.Id;
            }
        }

        Account testParentAccount = new Account(LastName = 'Recording Test Person Account', 
                                                RecordTypeId = parentRecordType,
                                                Phone = '123456');

        insert testParentAccount;

        Account testDependentAccount = new Account(LastName = 'Recording Test Person Account', 
                                                   Account__c = testParentAccount.Id,
                                                   RecordTypeId = dependentRecordType,
                                                   Phone = '234567');

        insert testDependentAccount;

        Recording__c testRecording = new Recording__c(Phone__c = '234567',
                                                      S3_URL__c = 'Test1',
                                                      Dropbox_URL__c = 'Test1',
                                                      Recording_Source__c = 'RingCentral');
        insert testRecording;

        testRecording = [SELECT Id, Member_Account__c FROM Recording__c WHERE Phone__c = '234567'];

        System.assertEquals(testParentAccount.Id, testRecording.Member_Account__c);
        Test.stopTest();
    }

    @isTest
    public static void testRecordingParentAccountTest() {

        Test.startTest();

        String parentRecordType;
        
        List<RecordType> accountRecordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];

        for(RecordType recordTypeInfo : accountRecordTypes) {
            if(recordTypeInfo.Name == 'Primary Member') {
                parentRecordType = recordTypeInfo.Id;
            }
        }

        Account testParentAccount = new Account(LastName = 'Recording Test Person Account',
                                                RecordTypeId = parentRecordType,
                                                Phone = '123456');

        insert testParentAccount;

        Recording__c testRecording = new Recording__c(Phone__c = '123456',
                                                      S3_URL__c = 'Test2',
                                                      Dropbox_URL__c = 'Test2',
                                                      Recording_Source__c = 'RingCentral');
        insert testRecording;

        testRecording = [SELECT Id, Member_Account__c FROM Recording__c WHERE Phone__c = '123456'];

        System.assertEquals(testParentAccount.Id, testRecording.Member_Account__c);
        Test.stopTest();
    }
}