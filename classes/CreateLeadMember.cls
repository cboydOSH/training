global without sharing class CreateLeadMember implements vlocity_ins.VlocityOpenInterface2{

    public static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    if(methodName == 'createLeadForMember') {
            return createLeadForMember(inputMap, outMap, options);                
        }
        return false;
    }
    
    public static Boolean createLeadForMember(Map<String, Object> input, Map<String, Object> outMap,Map<String, Object> options){
        
        Map<String, Object> mapLetsGetStarted = (Map<String,Object>)input.get('letsGetStarted');
        Map<String, Object> mapLeadCreation = (Map<String,Object>)mapLetsGetStarted.get('BlkNoExistingInfoPacket');
        Map<String, Object> mapLeadAddress = (Map<String,Object>)mapLeadCreation.get('TAAddressGoogle-Block');
        
        String leadFirstName = (String)mapLeadCreation.get('fName');
        String leadLastName = (String)mapLeadCreation.get('lName');
        String leadEmail = (String)mapLeadCreation.get('Email1');
        String leadPhone = (String)mapLeadCreation.get('Telephone1');
            
        String leadStreet = (String)mapLeadAddress.get('address');
        String leadBldSuiteApart = (String)mapLeadAddress.get('buildingSuiteApartment');
        String leadCity = (String)mapLeadAddress.get('City');
        String leadCountry = (String)mapLeadAddress.get('Country');
        String leadState = (String)mapLeadAddress.get('State');
        String leadGoogleAddress = (String)mapLeadAddress.get('TAAddressGoogle');
        String leadZipCode = (String)mapLeadAddress.get('zipCode');
        
        String ownerGuestUserId = [SELECT id FROM User WHERE Name = 'Owner Guest User' LIMIT 1].Id;
        
        Lead newLead = new Lead(
        	OwnerId = ownerGuestUserId,
        	LeadSource = 'Reserve',
       		FirstName = leadFirstName,
        	LastName = leadLastName,
        	Email = leadEmail,
        	Phone = leadPhone,
        	Street = leadStreet,
        	Building_Suite_Apartment__c = leadBldSuiteApart,
        	City = leadCity,
            Country = leadCountry,
            State = leadState,
            Google_Address__c = leadGoogleAddress,
            PostalCode = leadZipCode
        	);
        
        insert newLead;        
        System.debug('NEW LEAD => ' + newLead);
        

        outMap.put('DRId_Lead', newLead.id);
        
        return true;
    }
    
}