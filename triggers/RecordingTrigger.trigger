/**Recording trigger */
trigger RecordingTrigger on Recording__c (before insert, before update) {
    
    // Before - Insert / Update
    if(Trigger.isInsert || Trigger.isUpdate) {
        RecordingTriggerHelper.setAccountInformation(Trigger.new);
    }
}