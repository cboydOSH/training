public class RecordingTriggerHelper {
    public static void setAccountInformation(List<Recording__c> newRecordings) {
        Set<String> newPhoneNumbers = new Set<String>();
        for(Recording__c newRecording : newRecordings) {
            newPhoneNumbers.add(newRecording.Phone__c);
        }
        
    List<Account> accounts = [SELECT Id, RecordType.Name, Account__c, Phone
                              FROM Account
                              WHERE IsPersonAccount = true AND
                                    Phone IN :newPhoneNumbers];	
        
    // With Map --> works for dataload of hundreds of recordings insert at a time
    Map<String, Id> phoneToAccountId = new Map<String, Id>();

    for(Account accountInfo : accounts) {
        if(accountInfo.RecordType.Name == 'Dependent') {
            phoneToAccountId.put(accountInfo.Phone, accountInfo.Account__c);
        }
        else {
            phoneToAccountId.put(accountInfo.Phone, accountInfo.Id);
        }
    }

    for(Recording__c newRecording : newRecordings) {
        if(phoneToAccountId != null && phoneToAccountId.containsKey(newRecording.Phone__c)) {
            newRecording.Member_Account__c = phoneToAccountId.get(newRecording.Phone__c);
        }
    }
    }       
}