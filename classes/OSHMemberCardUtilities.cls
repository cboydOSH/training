global without sharing class OSHMemberCardUtilities implements Vlocity_ins.VlocityOpenInterface{
    public static final String FEE = 'Fee';
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        if (methodName == 'getMemberCardPDFData') {
            return getMemberCardPDFData(inputMap, outputMap, options);
        }
        return false;
    }

    private Boolean getMemberCardPDFData(Map<String, Object> inputMap, Map <String, Object> outputMap, Map <String, Object> optionsMap) {
        //PRICAREPHY / URGCAREFAC / EMERGROOM / TELEMED
        String accountId = (String)inputMap.get('AccountId');
        Integer secuentialFee = 2;
        Map<String,String> keysToMap = new Map<String,String>{'PRICAREPHY'=>'PCP: '
                                                                , 'URGCAREFAC'=>'Urgent Care: '
                                                                , 'EMERGROOM' => 'ER: '
                                                                , 'TELEMED' => 'Telemedicine: '};
        Map<String,Object> pdfDataOutputMap = new Map<String,Object>();

        Asset asset = [SELECT Id, Status, Contract__c, Group_Code__c FROM Asset WHERE AccountId =: accountId LIMIT 1];
        Account account = [SELECT Name, Member_ID__pc FROM Account WHERE Id =: accountId LIMIT 1];
        Contract contract  = [SELECT StartDate, Id, Recurring_Payment_Order__c FROM Contract WHERE Id =:asset.Contract__c LIMIT 1];
        List<vlocity_ins__ContractLineItem__c> contractLineITems = [SELECT id, vlocity_ins__contractid__c, vlocity_ins__attributeselectedvalues__c, name 
                                                                FROM vlocity_ins__ContractLineItem__c 
                                                                WHERE vlocity_ins__ContractId__c =: contract.Id];
        for(vlocity_ins__ContractLineItem__c lineItem : contractLineITems){
            if(lineItem.vlocity_ins__attributeselectedvalues__c!= null && lineItem.vlocity_ins__attributeselectedvalues__c!=''){
                Map<String,Object> lineItemMap = (Map<String, Object>) JSON.deserializeUntyped(lineItem.vlocity_ins__attributeselectedvalues__c);
                for(String key : lineItemMap.keySet()){
                    if(keysToMap.containsKey(key)){
                        String value = '';
                        String temp = (String)lineItemMap.get(key);
                        if(temp != null && temp.length()>1){
                            system.debug('key: '+ key + 'value: ' + temp);
                            if(key=='TELEMED'){
                                value = temp.substring(temp.indexOf('(')+1, temp.indexOf(')'));
                            }else{
                                if(temp.indexOf('-')!=-1){
                                    value = temp.substring(0, temp.indexOf('-'));
                                }else{
                                    value = temp;
                                }                                
                            }
                            pdfDataOutputMap.put(FEE+secuentialFee, keysToMap.get(key) + value);
                            secuentialFee=secuentialFee+1;
                        }
                        keysToMap.remove(key);
                    }
                }
            }
        }
        pdfDataOutputMap.put(FEE+1,'Preventive Care - $0');
        pdfDataOutputMap.put('Name',account.Name);
        pdfDataOutputMap.put('MemberID',account.Member_ID__pc);
        pdfDataOutputMap.put('KeyForBenefit',asset.Group_Code__c.substring(4,7));
        pdfDataOutputMap.put('Status',asset.Status);
        pdfDataOutputMap.put('GroupCode',asset.Group_Code__c);
        pdfDataOutputMap.put('ContractId',contract.Id);
        pdfDataOutputMap.put('EffectiveDate',contract.StartDate);
        outputMap.put('pdfData', pdfDataOutputMap);
        outputMap.put('state', asset.Group_Code__c.substring(2,4));
        return true;
    }
}