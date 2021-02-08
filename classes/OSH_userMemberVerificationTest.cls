@isTest
public class OSH_userMemberVerificationTest {

    @isTest
    static void verifyUserAccountTest() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('Email', 'emmialtest@test.com');
        OSH_userMemberVerification ins = new OSH_userMemberVerification();
        Boolean ret = ins.invokeMethod('verifyUserAccount', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }


    @isTest
    static void verifyUserAccountExistTest() {
        //Create user
        Profile p = [SELECT Id FROM Profile LIMIT 1]; 
        User u = new User(Alias = 'standt', Email='emialtest@test.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testexample@test.com');
        insert u;

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('Email', 'emialtest@test.com');
        OSH_userMemberVerification ins = new OSH_userMemberVerification();
        Boolean ret = ins.invokeMethod('verifyUserAccount', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
    
    @isTest
    static void verifyUserAccountFail() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        OSH_userMemberVerification ins = new OSH_userMemberVerification();
        Boolean ret = ins.invokeMethod('failTest', inputMap, outMap, options);
        System.assertEquals(false, ret);
    }
}