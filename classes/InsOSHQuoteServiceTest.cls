@isTest
public class InsOSHQuoteServiceTest {

    @isTest
    static void getQuoteDetailTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        InsOSHQuoteService ins = new InsOSHQuoteService();
        Boolean ret = ins.invokeMethod('getQuoteDetail', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
}