trigger accountUpdateServicingAgentTrigger on Account (after insert) {
    if(Trigger.isInsert && !Test.isRunningTest()){
        accountUpdateServicingAgentTriggerHelper.processAccountAfterCreation(Trigger.new);
    }
}