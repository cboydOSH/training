/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ChargentWebService {
    global ChargentWebService() {

    }
    webService static ChargentBase.ChargentWebService.ChargentWebOutput ProcessWeb(ChargentBase.ChargentWebService.ChargentWebInput input) {
        return null;
    }
global class ChargentWebInput {
    @WebService
    webService String Action;
    @WebService
    webService String Address;
    @WebService
    webService String Address2;
    @WebService
    webService String Amount;
    @WebService
    webService String AmountCurrency;
    @WebService
    webService String AuthorizationCode;
    @WebService
    webService String BankAccountLast4;
    @WebService
    webService String BankAccountName;
    @WebService
    webService String BankAccountNum;
    @WebService
    webService String BankAccountType;
    @WebService
    webService String BankName;
    @WebService
    webService String BankRoutingNum;
    @WebService
    webService String CardCode;
    @WebService
    webService String CardLast4;
    @WebService
    webService String CardType;
    @WebService
    webService String City;
    @WebService
    webService String Company;
    @WebService
    webService String Country;
    @WebService
    webService String CPFNumber;
    @WebService
    webService String CreditCardName;
    @WebService
    webService String CreditCardNum;
    @WebService
    webService String CustomerEmail;
    @WebService
    webService String CustomerId;
    @WebService
    webService String CustomerIp;
    @WebService
    webService String CustomerToken;
    @WebService
    webService String CustomFieldsJSON;
    @WebService
    webService String CustomTransactionType;
    @WebService
    webService String Dateofbirth;
    @WebService
    webService String DoEmailCustomer;
    @WebService
    webService String ExpMonth;
    @WebService
    webService String ExpYear;
    @WebService
    webService String Fax;
    @WebService
    webService String FirstName;
    @WebService
    webService Id Gateway;
    @WebService
    webService Boolean IgnorePreviousAuthorization;
    @WebService
    webService String Invoice;
    @WebService
    webService String LastName;
    @WebService
    webService String MCAuthType;
    @WebService
    webService String MerchantEmail;
    @WebService
    webService String OOCId;
    @WebService
    webService String OrderInformation;
    @WebService
    webService String OrderPaymentStatus;
    @WebService
    webService String OrderSource;
    @WebService
    webService String PaymentMethod;
    @WebService
    webService String Phone;
    @WebService
    webService String PONumber;
    @WebService
    webService String ShippingAddress;
    @WebService
    webService String ShippingAddressLine2;
    @WebService
    webService String ShippingAmount;
    @WebService
    webService String ShippingCity;
    @WebService
    webService String ShippingCompany;
    @WebService
    webService String ShippingCountry;
    @WebService
    webService String ShippingDuty;
    @WebService
    webService String ShippingFirstName;
    @WebService
    webService String ShippingLastName;
    @WebService
    webService String ShippingState;
    @WebService
    webService String ShippingZip;
    @WebService
    webService String State;
    @WebService
    webService String Tax;
    @WebService
    webService Boolean TaxExempt;
    @WebService
    webService String TestMode;
    @WebService
    webService String Tokenization;
    @WebService
    webService String TransactionDescription;
    @WebService
    webService String TransactionId;
    @WebService
    webService Boolean UpdateToken;
    @WebService
    webService String versionOfApi;
    @WebService
    webService String Zip;
    global ChargentWebInput() {

    }
}
global class ChargentWebOutput {
    @WebService
    webService String ADDRRespCode;
    @WebService
    webService String AuthCode;
    @WebService
    webService String AVSRespCode;
    @WebService
    webService Boolean CalloutSent;
    @WebService
    webService String CustomerToken;
    @WebService
    webService String CVV2RespCode;
    @WebService
    webService String DebugString;
    webService String GatewayId {
        get;
        set;
    }
    @WebService
    webService String GatewayRecordTypeDevName;
    @WebService
    webService String GatewayResp;
    @WebService
    webService String IAVSRespCode;
    @WebService
    webService String Message;
    @WebService
    webService String ReasonCode;
    @WebService
    webService String ReasonText;
    @WebService
    webService String RespCode;
    @WebService
    webService String Status;
    @WebService
    webService String Tokenization;
    @WebService
    webService String TransId;
    @WebService
    webService String ZIPRespCode;
    global ChargentWebOutput() {

    }
}
}
