global without sharing class OSHTransformUpdateTokenInput implements vlocity_ins.VlocityOpenInterface2 {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options) {
        if(methodName == 'transform'){
            return transform(inputs, output, options);
        }
        return false;
    }
    public boolean transform(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
        Map<String,Object> chargentOrderDetailMap = (Map<String,Object>)inputs.get('Details');
        List<Object> listOfChargentOrdersIds = (List<Object>)inputs.get('PrevChargentOrders');
        for(Object obj : listOfChargentOrdersIds){
            Map<String,Object> chargentMap = (Map<String,Object>)obj;
            for(String key : chargentOrderDetailMap.keySet()){
                chargentMap.put(key, chargentOrderDetailMap.get(key));
            }
        }
        output.put('formatedInput', listOfChargentOrdersIds);
        return true;
    }
}