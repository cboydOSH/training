@IsTest global class UserUtiliyTest {

    @isTest static void testGetUserId() {
        Test.startTest();
    	String METHOD_NAME_ID = 'getUserId';
        Map<String, Object> mapInput = new Map<String, Object>();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        UserUtility userUtility1 = new UserUtility();
        Boolean success1 = userUtility1.invokeMethod(METHOD_NAME_ID, mapInput, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success1, true);
        
    }
    
    @isTest static void testGetUserEmail() {
        Test.startTest();
    	String METHOD_NAME_EMAIL = 'getUserEmail';
        Map<String, Object> mapInput = new Map<String, Object>();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        UserUtility userUtility2 = new UserUtility();
        Boolean success2 = userUtility2.invokeMethod(METHOD_NAME_EMAIL, mapInput, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success2, true);
    }
    
    @isTest static void testGetUserEmailAndId() {
        Test.startTest();
    	String METHOD_NAME_EMAIL_AND_ID = 'getUserIdAndEmail';
        Map<String, Object> mapInput = new Map<String, Object>();
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        UserUtility userUtility3 = new UserUtility();
        Boolean success3 = userUtility3.invokeMethod(METHOD_NAME_EMAIL_AND_ID, mapInput, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success3, true);
    }
    
}