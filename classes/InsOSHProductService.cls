global without sharing class InsOSHProductService implements vlocity_ins.VlocityOpenInterface2{
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
        Boolean result = false;
        system.debug('1');
        if('getRatedGroupProducts'.equalsIgnoreCase(methodName)) {
             system.debug('2');
             // Get the type of the class we will create
             Type classType = Type.forName('vlocity_ins', 'InsProductService');
             system.debug('3');
             try{
                 vlocity_ins.VlocityOpenInterface2 obj = (vlocity_ins.VlocityOpenInterface2) classType.newInstance();
                 system.debug('4');
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