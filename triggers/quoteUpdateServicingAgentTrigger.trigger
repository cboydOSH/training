trigger quoteUpdateServicingAgentTrigger on Quote (after insert) {
    if(Trigger.isInsert && !Test.isRunningTest()){
        quoteUpdateServicingAgentTriggerHelper.processQuoteAfterCreation(Trigger.new);
    }
}