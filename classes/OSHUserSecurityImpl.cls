global with sharing class OSHUserSecurityImpl implements vlocity_ins.VlocityOpenInterface2{   
    public Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> outputs, Map<String, Object> options){
       try {
           if (methodName == 'encryptIfNecessary') {
               return encryptIfNecessary(inputs, outputs, options);
           }
           if (methodName == 'decryptIfNecessary') {
               return decryptIfNecessary(inputs, outputs, options);
           }
            if(methodName == 'decryptCreateUpdateQuoteRequest') {
            return decryptCreateUpdateQuoteRequest(inputs, outputs, options);
            }
            if(methodName == 'encryptCreateUpdateQuoteRequest') {
               return encryptCreateUpdateQuoteRequest(inputs, outputs, options);
            }
            if(methodName == 'print') {
                return print(inputs, outputs, options);
             }
       } catch (Exception e) {
           outputs.put('Error', e.getMessage());
           outputs.put('ErrorLine', e.getLineNumber());
           outputs.put('ErrorType', e.getTypeName());
           outputs.put('MethodName', methodName);
       }
        return false;
   }

    private Boolean encryptIfNecessary(Map<String,Object> inputs, Map<String,Object> outputs, Map<String,Object> options){
       String unencryptedString = (String) inputs.get('unencryptedString');
       outputs.put('encryptedStringIfNecessary', vlocity_ins.UserSecurity.encryptIfNecessary(unencryptedString));
       return true;
   }

    private Boolean decryptIfNecessary(Map<String,Object> inputs, Map<String,Object> outputs, Map<String,Object> options){
       String possiblyEncryptedString = (String) inputs.get('possiblyEncryptedString');
       outputs.put('decryptedStringIfNecessary', vlocity_ins.UserSecurity.decryptIfNecessary(possiblyEncryptedString));
       return true;
   }

   private Boolean decryptCreateUpdateQuoteRequest(Map<String,Object> inputs, Map<String,Object> outputs, Map<String,Object> options){
        Map<String,Object> mainInput = (Map<String,Object>)inputs.get('input');
        for(String key : mainInput.keySet()){
            try{
                String value = (String) mainInput.get(key);
                Object valuetoreturn = vlocity_ins.UserSecurity.decryptIfNecessary(value);
                outputs.put(key, valuetoreturn);
            }catch(Exception e){
                outputs.put(key, mainInput.get(key));
            }
        }
        return true;
    }

    private Boolean encryptCreateUpdateQuoteRequest(Map<String,Object> inputs, Map<String,Object> outputs, Map<String,Object> options){
        Map<String,Object> mainInput = (Map<String,Object>)inputs.get('input');
        system.debug('mainInput encrypt: ' + mainInput);
        for(String key : mainInput.keySet()){
            try{
                String value = (String) mainInput.get(key);
                Object valuetoreturn = vlocity_ins.UserSecurity.encryptIfNecessary(value);
                //system.debug('on try value: ' + value + 'valueToReturn: ' + valuetoreturn);
                outputs.put(key, valuetoreturn);
            }catch(Exception e){
                //system.debug('on try value: ' + key + 'valueToReturn: ' + mainInput.get(key));
                outputs.put(key, mainInput.get(key));
            }
        }
        return true;
    }

    private Boolean print(Map<String,Object> inputs, Map<String,Object> outputs, Map<String,Object> options){
        Map<String,Object> mainInput = (Map<String,Object>)inputs.get('input');
        for(String key : mainInput.keySet()){
            system.debug('on try value: ' + key + 'valueToReturn: ' + mainInput.get(key));
        }
        return true;
    }
}