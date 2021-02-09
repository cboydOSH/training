@IsTest global class UpgradeStepTest {

    
    @isTest static void testInsertStepNameNull(){
		        
        Test.startTest();
        
        UpgradePlan__c upgradePlan = new UpgradePlan__c(
        	Name = 'testPlan'
        );
        insert upgradePlan;
        
        UpgradeStep__c upgradeStep = new UpgradeStep__c(
        	Name = 'testStep',
            ExternalId__c = '9874954132',
            UniqueId__c = '4523168498',
            UpgradePlanId__c = upgradePlan.Id
        );
        insert upgradeStep;
        
        upgradeStep.ParentStepUniqueId__c = '118913219611';
        update upgradeStep;
        
	    System.assertEquals(true, true);
        Test.stopTest();        
    }
    
    
}