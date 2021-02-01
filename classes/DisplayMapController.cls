public with sharing class DisplayMapController {
    
    @AuraEnabled (cacheable=true)
    public static List<Account> getOfficeLocations(String accountNameInitial){
        String str = accountNameInitial + '%';
        return [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Name LIKE 'Brenda Grasso'];       
    }
}