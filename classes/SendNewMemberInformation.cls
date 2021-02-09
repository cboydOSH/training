global without sharing class SendNewMemberInformation {
	
    @InvocableMethod
    public static void sendNewMemberEmail(List<string> assetId){ //parametro List<string> assetId
        //hardcoded for testing purposes 
        //string assetId = '02i8A000004EhRZQA0';
        
        //Test information
        //Dan Brown's User Id 0058A000005hInh         
        //Dan Brown's Account Id 0018A00000WstUIQAZ
        //Dan Brown's Asset Id 02i8A000004EhRZQA0
        //Dan Brown's Product Id 01t8A00000496ldQAA
        
        //query getting the required User information for the email
        Asset userAsset = [SELECT Id, Name, Product2Id, AccountId, Effective_date__c, Group_Code__c FROM Asset where Id = :assetId];
        Account userAccount = [SELECT Id, Name, LastName, FirstName, PersonEmail, Member_ID__pc FROM Account where Id = :userAsset.AccountId];
        Product2 userProduct = [SELECT Id, Name FROM Product2 where Id = :userAsset.Product2Id];

        
		//Outbound Email Method
		Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userAccount.PersonEmail}; 
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('support@acme.com');
        mail.setSenderDisplayName('One Share Health');
        mail.setSubject('Welcome to One Share Health!');
        mail.setBccSender(false);
        mail.setUseSignature(false);
               
        mail.setHtmlBody('Dear ' + userAccount.FirstName +',<br><br> '+
             'We want to welcome you to the OneShare Health Family and thank you for becoming a Member! First and foremost, our duty as a Health Care Sharing Ministry is to listen to our Members and create services that fit your needs. Our goal is to uphold the highest standards of integrity and ethics to focus on your overall health and wellness!<br><br>' + 
             'We encourage you to take a few minutes to experience the Member Portal below, as it contains your Membership Guide and important information about your Program. The more informed you are, the easier it will be to get the care you need when you need it most!<br><br>' + 
             'The Program you have enrolled in is: ' + userProduct.Name + '<br><br>' + 
             'We will send your temporary ID card through a separate email. Once received, please print a copy for your records, as your Member ID card\'s hard copy will arrive in the mail within 12-15 business days. In the meantime, feel free to contact the Member Concierge Team at <a href = "mailto: concierge@onesharehealth.com">concierge@onesharehealth.com</a> if you have any questions. We are here for you!<br><br> ' + 
             'Member Name: ' + userAccount.FirstName + ' ' + userAccount.LastName + '<br>' + 
             'Member ID: ' + userAccount.Member_ID__pc + '<br>' +
             'Program Name: ' + userProduct.Name + '<br>' +
             'Effective Date: ' + userAsset.Effective_date__c + '<br>' +
             'Group Code: ' + userAsset.Group_Code__c + '<br><br>' +
             'Again, thank you for becoming a OneShare Health Member, and know we are here for you in your time of need.<br><br> ' +
             'Blessings to you,<br><br>'+
             'The Team at OneShare Health');        
      
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
        
        
        
    }
    
    
}