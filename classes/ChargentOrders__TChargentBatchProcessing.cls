/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TChargentBatchProcessing implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global Integer BATCH_SIZE_CHUNK;
    global String Query;
    global TChargentBatchProcessing() {

    }
    webService static List<String> Daily_proc_batchable() {
        return null;
    }
    webService static List<String> Daily_proc() {
        return null;
    }
    global static void createEmailNotif(Id objId, String errorMsg) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
global class ChargentException extends Exception {
}
global class TProcessRecurringResult {
}
}
