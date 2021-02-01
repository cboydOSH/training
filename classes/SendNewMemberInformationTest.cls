@IsTest global with sharing class SendNewMemberInformationTest {

    @IsTest global static void testSendNewMemberEmail() {
        Test.StartTest();
        
        //create Product
        Product2 newProduct = new Product2(
        	Name='testProduct'
        );
        insert newProduct;        
        System.debug('NEW Product => ' + newProduct);
        List<Product2> product1id = [SELECT Id FROM Product2 LIMIT 1];
        
        
        //Create Account
        Account newAccount = new Account(
            LastName = 'testAccount',
            FirstName = 'test',
            PersonEmail = 'britney@mailinator.com',
            Member_ID__pc = '7984654987452'
        );
        insert newAccount;        
        System.debug('NEW ACCOUNT => ' + newAccount);
        List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        newAccount.Member_ID__pc = account1id[0].Id;
        update newAccount;
        System.debug('NEW ACCOUNT2 => ' + newAccount);
        
        
        Date myDate = Date.newInstance(2021, 2, 17);
        
        //Create Asset
        Asset newAsset = new Asset(
            Name = 'testAsset',
            Product2Id = product1id[0].Id,
            AccountId = account1id[0].Id,
            Effective_date__c = myDate
        );
        insert newAsset; 
        List<Asset> asset1id = [SELECT Id FROM Asset LIMIT 1];
        
        SendNewMemberInformation.sendNewMemberEmail(new List<String>{asset1Id[0].Id});//sending an Asset Id
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations, 'An email has not been sent');
    }
    
}