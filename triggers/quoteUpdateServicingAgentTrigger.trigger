trigger quoteUpdateServicingAgentTrigger on Quote (after insert) {
    if(Trigger.isInsert){
        quoteUpdateServicingAgentTriggerHelper.processQuoteAfterCreation(Trigger.new);
    }
}