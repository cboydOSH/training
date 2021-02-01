@IsTest global class OSHRelateContractWithAssetTest {
	
    @isTest static void testUpdateAssetWithContract() {
        Test.startTest();
        
        //create Account
        Account newAccount = new Account(
            LastName = 'testAccount'
        );
        insert newAccount;        
        System.debug('NEW ACCOUNT => ' + newAccount);
        
        //create Asset
        Asset newAsset = new Asset(
            Name = 'testAsset'
        );
        insert newAsset;        
        System.debug('NEW ASSET => ' + newAsset);
        
        List<Account> account1id = [SELECT Id FROM Account LIMIT 1];
        //create Contract
        Contract newContract = new Contract(
            Name = 'testContract',
            AccountId = account1id[0].Id
        );
        insert newContract;        
        System.debug('NEW CONTRACT => ' + newContract);
        
        
        List<Asset> asset1id = [SELECT Id FROM Asset LIMIT 1];
        List<Contract> contract1id = [SELECT Id FROM Contract LIMIT 1];
        
        String method1 = 'updateAssetWithContract';
         Map<String, Object> mapJSON = new Map<String, Object> {
                'assetId' => asset1id[0].Id,
                'contractId' => contract1id[0].Id
        
        };
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        
        OSHRelateContractWithAsset relateContractAsset = new OSHRelateContractWithAsset();
        Boolean success1 = relateContractAsset.invokeMethod(method1, mapJSON, mapOutput, mapOptions);
        
        Test.stopTest();
        System.assertEquals(success1, true);
    }
    
}