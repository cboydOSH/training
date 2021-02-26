@IsTest global class RecordingTriggerHelperTest {

    //crear Recording__c con Phone__c - x2
    //crear Account con Phone == Phone__c y RecordType=='Dependent' && IsPersonAccount==true
    //crear Account con Phone == Phone__c y RecordType!='Dependent' && IsPersonAccount==true
    
      @isTest static void testSetAccountInformation() {
        
        Test.startTest();
		
          
        //create Recording__c1
        Recording__c newRecording1 = new Recording__c(
            Phone__c = '2025550142',
            S3_URL__c = 'http://www.example.com/',
            Dropbox_URL__c = 'http://www.example.com/',
            Recording_Source__c = 'Vicidial'
        );
        insert newRecording1;        
        System.debug('NEW RECORDING1 => ' + newRecording1);
          
        
        //create Recording__c2
        Recording__c newRecording2 = new Recording__c(
            Phone__c = '2025550145',
            S3_URL__c = 'http://www.example.com/',
            Dropbox_URL__c = 'http://www.example.com/',
            Recording_Source__c = 'Vicidial'
        );
        insert newRecording2;        
        System.debug('NEW RECORDING2 => ' + newRecording2);  
        
		
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        String RecTypeIdep= [select Id from RecordType where (Name='Dependent') and (SobjectType='Account')].Id;  
          
        //create Account1
        Account newAccount1 = new Account(
            RecordTypeID=RecTypeId,
  			FirstName='Test FName',
  			LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12347',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            Phone= newRecording1.Phone__c
        );
        insert newAccount1;        
        System.debug('NEW ACCOUNT1 => ' + newAccount1);
        newAccount1.RecordTypeId = RecTypeIdep;
        update newAccount1;
          
        //create Account2
        Account newAccount2 = new Account(
            RecordTypeID=RecTypeId,
  			FirstName='Test FName2',
  			LastName='Test LName2',
            PersonMailingStreet='test2@yahoo.com',
            PersonMailingPostalCode='12342',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoooo.com',
            Phone= newRecording2.Phone__c
        );
        insert newAccount2;        
        System.debug('NEW ACCOUNT2 => ' + newAccount2);
        //newAccount2.RecordTypeId = RecTypeIdep;
        //update newAccount2;  
        List<Account> account2id = [SELECT Id FROM Account WHERE FirstName='Test FName2' LIMIT 1];
         
       
        List<Recording__c> recordingList = new List<Recording__c>();
        recordingList.add(newRecording1);
        recordingList.add(newRecording2);
        
  
		RecordingTriggerHelper.setAccountInformation(recordingList);
        
          
		Test.stopTest();
    	System.assertEquals(newRecording2.Member_Account__c, account2id[0].Id);//id de la 2da account

    }
    
}