@IsTest global class OSHUserSecurityImplTest {
 	
    
    @isTest static void testEncryptIfNecessary() {
        Test.startTest(); 
         
        String METHOD_NAME = 'encryptIfNecessary';
        Map<String, Object> mapInput = new Map<String, Object> {
                'unencryptedString' => 'testString'
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        OSHUserSecurityImpl userSecurity = new OSHUserSecurityImpl();
        Boolean success1 = userSecurity.invokeMethod(METHOD_NAME, mapInput, mapOutput, mapOptions);
        
        Test.stopTest(); 
         
        System.assertEquals(success1, true); 
    }
    
    
    @isTest static void testDecryptIfNecessary() {
        Test.startTest(); 
         
        String METHOD_NAME = 'decryptIfNecessary';
        Map<String, Object> mapInput = new Map<String, Object> {
                'possiblyEncryptedString' => 'testString'
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        OSHUserSecurityImpl userSecurity = new OSHUserSecurityImpl();
        Boolean success2 = userSecurity.invokeMethod(METHOD_NAME, mapInput, mapOutput, mapOptions);
        
        Test.stopTest(); 
         
        System.assertEquals(success2, true);
    }
    
    
    @isTest static void testDecryptCreateUpdateQuoteRequest() {
        Test.startTest(); 
        Map<String, Object> input1 = new  Map<String, Object>{
            'Key1' => 'Value1',
            'Key2' => 'Value2'
        };
        String METHOD_NAME = 'decryptCreateUpdateQuoteRequest';
        Map<String, Object> mapInput = new Map<String, Object> {
                'input' => input1
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
            
        OSHUserSecurityImpl userSecurity = new OSHUserSecurityImpl();
        Boolean success3 = userSecurity.invokeMethod(METHOD_NAME, mapInput, mapOutput, mapOptions);
        
        Test.stopTest(); 
         
        System.assertEquals(success3, true);
    }
    
    
    @isTest static void testEncryptCreateUpdateQuoteRequest() {
        Test.startTest(); 
        Map<String, Object> input1 = new  Map<String, Object>{
            'Key1' => 'Value1',
            'Key2' => 'Value2'
        };
        String METHOD_NAME = 'encryptCreateUpdateQuoteRequest';
        Map<String, Object> mapInput = new Map<String, Object> {
                'input' => input1
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
            
        OSHUserSecurityImpl userSecurity = new OSHUserSecurityImpl();
        Boolean success4 = userSecurity.invokeMethod(METHOD_NAME, mapInput, mapOutput, mapOptions);
        
        Test.stopTest(); 
         
        System.assertEquals(success4, true);
    }
    
    
    @isTest static void testPrint() {
        Test.startTest(); 
        Map<String, Object> input1 = new  Map<String, Object>{
            'Key1' => 'Value1',
            'Key2' => 'Value2'
        };
        String METHOD_NAME = 'print';
        Map<String, Object> mapInput = new Map<String, Object> {
                'input' => input1
        }; 
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
            
        OSHUserSecurityImpl userSecurity = new OSHUserSecurityImpl();
        Boolean success5 = userSecurity.invokeMethod(METHOD_NAME, mapInput, mapOutput, mapOptions);
        
        Test.stopTest(); 
         
        System.assertEquals(success5, true);
    }
    
    
}