@isTest
public class InsOSHProductServiceTest {

    @isTest
    static void getQuoteDetailTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        InsOSHProductService ins = new InsOSHProductService();
        Boolean ret = ins.invokeMethod('getRatedGroupProducts', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
}