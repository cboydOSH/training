@IsTest global class OSHTransformUpdateTokenInputTest {

     @isTest static void testTransform() {
        
        Test.startTest(); 
         
        String METHOD_NAME = 'transform';
        Map<String, Object> details = new  Map<String, Object>();
        List<Object> prevChargentOrders = new  List<Object>(); 
        Map<String, Object> listOfChargentOrdersId = new Map<String, Object>();
        prevChargentOrders.add(listOfChargentOrdersId);
         
         
        Map<String, Object> mapInput = new Map<String, Object> {
                'Details' => details,
                'PrevChargentOrders' => prevChargentOrders
        
        };
         
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        OSHTransformUpdateTokenInput transformToken = new OSHTransformUpdateTokenInput();
        Boolean success = transformToken.invokeMethod(METHOD_NAME, mapInput,mapOutput, mapOptions);
         
        Test.stopTest(); 
         
        System.assertEquals(success, true); 
     }
    
}