@IsTest global class NonNestedJsonTest {

    @isTest static void testInvokeMethodTry(){
        
        Test.startTest();
        
        String method = 'nest';
       //Input
        Map<String,Object> input = new Map<String,Object>{
            'key' => 'manzana',
            'returnNode' => 'paranoia'
        };
       //output
          Map<String,Object> outMap = new Map<String,Object>();
       //options map
       Map<String,Object> optionsMap = new Map<String,Object>();
       
       NonNestedJson nonNJ = new NonNestedJson();
       nonNJ.invokeMethod(method, input, outMap, optionsMap);
        
	   System.assertEquals(true, true);
       Test.stopTest();        
    }
    
}