/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@isTest
global virtual class TGateway {
    global String Address {
        get;
        set;
    }
    global String Address2 {
        get;
        set;
    }
    global String ADDRRespCode;
    global String Amount {
        get;
        set;
    }
    global String AmountCurrency {
        get;
        set;
    }
    global String AuthorizationCode {
        get;
        set;
    }
    global List<String> AVSFailureCodes {
        get;
    }
    global String BankAccountLast4 {
        get;
        set;
    }
    global String BankAccountName {
        get;
        set;
    }
    global String BankAccountNum {
        get;
        set;
    }
    global String BankAccountType {
        get;
        set;
    }
    global String BankName {
        get;
        set;
    }
    global String BankRoutingNum {
        get;
        set;
    }
    global Boolean CalloutSent;
    global String CardCode {
        get;
        set;
    }
    global String CardLast4 {
        get;
        set;
    }
    global String CardType {
        get;
        set;
    }
    global List<String> CCVFailureCodes {
        get;
    }
    global String City {
        get;
        set;
    }
    global String ClassName;
    global String Company {
        get;
        set;
    }
    global String Country {
        get;
        set;
    }
    global String CPFNumber {
        get;
        set;
    }
    global String CreditCardName {
        get;
        set;
    }
    global String CreditCardNum {
        get;
        set;
    }
    global String CustomerEmail {
        get;
        set;
    }
    global String CustomerId {
        get;
        set;
    }
    global String CustomerIp {
        get;
        set;
    }
    global String CustomerToken {
        get;
        set;
    }
    global String CustomFieldsJSON {
        get;
        set;
    }
    global String CustomTransactionType {
        get;
        set;
    }
    global String CVV2RespCode;
    global String Dateofbirth {
        get;
        set;
    }
    global Boolean DebugMode {
        get;
        set;
    }
    global String DebugString;
    global String EndpointOverride {
        get;
        set;
    }
    global Integer ExpMonth {
        get;
        set;
    }
    global Integer ExpYear {
        get;
        set;
    }
    global String f_Address;
    global String f_Address2;
    global String f_Amount;
    global Boolean f_ApproveSoftRejects;
    global String f_AuthorizationCode;
    global String f_BankAccountLast4;
    global String f_BankAccountName;
    global String f_BankAccountNum;
    global String f_BankAccountType;
    global String f_BankName;
    global String f_BankRoutingNum;
    global String f_CardCode;
    global String f_CardLast4;
    global String f_CardType;
    global String f_City;
    global String f_Company;
    global String f_Country;
    global String f_CPFNumber;
    global String f_CreditCardName;
    global String f_CreditCardNum;
    global String f_Currency;
    global String f_CustomerEmail;
    global String f_CustomerId;
    global String f_CustomerIp;
    global String f_CustomerToken;
    global String f_CustomFieldsJSON;
    global String f_CustomTransactionType;
    global String f_Dateofbirth;
    global Boolean f_Debug;
    global Boolean f_DoEmailCustomer;
    global String f_EndpointOverride;
    global Integer f_ExpMonth;
    global Integer f_ExpYear;
    global String f_Fax;
    global String f_FirstName;
    global Boolean f_IgnoreAVSCheck;
    global Boolean f_IgnorePreviousAuthorization;
    global String f_Invoice;
    global String f_LastName;
    global String f_MCAuthType;
    global String f_MerchantEmail;
    global String f_MerchantId;
    global String f_MerchantReference;
    global String f_ModusLinkTestMode;
    global Boolean f_OmitExpiry;
    global String f_OOCId;
    global String f_OrbitalPlatform;
    global String f_OrderInformation;
    global String f_OrderSource;
    global ChargentBase.TGateway.TPaymentMethod f_PaymentMethod;
    global String f_Phone;
    global String f_PONumber;
    global Boolean f_RequireAVS;
    global Boolean f_RequireCCV;
    global String f_SecurityKey;
    global String f_ShippingAddress;
    global String f_ShippingAddressLine2;
    global String f_ShippingAmount;
    global String f_ShippingCity;
    global String f_ShippingCompany;
    global String f_ShippingCountry;
    global String f_ShippingDuty;
    global String f_ShippingFirstName;
    global String f_ShippingLastName;
    global String f_ShippingState;
    global String f_ShippingZip;
    global String f_State;
    global String f_strAVSFailureCodes;
    global String f_strCCVFailureCodes;
    global String f_Tax;
    global Boolean f_TaxExempt;
    global Boolean f_TestMode;
    global String f_Tokenization;
    global String f_TransactionDescription;
    global String f_TransactionId;
    global String f_TransactionSecurityKey;
    global ChargentBase.TGateway.TTransactionType f_TransactionType;
    global Boolean f_UnlinkedRefund;
    global Boolean f_UpdateToken;
    global Boolean f_UseReferenceTransactions;
    global String f_Username;
    global Boolean f_UseTokenization;
    global String f_Zip;
    global String Fax {
        get;
        set;
    }
    global String FirstName {
        get;
        set;
    }
    global Id Gateway {
        get;
        set;
    }
    global ChargentBase__Gateway__c GatewayData;
    global String GatewayName;
    global String GatewayResponse;
    global Boolean GatewayTestMode {
        get;
        set;
    }
    global String IAVSRespCode;
    global Boolean IgnorePreviousAuthorization {
        get;
        set;
    }
    global String Invoice {
        get;
        set;
    }
    global String LastName {
        get;
        set;
    }
    global ChargentBase.TGateway.TTransactionType LastTransactionType;
    global String MCAuthType {
        get;
        set;
    }
    global String MerchantEmail {
        get;
        set;
    }
    global String MerchantId {
        get;
        set;
    }
    global String MerchantReference {
        get;
        set;
    }
    global String ModusLinkTestMode {
        get;
        set;
    }
    global String OOCId {
        get;
        set;
    }
    global String OrbitalPlatform {
        get;
        set;
    }
    global String OrderInformation {
        get;
        set;
    }
    global String OrderSource {
        get;
        set;
    }
    global Boolean p_DebugMode;
    global String p_GatewayResponse;
    global ChargentBase.TGateway.TPaymentMethod PaymentMethod {
        get;
        set;
    }
    global String Phone {
        get;
        set;
    }
    global String PONumber {
        get;
        set;
    }
    global String ReasonCode;
    global String ReasonText;
    global Boolean RequireAVS {
        get;
    }
    global Boolean RequireCCV {
        get;
    }
    global String ResponseCode;
    global String ResponseText;
    global String SecretKey;
    global String SecurityKey {
        get;
        set;
    }
    global String ShippingAddress {
        get;
        set;
    }
    global String ShippingAddressLine2 {
        get;
        set;
    }
    global String ShippingAmount {
        get;
        set;
    }
    global String ShippingCity {
        get;
        set;
    }
    global String ShippingCompany {
        get;
        set;
    }
    global String ShippingCountry {
        get;
        set;
    }
    global String ShippingDuty {
        get;
        set;
    }
    global String ShippingFirstName {
        get;
        set;
    }
    global String ShippingLastName {
        get;
        set;
    }
    global String ShippingState {
        get;
        set;
    }
    global String ShippingZip {
        get;
        set;
    }
    global Boolean ShowDebugString {
        get;
        set;
    }
    global String State {
        get;
        set;
    }
    global String Tax {
        get;
        set;
    }
    global Boolean TaxExempt {
        get;
        set;
    }
    global Boolean TestMode {
        get;
        set;
    }
    global String Tokenization {
        get;
        set;
    }
    global String TransactionDescription {
        get;
        set;
    }
    global String TransactionId {
        get;
        set;
    }
    global ChargentBase.TGateway.TTransactionType TransactionType {
        get;
        set;
    }
    global Boolean UnlinkedRefund {
        get;
        set;
    }
    global Boolean UpdateToken {
        get;
        set;
    }
    global Boolean UseReferenceTransactions {
        get;
        set;
    }
    global String Username {
        get;
        set;
    }
    global Boolean UseTokenization {
        get;
        set;
    }
    global String ValidateResultString;
    global String VersionOfApi;
    global String Zip {
        get;
        set;
    }
    global String ZIPRespCode;
    global TGateway() {

    }
    global virtual Boolean Authorize() {
        return null;
    }
    global virtual Boolean AuthorizeAndCharge() {
        return null;
    }
    global String BoolToString(Boolean bValue) {
        return null;
    }
    global virtual Boolean ChargeAuthorized() {
        return null;
    }
    global String GetClassName() {
        return null;
    }
    global String GetExpDate(String sDateFormat) {
        return null;
    }
    global virtual String GetTransactionStatus() {
        return null;
    }
    global Boolean IsEmpty(String sValue) {
        return null;
    }
    global virtual Boolean Refund() {
        return null;
    }
    global virtual Boolean RegisterToken() {
        return null;
    }
    global virtual Boolean SendPaymentDetails() {
        return null;
    }
    @Deprecated
    @isTest(SeeAllData=false OnInstall=false)
    global static void TGatewayTest() {

    }
    global virtual Boolean UpdateTransactionStatus() {
        return null;
    }
    global Boolean Validate_CC() {
        return null;
    }
    global Boolean Validate_ECHECK() {
        return null;
    }
    global virtual Boolean Voidt() {
        return null;
    }
global enum TPaymentMethod {CC, ECHECK, NONE}
global enum TResponseCode {ADDITIONALSTEP, APPROVED, DECLINED, ERROR, HELDFORREVIEW, NONE, SUCCESS}
global enum TTransactionType {AUTHORIZE, AUTHORIZE_AND_CHARGE, CHARGE_AUTHORIZED, CHARGE_NOT_AUTHORIZED, NONE, REFUND, REGISTER_PAYER, REGISTER_TOKEN, SEND_PAYMENT_DETAILS, UPDATE_TRANSACTION_STATUS, VOIDT}
}
