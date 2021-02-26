global without sharing class GetEnvelopesSentToday implements Vlocity_ins.VlocityOpenInterface{
    
    private String METHOD_NAME_ENVELOPES = 'getEnvelopes';

    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        Boolean isSuccess = true;
        String processErrors = 'Ok';
        try {
            if(methodName.equalsIgnoreCase(METHOD_NAME_ENVELOPES)) {
                getEnvelopes( inputMap, outMap);
            }
        } catch(Exception e) {
            
            isSuccess = false;
            processErrors = e.getMessage();
        }
        
        outMap.put('sucess', isSuccess);
        outMap.put('errors', processErrors);
        return isSuccess;
    }

    private void getEnvelopes(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        List<Contract> contracts = [SELECT Envelope_Id__c FROM Contract WHERE CreatedDate = TODAY AND Status = 'Awaiting Signature' AND Envelope_Id__c != NULL];
        List<Map<String,Object>> mapEnvelopes = new List<Map<String,Object>>();
        String stringEnvelopes = '';
        Boolean existingContracts = false;
        if (!contracts.isEmpty()) {
            for (Contract contract : contracts) {
                Map<String, Object> envelope = new Map<String, Object>();
                envelope.put('Id',contract.Envelope_Id__c);
                mapEnvelopes.add(envelope);
                stringEnvelopes += contract.Envelope_Id__c;
                stringEnvelopes += ',';
            }
            existingContracts = true;
        }
        outputMap.put('existingContracts', existingContracts);
        outputMap.put('stringEnvelopes', stringEnvelopes);
        outputMap.put('envelopes', mapEnvelopes);
    }

}