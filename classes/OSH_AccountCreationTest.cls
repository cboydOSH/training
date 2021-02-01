@IsTest public with sharing class OSH_AccountCreationTest {

    @IsTest public static void testAccountCreationSuccess() {
        //Prepare
        vlocity_ins.VlocityOpenInterface2 vlocityOpenInterface = new OSH_AccountCreation(); //Controller Account creation object
        String methodName = 'createUserAccount';
        Map <String, Object> inputs = new Map<String, Object>();
        Map <String, Object> output = new Map<String, Object>();
        inputs.put('ContextId', 'testContext');
        inputs.put('CreateAccount', getCreateAccountNode('askjnas2@akjsdasd2.com', 'OSHVicenteMartinez92.', 'VicenteTest'));        
        Boolean response;
        //Execute
        response = Boolean.valueOf(vlocityOpenInterface.invokeMethod(methodName, inputs, output, new Map<String, Object>()));
        //Validate
        System.assertEquals(true, response);                           
    }    

    @IsTest public static void testAccountCreationExpectingForException() {
        //Prepare
        vlocity_ins.VlocityOpenInterface2 vlocityOpenInterface = new OSH_AccountCreation(); //Controller Account creation object
        String methodName = 'createUserAccount';
        Map <String, Object> inputs = new Map<String, Object>();
        Map <String, Object> output = new Map<String, Object>();
        inputs.put('contextId', 'testContext');
        inputs.put('unknownblock', getCreateAccountNode('askjnas2@akjsdasd.com', '','VicenteTest'));        
        Boolean response;
        //Execute
        response = Boolean.valueOf(vlocityOpenInterface.invokeMethod(methodName, inputs, output, new Map<String, Object>()));
        //Validate
        System.assertEquals(false, response);                           
    }  

    @IsTest public static void testAccountCreationFromApexExpectingPortalException() {
        //Prepare
        vlocity_ins.VlocityOpenInterface2 vlocityOpenInterface = new OSH_AccountCreation(); //Controller Account creation object
        String methodName = 'createUserAccount';
        Map <String, Object> inputs = new Map<String, Object>();
        Map <String, Object> output = new Map<String, Object>();
        inputs.put('ContextId', 'testContext');
        inputs.put('CreateAccount', getCreateAccountNode('askjnas2@akjsdasd2.com', 'OSHVicenteMartinez92.', 'Vicente'));        
        Boolean response;
        //Execute
        response = Boolean.valueOf(vlocityOpenInterface.invokeMethod(methodName, inputs, output, new Map<String, Object>()));
        //Validate
        System.assertEquals(false, response);                           
    }  

    @IsTest public static void testAccountCreationFromApexExpectingDuplicatedUser() {
        //Prepare
        vlocity_ins.VlocityOpenInterface2 vlocityOpenInterface = new OSH_AccountCreation(); //Controller Account creation object
        String methodName = 'createUserAccount';
        Map <String, Object> inputs = new Map<String, Object>();
        Map <String, Object> output = new Map<String, Object>();
        inputs.put('ContextId', 'testContext');
        inputs.put('CreateAccount', getCreateAccountNode('vicente.martinez.test@gmail.c', 'OSHVicenteMartinez92.', 'Vicente'));        
        Boolean response;
        //Execute
        response = Boolean.valueOf(vlocityOpenInterface.invokeMethod(methodName, inputs, output, new Map<String, Object>()));
        //Validate
        System.assertEquals(false, response);                           
    }  

    @IsTest public static void testAccountCreationBadPassword() {
        //Prepare
        vlocity_ins.VlocityOpenInterface2 vlocityOpenInterface = new OSH_AccountCreation(); //Controller Account creation object
        String methodName = 'createUserAccount';
        Map <String, Object> inputs = new Map<String, Object>();
        Map <String, Object> output = new Map<String, Object>();
        inputs.put('ContextId', 'testContext');
        inputs.put('CreateAccount', getCreateAccountNode('askjnas2@akjsdasd.com', '','VicenteTest'));        
        Boolean response;
        //Execute
        response = Boolean.valueOf(vlocityOpenInterface.invokeMethod(methodName, inputs, output, new Map<String, Object>()));
        //Validate
        System.assertEquals(false, response);                           
    }  

    @IsTest public static void testInvalidOperation() {
        //Prepare
        vlocity_ins.VlocityOpenInterface2 vlocityOpenInterface = new OSH_AccountCreation(); //Controller Account creation object
        String methodName = 'invalidOperation';
        Boolean response;
        //Execute
        response = Boolean.valueOf(vlocityOpenInterface.invokeMethod(methodName, new Map<String, Object>(), new Map<String, Object>(), new Map<String, Object>()));
        //Validate
        System.assertEquals(false, response);                           
    }    

    private static Map<String, Object> getCreateAccountNode(String username, String password, String firstName){
        Map<String,Object> createAccount = new Map<String, Object>();
        createAccount.put('Password', password);
        createAccount.put('ChooseUsername', username);
        createAccount.put('FirstName', firstName);
        createAccount.put('LastName', 'Martinez');
        createAccount.put('Email','askjnas2@akjsdasd2.com');
        return createAccount;
    }
}