trigger accountUpdateServicingAgentTrigger on Account (after insert) {
    if(Trigger.isInsert){
        accountUpdateServicingAgentTriggerHelper.processAccountAfterCreation(Trigger.new);
    }
}