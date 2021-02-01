global without sharing class OSHQuoteService implements vlocity_ins.VlocityOpenInterface2{
    public Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> outputs, Map<String, Object> options){
        try {
            if (methodName == 'updateQuoteAfterCreation') {
                system.debug('inside updateQuoteAfterCreation');
                return updateQuoteAfterCreation(inputs, outputs, options);
            }
        } catch (Exception e) {
            outputs.put('Error', e.getMessage());
            outputs.put('ErrorLine', e.getLineNumber());
            outputs.put('ErrorType', e.getTypeName());
            outputs.put('MethodName', methodName);
        }
         return false;
    }

    
    @TestVisible private Boolean updateQuoteAfterCreation(Map<String,Object> inputs, Map<String,Object> outputs, Map<String,Object> options){
        for(String key : inputs.keySet()){
            system.debug('key: ' + key + ' value: ' + inputs.get(key));
        }
        String quoteId = (String)inputs.get('quoteId');
        Quote quote = [SELECT Id, Servicing_Agent__c, Writing_agent__c, Enroller_Id__c, Agent_Label__c, Age_Period_30d__c, vlocity_ins__EffectiveDate__c,
                        Age_Period_60d__c, Rating_Member__c, Old_MemBer_Based_Dob__c, Price_Change__c, Status, Information_Packet_Number__c
                        FROM Quote 
                        WHERE Id =: quoteId];
        System.debug(quote);                        
        quote.Information_Packet_Number__c = (String)inputs.get('informationPacketNumber');
        quote.Age_Period_30d__c = String.valueOf(inputs.get('addInfo30')) != '' ? (Boolean)inputs.get('addInfo30') : false;
        quote.Age_Period_60d__c = String.valueOF(inputs.get('addInfo60')) != '' ? (Boolean)inputs.get('addInfo60') : false;

        List<String> dateList = String.valueOF(inputs.get('oldestDOB')).split('-');
        Date memberDOB = date.parse(dateList.get(1)+'/'+dateList.get(2)+'/'+dateList.get(0));
        quote.Old_MemBer_Based_Dob__c =  memberDOB;
        List<String> dateList2 = String.valueOF(inputs.get('effectiveDate')).split('-');
        Date memberEffectiveDate = date.parse(dateList2.get(1)+'/'+dateList2.get(2)+'/'+dateList2.get(0));
        quote.vlocity_ins__EffectiveDate__c = memberEffectiveDate;
        quote.Price_Change__c = (Boolean)inputs.get('priceChange');
        quote.Rating_Member__c = (String)inputs.get('ratingMemberId');
        quote.Status = (String)inputs.get('quoteStatus');
        quote.Servicing_Agent__c = (String)inputs.get('servicingAgent');
        quote.Writing_agent__c = (String)inputs.get('writingAgent');
        quote.Enroller_Id__c = (String)inputs.get('enrollerId');
        quote.Agent_Label__c = (String)inputs.get('agentLabel');
        update quote;
        system.debug('updatedQuote' + quote);
        String leadId = (String)inputs.get('leadId');
        Lead lead = [SELECT Id, Status FROM Lead WHERE Id = :leadId];
        lead.Status = (String)inputs.get('leadStatus');
        update lead;
        system.debug('updatedLead' + lead);
        return true;
    }
}