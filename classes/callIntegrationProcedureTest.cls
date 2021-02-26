@isTest
public class callIntegrationProcedureTest {

    @isTest
    static void callIpMethod() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Boolean ret = callIntegrationProcedure.invokeMethod('callIp', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @isTest
    static void callIp2Method() {

    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Boolean ret = callIntegrationProcedure.invokeMethod('callIp2', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
    
}