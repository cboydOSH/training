global without sharing class OSHRelateContractWithAsset implements vlocity_ins.VlocityOpenInterface2 {

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
       Boolean result = false;
       if('updateAssetWithContract'.equalsIgnoreCase(methodName)) {
           system.debug('1');
           result = updateAssetWithContract(input,outMap,options);
       }
       return result;
       
   }

   public Boolean updateAssetWithContract(Map<String, Object> input, Map<String, Object> outMap,Map<String, Object> options){
        String assetId = (String)input.get('assetId');
        String contractId = (String)input.get('contractId');
        try {
            Asset a = [Select Id, Contract__c From Asset Where Id = :assetId];
            a.Contract__c = contractId;
            update a;
            return true;
        } catch (Exception e) {
            system.debug(e);
            return false;
        }
   }

    public OSHRelateContractWithAsset() {}
}