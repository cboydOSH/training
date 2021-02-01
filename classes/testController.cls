global without sharing class testController {
    /* Variables for Classic programs */
    public List<QuoteLineItem> qliListClassic {get;set;}
    public List<Map<String, String>> productsClassic {get;set;}
    /* Variables for Catastrophic programs */
    public List<QuoteLineItem> qliListCatastrophic {get;set;}
    public List<Map<String, String>> productsCatastrophic {get;set;}
    /* Variables for Complete programs STILL ON TESTING */
    public List<QuoteLineItem> qliListComplete {get;set;}
    public Map<String, Map<String, String>> productsComplete {get;set;}
    public Map<String, String> keysWithLabelCompletePrograms {get;set;}
    public Set<String> completePrograms {get;set;}
    public List<vlocity_ins__CompiledAttributeOverride__c> listForInOutCoverages {get;set;}
    /* General Variables */
    public Map<String,String> mapCodesWithLabels  {get;set;}
    public List<String> generalKeysOrder {get;set;}
    public List<String> completedKeysOrder {get;set;}
    public Boolean multiplePrograms {get;set;}
    public User user {get;set;}
    public Quote quote {get;set;}
    public Profile profile {get;set;}
    public Account ratingMemberAccount {get;set;}
    public Boolean debugFlag = true;
    public Set<String> prodIds {get;set;}
    public List<String> nonEligibleItemsProdNamesOrder {get;set;}
    public Map <String, List<String>> nonEligibleItems{get;set;}
    public Map <String, String> proDuctsIdsAndNames{get;set;}
    public Integer agedBrackets {get;set;}
    public Date createdQuoteDate {get;set;}
    
    public testController(ApexPages.StandardController testController) {
        String qId = testController.getId();
        init(qId);   
    }

    public testController(){
        String qId =  ApexPages.currentPage().getParameters().get('id');
        init(qId);
    }

    public void init(String qId){
        qliListClassic = new List<QuoteLineItem>();
        qliListComplete = new List<QuoteLineItem>();
        qliListCatastrophic = new List<QuoteLineItem>();

        productsClassic = new List<Map<String,String>>();
        productsCatastrophic = new List<Map<String,String>>();
        productsComplete = new Map<String, Map<String,String>>();

        completePrograms = new Set<String>();

        prodIds = new Set<String>();
        nonEligibleItemsProdNamesOrder = new List<String>();
        nonEligibleItems = new Map<String, List<String>>();
        proDuctsIdsAndNames = new Map<String, String>();
        Set<String> prodClassicIds = new Set<String>();
        Set<String> prodCatIds = new Set<String>();
        Set<String> prodCompleteIds = new Set<String>();

        mapCodesWithLabels = new Map<String,String>();
        generalKeysOrder = new List<String>();
        completedKeysOrder = new List<String>();
        loadGeneralListOfKeysAndLabels();
        loadCompletedListOfKeysAndLabels();

        //Get created date and created by
        quote = [SELECT Id, CreatedDate, CreatedById, Information_Packet_Number__c, Rating_Member__c, Price_Change__c FROM Quote WHERE id = :qId];
        user = [SELECT Id, Username, LastName, FirstName, ProfileId FROM User where Id = :quote.CreatedById];
        profile = [SELECT Name FROM Profile WHERE Id = :user.ProfileId];
        if(quote.Rating_Member__c!=null){
            ratingMemberAccount = [SELECT Name, PersonBirthdate, Age__c FROM Account where Id=:quote.Rating_Member__c];
        }
        
        // Logic for displaying rating member age brackets
        agedBrackets = 1;
        if(ratingMemberAccount!= null && quote.Price_Change__c){
            if(ratingMemberAccount.Age__c==29 || ratingMemberAccount.Age__c==39 || ratingMemberAccount.Age__c==49 || ratingMemberAccount.Age__c==59){
                createdQuoteDate = date.newinstance(quote.CreatedDate.year(), quote.CreatedDate.month(), quote.CreatedDate.day());
                Date oldMemberDate = date.newinstance(quote.CreatedDate.year(), ratingMemberAccount.PersonBirthdate.month(), ratingMemberAccount.PersonBirthdate.day());
                Integer daysBeetweenCreatedQuoteDateAndOldMemberDate = createdQuoteDate.daysBetween(oldMemberDate);
                if(daysBeetweenCreatedQuoteDateAndOldMemberDate<=30 && daysBeetweenCreatedQuoteDateAndOldMemberDate>=0){//is within 30 days
                    agedBrackets=2;
                }else if(daysBeetweenCreatedQuoteDateAndOldMemberDate>30){ //is more than 30 days, let's compare 6 months
                    createdQuoteDate = createdQuoteDate.addMonths(6);
                    daysBeetweenCreatedQuoteDateAndOldMemberDate = createdQuoteDate.daysBetween(oldMemberDate);
                    if(daysBeetweenCreatedQuoteDateAndOldMemberDate<0){
                        agedBrackets=3;
                    }
                }
            }
        }

        system.debug('agedBrackets: ' + agedBrackets);
        debug('Quote and user retreived');

        //ALL QLIS - Witth list of Product Ids per Product Type (Complete, Classic, Cat)
        Map<Id,QuoteLineItem> mapqlis = new Map<Id,QuoteLineItem>([SELECT Product2Id,vlocity_ins__ProductName__c, 
                                                                          vlocity_ins__RecordTypeName__c, 
                                                                          vlocity_ins__AttributeSelectedValues__c,
                                                                          vlocity_ins__TotalAmount__c
                                                                    From QuoteLineItem Where QuoteId = :qId 
                                                                    AND vlocity_ins__RecordTypeName__c = 'Product' ]);

        debug('Quote line items retreived');
       
        multiplePrograms = mapqlis.values().size() > 1 ? true : false;
        for(QuoteLineItem qli : mapqlis.values()){
            proDuctsIdsAndNames.put(qli.Product2Id, qli.vlocity_ins__ProductName__c);
            prodIds.add(qli.Product2Id);
            if(qli.vlocity_ins__ProductName__c.contains('Classic')){
                prodClassicIds.add(qli.Product2Id);
                qliListClassic.add(qli);
            }else if(qli.vlocity_ins__ProductName__c.contains('Catastrophic')){
                qliListCatastrophic.add(qli);
                prodCatIds.add(qli.Product2Id);
            }else if(qli.vlocity_ins__ProductName__c.contains('Complete')){
                qliListComplete.add(qli);
                prodCompleteIds.add(qli.Product2Id);
            }
        }

        //process non-eligible items
        loadNonEligibleItems(prodIds);
        orderNonEligibleItems();

        debug('Products populated');

        /*
        * Iterates over all the QLIs and then Extract Attribute Selected Values from JSON and creates clean list of Attributes
        */
        for (QuoteLineItem qli : mapqlis.values()) {
            if(qli.vlocity_ins__RecordTypeName__c == 'Product'){
                Map <String, Object> attributes = (map<String, Object>) JSON.deserializeUntyped(qli.vlocity_ins__AttributeSelectedValues__c);
                Map <String, String> cleanAttributes = new Map<String, String>();
                debug('Starting process for: ' + qli.vlocity_ins__ProductName__c);

                if(qli.vlocity_ins__ProductName__c.contains('Classic')){
                    processClassicAndCatastrophicProducts(qli, attributes, productsClassic, cleanAttributes);
                }else if(qli.vlocity_ins__ProductName__c.contains('Catastrophic')){
                    processClassicAndCatastrophicProducts(qli, attributes, productsCatastrophic, cleanAttributes);
                }else if(qli.vlocity_ins__ProductName__c.contains('Complete')){
                    for(String key : completedKeysOrder){ 
                        cleanAttributes.put(key,'Not eligible');
                        cleanAttributes.put(key+'2','Not eligible');
                    }
                    for (String attribute : attributes.keySet()) { // Populate attributes with QLI data
                        if(attribute=='ISAAMT'){
                            cleanAttributes.put(attribute, '$'+getMonetFormat(attributes.get(attribute)+''));
                        }else{
                            cleanAttributes.put(attribute, String.valueOf(attributes.get(attribute)).replace('*', ''));
                        }
                    }
                    // specific logic for in/out coverages start
                    debug('productID: ' + qli.Product2Id);
                    listForInOutCoverages = getInOutCoverages(qli.Product2Id); //retreive in/out coverages
                    debug('listForInOutCoverages: ' + listForInOutCoverages);
                    Map <String, Object> attributes1 = (map<String, Object>) JSON.deserializeUntyped(listForInOutCoverages.get(0).vlocity_ins__AttributeDefaultValues__c);
                    Map <String, Object> attributes2 = (map<String, Object>) JSON.deserializeUntyped(listForInOutCoverages.get(1).vlocity_ins__AttributeDefaultValues__c);
                    for(String key : attributes1.keySet()){ // Initialize keys needed for all as not eligible
                        cleanAttributes.put(key,'Not eligible');
                        cleanAttributes.put(key+'2','Not eligible');//adding them as key+2 because key is the same
                    }
                    System.debug('attributes1');
                    System.debug(attributes1);
                    System.debug('attributes2');
                    System.debug(attributes2);
                    for (String attribute : attributes1.keySet()) {
                        cleanAttributes.put(attribute, String.valueOf(attributes1.get(attribute)!=null?attributes1.get(attribute):'Not eligible'));
                    }
                    for (String attribute : attributes2.keySet()) {
                        cleanAttributes.put(attribute+'2', String.valueOf(attributes2.get(attribute)!=null?attributes2.get(attribute):'Not eligible'));
                    }
                    cleanAttributes.put('vlocity_ins__TotalAmount__c', '$'+getMonetFormat(qli.vlocity_ins__TotalAmount__c+''));
                    productsComplete.put(qli.vlocity_ins__ProductName__c, cleanAttributes);
                }
            }
            completePrograms = productsComplete.keySet(); //one completed the process, get all complete programs in order to display them in secuence 
            loadCompleteProgramsKeysForInAndOutCoverages();
        }
        debug('Process completed');
    }

    /**
    * Query to get in-out coverages for Complete programs
    */
    public List<vlocity_ins__CompiledAttributeOverride__c> getInOutCoverages(String programId){
    return [SELECT vlocity_ins__ProductId__c, vlocity_ins__ProductChildItemId__c, vlocity_ins__AttributeDefaultValues__c, 
    SystemModstamp, LastModifiedById, LastModifiedDate, Name, Id FROM vlocity_ins__CompiledAttributeOverride__c 
    where vlocity_ins__ProductId__c = :programId AND vlocity_ins__ProductChildItemId__c IN (Select Id From vlocity_ins__ProductChildItem__c 
    where vlocity_ins__ChildProductId__r.Name Like '%In Network%' OR vlocity_ins__ChildProductId__r.Name Like '%Out of Network%' ) ];
    }
    /**
     * Method that will receive quotelineitems, keys and products in order to fill product details to be displayed on the UI
     * This method works for Classic and Catastrophic programs as they only display attributes
     */
    public void processQuoteLineItems(List<QuoteLineItem> qliList, Set<String> keys, List<Map<String, String>> products){
        for (QuoteLineItem qli : qliList) {
            Map <String, Object> attributes = (map<String, Object>) JSON.deserializeUntyped(qli.vlocity_ins__AttributeSelectedValues__c);
            Map <String, String> cleanAttributes = new Map<String, String>();
            for(String key : keys){ // Initialize keys needed for all as not eligible
                cleanAttributes.put(key,'Not eligible');
            }
            for (String attribute : attributes.keySet()) { // Populate attributes with QLI data
                cleanAttributes.put(attribute, String.valueOf(attributes.get(attribute)));
            }
            products.add(cleanAttributes); //Add attributes to products
        }
    }

    /**
	 * Method to process classic and Catastrophic products
	 */
	public void processClassicAndCatastrophicProducts(QuoteLineItem qli, Map <String, Object> attributes, List<Map<String, String>> products, Map <String, String> cleanAttributes){
		for(String key : generalKeysOrder){ 
			cleanAttributes.put(key,'Not eligible');
		}
		for (String attribute : attributes.keySet()) {
			if(attribute=='ISAAMT'){
				cleanAttributes.put(attribute, '$'+getMonetFormat(attributes.get(attribute)+''));
			}else{
				cleanAttributes.put(attribute, String.valueOf(attributes.get(attribute)).replace('*', ''));
			}
		}
        cleanAttributes.put('vlocity_ins__TotalAmount__c', '$'+getMonetFormat(qli.vlocity_ins__TotalAmount__c+''));
        cleanAttributes.put('Provider-Network','In-Network/Out of Network²');
		products.add(cleanAttributes); 
    }
    
    /**
     * Method to process non-eligible items
     */
    public void loadNonEligibleItems(Set<String> prodIds){
        List<String> listSameNonEligibleItemsProdId = new List<String>();
        for (String attribute : proDuctsIdsAndNames.keySet()) {
			if(proDuctsIdsAndNames.get(attribute)=='OneShare Classic - Basic' || proDuctsIdsAndNames.get(attribute)=='OneShare Classic - Enhanced' ){
				listSameNonEligibleItemsProdId.add(attribute);
			}
        }
        
        List<Text_and_Disclosure__c> nonEligibleItemsList = [SELECT Text_Area__c, Product__c FROM Text_and_Disclosure__c where Active__c = true AND Place_is_Used__c = 'Q/Q' AND Product__c in : prodIds];
        Boolean continueFlagForSameClassic = true;
        Boolean continueFlagForClassicCrown = true;
        Boolean continueFlagForComplete = true;
        Boolean continueFlagForCatastrophic = true;
        for(Text_and_Disclosure__c textAndDisclosure : nonEligibleItemsList){
            List<String> textAndDisclosureList = textAndDisclosure.Text_Area__c.split('#');
            //System.debug(textAndDisclosureList);
            String part1 = '';
            String part2 = '';
            List<String> listToadd = new List<String>();
            for(Integer i = 0 ; i < textAndDisclosureList.size() ; i++){
                if(i<=22){
                    part1 = part1 + ('-' + textAndDisclosureList.get(i)) + '+';
                }else{
                    part2 = part2 + ('-' + textAndDisclosureList.get(i)) + '+';
                }
            }
            listToadd.add(part1);
            listToadd.add(part2);
            debug('Product name: ' + proDuctsIdsAndNames.get(textAndDisclosure.Product__c));
            debug('listSameNonEligibleItemsProdId size: ' + listSameNonEligibleItemsProdId.size());
            debug('continueFlagForSameClassic' + continueFlagForSameClassic + 'continueFlagForComplete ' + continueFlagForComplete );
            if(continueFlagForSameClassic && listSameNonEligibleItemsProdId.contains(textAndDisclosure.Product__c) && listSameNonEligibleItemsProdId.size() == 2){
                nonEligibleItems.put('OneShare Classic - Basic & OneShare Classic - Enhanced', listToadd);
                continueFlagForSameClassic = false;
            }else if(continueFlagForComplete && proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('OneShare Complete')){
                nonEligibleItems.put('OneShare Complete', listToadd);
                continueFlagForComplete = false;
            }else if(continueFlagForCatastrophic && proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('OneShare Catastrophic')){
                nonEligibleItems.put('OneShare Catastrophic', listToadd);
                continueFlagForCatastrophic = false;
            }else if(continueFlagForClassicCrown && proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('Classic - Crown')){
                nonEligibleItems.put(proDuctsIdsAndNames.get(textAndDisclosure.Product__c), listToadd);
                continueFlagForSameClassic = false;
            }else if(continueFlagForSameClassic && listSameNonEligibleItemsProdId.contains(textAndDisclosure.Product__c) && listSameNonEligibleItemsProdId.size() == 1){
                nonEligibleItems.put(proDuctsIdsAndNames.get(textAndDisclosure.Product__c), listToadd);
                continueFlagForSameClassic = false;
            }
        }
        System.debug(nonEligibleItems);
    }

    /**
     * Method to order non eligible items
     */
    public void orderNonEligibleItems(){
        List<String> s = new List<String>(nonEligibleItems.keySet());
        system.debug('ORIGINAL ORDER FOR PROGRAMS');
        system.debug(s);
        s.sort();
        system.debug('ORIGINAL ORDER FOR PROGRAMS ---SORTED ---');
        system.debug(s);

        for(Integer i = s.size() - 1; i >= 0; i--){
            nonEligibleItemsProdNamesOrder.add(s.get(i));
        }
        system.debug('ORDER FOR PROGRAMS');
        system.debug(nonEligibleItemsProdNamesOrder);
    }

    /**
     * Temporal method for displaying completed labels on PDF
     */
    public void loadCompleteProgramsKeysForInAndOutCoverages(){
        mapCodesWithLabels.put('Provider-Network','Provider Network- First Health®');
        mapCodesWithLabels.put('ISAAMT','ISA');
        mapCodesWithLabels.put('PREVSVCS','Preventive Services and wellness Visits');
        mapCodesWithLabels.put('PRICAREPHY','Primary Care Physician');
        mapCodesWithLabels.put('URGCAREFAC','Urgent Care Facility');
        mapCodesWithLabels.put('SPEC','Specialists');
        mapCodesWithLabels.put('EMERGROOM','Emergency Room');
        mapCodesWithLabels.put('DIAGXLAB','X-rays/Labs/Diagnostic');
        mapCodesWithLabels.put('HOSTP','Hospitalization');
        mapCodesWithLabels.put('INOUTSURG','In/Outpatient Surgery');
        mapCodesWithLabels.put('MATERNITY','Maternity');
        mapCodesWithLabels.put('MAXLIMITINC','Maximum Limit Per Incident');
        mapCodesWithLabels.put('LIFESHAREMAX','Lifetime Sharing Maximum');
        mapCodesWithLabels.put('PRESDISPROG','Prescription Discount Program');
        mapCodesWithLabels.put('TELEMED','Telemedicine³');
        mapCodesWithLabels.put('vlocity_ins__TotalAmount__c','Monthly contribution');
    }

    /**
     * Method for ordering and get needed keys for display on catastrophic and classic programs
     */
    public void loadGeneralListOfKeysAndLabels(){
        generalKeysOrder.add('Provider-Network');
        generalKeysOrder.add('ISAAMT');
        generalKeysOrder.add('PREVSVCS');
        generalKeysOrder.add('PRICAREPHY');
        generalKeysOrder.add('URGCAREFAC');
        generalKeysOrder.add('SPEC');
        generalKeysOrder.add('EMERGROOM');
        generalKeysOrder.add('DIAGXLAB');
        generalKeysOrder.add('HOSTP');
        generalKeysOrder.add('INOUTSURG');
        generalKeysOrder.add('MATERNITY');
        generalKeysOrder.add('MAXLIMITINC');
        generalKeysOrder.add('LIFESHAREMAX');
        generalKeysOrder.add('PRESDISPROG');
        generalKeysOrder.add('TELEMED');
        generalKeysOrder.add('vlocity_ins__TotalAmount__c');
    }

    /**
     * Method for ordering and get needed keys for display on completed programs
     */
    public void loadCompletedListOfKeysAndLabels(){
        completedKeysOrder.add('PREVSVCS');
        completedKeysOrder.add('PRICAREPHY');
        completedKeysOrder.add('URGCAREFAC');
        completedKeysOrder.add('SPEC');
        completedKeysOrder.add('EMERGROOM');
        completedKeysOrder.add('DIAGXLAB');
        completedKeysOrder.add('HOSTP');
        completedKeysOrder.add('INOUTSURG');
        completedKeysOrder.add('MATERNITY');
        completedKeysOrder.add('MAXLIMITINC');
        completedKeysOrder.add('LIFESHAREMAX');
        completedKeysOrder.add('PRESDISPROG');
        completedKeysOrder.add('TELEMED');
    }
    
    public String getMonetFormat(String money){
        Integer intIndex = money.indexOf('.');
        String cents='';
        if(intIndex > 0){
            cents = money.substring(intIndex, money.length());
            money = money.substring(0, intIndex);
        }
        String temp='';
        Integer originalLength = money.length();
        Integer i = money.length();
        do{
            if(money.length() > 3){
                String numbertemp = money.substring(i-3,i);
                money = money.substring(0,i-3);
                temp = ',' + numbertemp;
            }
            i=i-3;
        }while(i > money.length());

        if(originalLength-1 != i && i>0){
            money = money.substring(0,i) + temp;
        }
        if(intIndex > 0){
            money = money  + cents;
        }
        return money;
    }

    public void debug(String debugMessage){
        if(debugFlag){
            System.debug(debugMessage);
        }
    }
}