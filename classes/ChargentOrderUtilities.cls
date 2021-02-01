global without sharing class ChargentOrderUtilities {
    @AuraEnabled 
    public static void voidTransaction(String transactionId){
    system.debug('voidTransaction executed');
    system.debug('parameters');
    //print parameter received
    system.debug('transactionId: ' + transactionId);
    //everything inside a try for troubleshoot
    try{
        //get chargent order transaction object
        ChargentOrders__Transaction__c chargentOrderTransaction = [SELECT Id, ChargentOrders__Type__c FROM ChargentOrders__Transaction__c WHERE Id=:transactionId];
        //update type to void
        chargentOrderTransaction.ChargentOrders__Type__c = 'Void';
        //update the record
        update chargentOrderTransaction;
    }catch(Exception e){
        system.debug(e);
    }
   }
   @AuraEnabled 
    public static void voidListOfTransactions(List<String> transactionIds){
    system.debug('voidTransaction executed');
    system.debug('parameters');
    //print parameter received
    system.debug('transactionIds: ' + transactionIds);
    //everything inside a try for troubleshoot
    try{
        // get all transactions based on the LIST received
        List<ChargentOrders__Transaction__c> chargentOrderTransactions = [SELECT Id, ChargentOrders__Type__c FROM ChargentOrders__Transaction__c WHERE Id IN:transactionIds];
        //for each and every chargent order transaction recived
        for(ChargentOrders__Transaction__c chargentOrderTransaction : chargentOrderTransactions){
            //update the type to void
            chargentOrderTransaction.ChargentOrders__Type__c = 'Void';
        }
        //update all transactions applicable based on the query [row 29]
        update chargentOrderTransactions;
    }catch(Exception e){
        system.debug(e);
    }
   }  
}