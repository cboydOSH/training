/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@isTest
global class TChargentStaticHelper {
    global String indicatorString {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global TChargentStaticHelper(ApexPages.StandardController c) {

    }
    @Deprecated
    @isTest(SeeAllData=false OnInstall=false)
    global static void HelperTest() {

    }
    @Deprecated
    @isTest(SeeAllData=false OnInstall=false)
    global static void TCHtest() {

    }
    global static String TrimToLength(String s_str, Integer len) {
        return null;
    }
    @Deprecated
    global static void am11() {

    }
    @Deprecated
    global static void am12() {

    }
    @Deprecated
    global static void am13() {

    }
    @Deprecated
    global static void am14() {

    }
    @Deprecated
    global static void am15() {

    }
    @Deprecated
    global static void am16() {

    }
    @Deprecated
    global static void am17() {

    }
    @Deprecated
    global static ChargentBase.TChargentOperations.TChargentResult authorizeOpportunity(Id objId) {
        return null;
    }
    global static Date calculateChargeDate(Date selectedDate, Integer preferedDay) {
        return null;
    }
    @Deprecated
    @isTest(SeeAllData=false OnInstall=false)
    global static void calculateDay() {

    }
    global static Date calculateNextPaymentDate(SObject c_srcObj, Date lastPaymentDate, Date startPaymentDate) {
        return null;
    }
    @Deprecated
    global static ChargentBase.TChargentOperations.TChargentResult chargeOpportunity(Id objId) {
        return null;
    }
    global static void checkChargentFeature(String name) {

    }
    global static void checkChargentKey() {

    }
    global static void createAccountUpdaterLog(String Message, Boolean Status, Id objId, Id errorObjId, Id aulId) {

    }
    global static Map<String,Object> decrypt(String req) {
        return null;
    }
    global static Boolean deleteSObjects(List<SObject> objList) {
        return null;
    }
    global static String encrypt(Map<String,Object> rm) {
        return null;
    }
    global static Boolean featureActivationBooleanCheck(String featureName) {
        return null;
    }
    global static String getAccountUpdaterLink(Id objId, Id aulId) {
        return null;
    }
    global static List<System.SelectOption> getExpYearOptions() {
        return null;
    }
    global static String getOrgIP() {
        return null;
    }
    global static void getPaymentRequestLink(SObject obj) {

    }
    global static String getRandomString(Integer length) {
        return null;
    }
    global static Boolean insertSObject(SObject obj) {
        return null;
    }
    global static Boolean insertSObjects(List<SObject> objList) {
        return null;
    }
    webService static Boolean isRequireCvv(String objectId, String action) {
        return null;
    }
    global static Boolean isTrxStatusFinal(String currentStatus, String devName) {
        return null;
    }
    @Deprecated
    global static ChargentBase.TChargentOperations.TChargentResult refundOpportunity(Id objId) {
        return null;
    }
    global static void sendAdminErrorMessage(SObject obj, Exception e) {

    }
    global static Boolean updateSObject(SObject obj) {
        return null;
    }
    global static Boolean updateSObjects(List<SObject> objList) {
        return null;
    }
    global static Boolean upsertSObject(SObject obj) {
        return null;
    }
    global static Boolean upsertSObjects(List<SObject> objList) {
        return null;
    }
    global static ChargentBase.TChargentOperations.TChargentResult voidOpportunity(Id objId) {
        return null;
    }
    global static ChargentBase.TChargentOperations.TChargentResult voidTransaction(Id objId) {
        return null;
    }
global class GatewayException extends Exception {
}
}
