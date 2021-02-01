global without sharing class InsOSHQuoteService implements vlocity_ins.VlocityOpenInterface2{
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
       Boolean result = false;
       if('getQuoteDetail'.equalsIgnoreCase(methodName) ||'createUpdateQuote'.equalsIgnoreCase(methodName)) {
            // Get the type of the class we will create
			Type classType = Type.forName('vlocity_ins', 'InsQuoteService');
            try{
                vlocity_ins.VlocityOpenInterface2 obj = (vlocity_ins.VlocityOpenInterface2) classType.newInstance();
                obj.invokeMethod(methodName, input, outMap, options);
                result = true;
            }catch(Exception e){
                system.debug(e);
                result = false;
            }
       }
       return result;
   }
}