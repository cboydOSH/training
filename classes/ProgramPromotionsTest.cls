@IsTest global class ProgramPromotionsTest {

    
    @isTest static void testFormatEmpty() {
        Test.startTest();
        String METHOD_NAME = 'format';
        Map<String, Object> mapJSON = new Map<String, Object> {
                'promotionsCollection' => '[]'
        
        };
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        ProgramPromotions programPromotions1 = new ProgramPromotions();
        Boolean success1 = programPromotions1.invokeMethod(METHOD_NAME, mapJSON, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success1, true);
    }
    
    
    @isTest static void testFormatFull() {
        Test.startTest();
        String METHOD_NAME = 'format';
        Map<String, Object> programMeta = new  Map<String, Object>();
        List<Object> promotions = new List<Object>();
        promotions.add(programMeta);
        
        Map<String, Object> mapJSON = new Map<String, Object> {
            'promotionsCollection' => promotions
            };
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        ProgramPromotions programPromotions1 = new ProgramPromotions();
        Boolean success2 = programPromotions1.invokeMethod(METHOD_NAME, mapJSON, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success2, true);
    }
    
    
    @isTest static void testFilter() {
        Test.startTest();
        String METHOD_NAME = 'filter';
        
        Map<String, Object> programMeta = new  Map<String, Object>();
        List<Object> promotions = new List<Object>();//esta list tiene que tener un objeto que tenga FormatedMetadata > code, available 
        promotions.add(programMeta);
        
        Map<String, Object> mapJSON = new Map<String, Object> {
            'promotionsCollection' => promotions,
                'productCode' => '29983434876'
            };
                
                
        Map<String, Object> mapOutput = new Map<String, Object>();
        Map<String, Object> mapOptions = new Map<String, Object>();
        
        
        ProgramPromotions programPromotions3 = new ProgramPromotions();
        Boolean success3 = programPromotions3.invokeMethod(METHOD_NAME, mapJSON, mapOutput, mapOptions);
        Test.stopTest();
        System.assertEquals(success3, true);
    }
    
    
    
}