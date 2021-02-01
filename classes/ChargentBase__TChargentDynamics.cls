/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TChargentDynamics {
    global static String chargentObjectName {
        get;
        set;
    }
    global static Set<String> installedPackages {
        get;
    }
    global static String namespacePrefix {
        get;
        set;
    }
    global static String addFieldNamespacePrefix(String fieldName) {
        return null;
    }
    global static String addNamespacePrefix(String objType) {
        return null;
    }
    @Deprecated
    global static SObject createObject(String typeName) {
        return null;
    }
    @Deprecated
    global static SObject createObject(String typeName, Map<String,Object> valuesMap) {
        return null;
    }
    global static void determinePrefixById(Id byId) {

    }
global class AccountUpdaterLog extends ChargentBase.TChargentDynamics.DynamicObject {
    global AccountUpdaterLog() {

    }
    global AccountUpdaterLog(SObject aul) {

    }
    global AccountUpdaterLog(Map<String,Object> values) {

    }
    @Deprecated
    global SObject queryLimit1ById(Id aulId, List<String> objFields) {
        return null;
    }
}
global class ChargentAutomatedCollection extends ChargentBase.TChargentDynamics.DynamicObject {
    global ChargentAutomatedCollection() {

    }
    global ChargentAutomatedCollection(SObject ac) {

    }
    global ChargentAutomatedCollection(Map<String,Object> values) {

    }
}
global class ChargentAutomatedCollectionsStage extends ChargentBase.TChargentDynamics.DynamicObject {
    global ChargentAutomatedCollectionsStage() {

    }
    global ChargentAutomatedCollectionsStage(SObject acStage) {

    }
    global ChargentAutomatedCollectionsStage(Map<String,Object> values) {

    }
}
global class ChargentException extends Exception {
}
global class ChargentOOC extends ChargentBase.TChargentDynamics.DynamicObject {
    global ChargentOOC() {

    }
    global ChargentOOC(Id sobjId) {

    }
    global ChargentOOC(SObject obj) {

    }
    global ChargentOOC(Map<String,Object> values) {

    }
    @Deprecated
    global SObject queryLimit1(Id objId, List<String> objFields) {
        return null;
    }
    @Deprecated
    global List<SObject> query(Id objId, List<String> objFields) {
        return null;
    }
}
global class ChargentTransaction extends ChargentBase.TChargentDynamics.DynamicObject {
    global ChargentTransaction() {

    }
    global ChargentTransaction(SObject tr) {

    }
    global ChargentTransaction(Map<String,Object> values) {

    }
    @Deprecated
    global List<SObject> query(Id objId, List<String> objFields) {
        return null;
    }
}
global abstract class DynamicObject {
    global DynamicObject() {

    }
    global Object get(String field) {
        return null;
    }
    global SObject getSObject() {
        return null;
    }
    global void set(String field, Object value) {

    }
    global void setSObject(SObject s) {

    }
}
global class EmailNotification extends ChargentBase.TChargentDynamics.DynamicObject {
    global EmailNotification() {

    }
    global EmailNotification(SObject en) {

    }
    global EmailNotification(Map<String,Object> values) {

    }
}
global class PaymentRequest extends ChargentBase.TChargentDynamics.DynamicObject {
    global PaymentRequest() {

    }
    global PaymentRequest(SObject pr) {

    }
    global PaymentRequest(Map<String,Object> values) {

    }
    @Deprecated
    global SObject queryLimit1ById(Id prId, List<String> objFields) {
        return null;
    }
    @Deprecated
    global SObject queryLimit1(String hashSum, List<String> objFields) {
        return null;
    }
}
}
