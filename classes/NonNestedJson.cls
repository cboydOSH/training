global without sharing class NonNestedJson implements vlocity_ins.VlocityOpenInterface2{
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean success = true;
        try{
            if(methodName == 'nest') {             
               nest(inputMap, outMap, options);                
            }
          }catch(Exception e){
               success=false;
         }
        return success;        
    }

    private static void nest(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        String keyToNest = (String)inputMap.get('key');
        String returnNodeName = (String)inputMap.get('returnNode'); 
        Map<String,Object> outputModelMap = new Map<String,Object>();
        for(String key : inputMap.keySet()){ 
            if(key.contains(keyToNest)){ 
                outputModelMap.put(key, inputMap.get(key));
            }
        }
        outMap.put(returnNodeName, outputModelMap);
    }
}