global without sharing class InformationPacketController {
    /* Variables for Route programs */
    public List<QuoteLineItem> qliListRoute{get;set;}
    public List<String> qliListRouteNames {get;set;}
    public Map<String, Map<String, String>> productsRoute {get;set;}
    public List<String> routeKeysOrder {get;set;}
    public Set<String> routePrograms {get;set;}
    /* Variables for Thrive programs */
    public List<QuoteLineItem> qliListThrive {get;set;}
    public List<String> qliListThriveNames {get;set;}
    public List<Map<String, String>> productsThrive {get;set;}
    /* Variables for Classic programs */
    public List<QuoteLineItem> qliListClassic {get;set;}
    public List<String> qliListClassicNames {get;set;}
    public List<Map<String, String>> productsClassic {get;set;}
    /* Variables for Catastrophic programs */
    public List<QuoteLineItem> qliListCatastrophic {get;set;}
    public List<Map<String, String>> productsCatastrophic {get;set;}
    public List<String> qliListCatastrophicNames {get;set;}
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
    public String profile {get;set;}
    public User writingAgent {get;set;}
    public Account accountForServicingAgent {get;set;}
    public String informationPacketNumber {get;set;}
    public Datetime quoteCreatedDate {get;set;}
    //public Account ratingMemberAccount {get;set;}
    public Boolean debugFlag = true;
    public Set<String> prodIds {get;set;}
    public List<String> nonEligibleItemsProdNamesOrder {get;set;}
    public Map <String, List<String>> nonEligibleItems{get;set;}
    public Map <String, String> proDuctsIdsAndNames{get;set;}
    //public Integer agedBrackets {get;set;}
    public Date createdQuoteDate {get;set;}
    
    public InformationPacketController(ApexPages.StandardController InformationPacketController) {
        String qId = InformationPacketController.getId();
        init(qId);   
    }

    public InformationPacketController(){
        String qId =  ApexPages.currentPage().getParameters().get('id');
        init(qId);
    }

    public void init(String qId){
        qliListClassic = new List<QuoteLineItem>();
        qliListComplete = new List<QuoteLineItem>();
        qliListCatastrophic = new List<QuoteLineItem>();
        qliListThrive = new List<QuoteLineItem>(); 
        qliListRoute = new List<QuoteLineItem>(); 

        qliListClassicNames = new List<String>();
        qliListCatastrophicNames = new List<String>();
        qliListThriveNames = new List<String>();
        qliListRouteNames = new List<String>(); 

        productsClassic = new List<Map<String,String>>();
        productsCatastrophic = new List<Map<String,String>>();
        productsComplete = new Map<String, Map<String,String>>();
        productsThrive = new List<Map<String,String>>();
        productsRoute = new Map<String, Map<String,String>>();

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
        routeKeysOrder = new List<String>();
        loadGeneralListOfKeysAndLabels();
        loadCompletedListOfKeysAndLabels();
        loadRouteListOfKeysAndLabels();

        //Get created date and created by
        quote = [SELECT Id, Servicing_Agent__c, Writing_agent__c, Agent_Label__c, CreatedDate, Information_Packet_Number__c, Rating_Member__c, Price_Change__c, CreatedById FROM Quote WHERE id=:qid];
        system.debug('QUOTE OBJ');
        system.debug(quote);
        informationPacketNumber = quote.Information_Packet_Number__c;
        quoteCreatedDate = quote.CreatedDate;
        //Get Agent label, servicing agent and writing agent
        Account accountForAgentLabel = [SELECT Id, Name  FROM Account WHERE Id =: quote.Agent_Label__c];
        system.debug('accountForAgentLabel');
        accountForServicingAgent = [SELECT Id, Name  FROM Account WHERE Id =: quote.Servicing_Agent__c];
        system.debug('accountForServicingAgent');
        writingAgent = [SELECT Name, LastName, Email, AccountId FROM User WHERE Id =: quote.Writing_agent__c];
        system.debug('writingAgent');
        system.debug('writingAgent: ' + quote.Writing_agent__c);
        system.debug('writingAgent.AccountId: ' + writingAgent.AccountId);
        Account writingAgentAccount;
        String accountIdValue = writingAgent.AccountId;
        if(accountIdValue!= '' && accountIdValue != null){
            system.debug('accountIdValue: ' + accountIdValue);
            writingAgentAccount = [Select Id, Name, Monthly_Commission_Fee__c, ParentId, RecordTypeId, Contract_Level__c From Account Where Id =:accountIdValue];
        }

        if(accountForAgentLabel != null && accountForAgentLabel.Name.equalsIgnoreCase('associate')){
            //it is a osh employee or a guest
            if(accountForServicingAgent.Id == [Select Id, Name, Monthly_Commission_Fee__c, ParentId From Account Where Name = 'Self-Service Enrollment'].get(0).Id){
                //if osh guest
                profile = 'Guest';
            }else{
                //else employee
                profile = 'OSH Employee';
            }
        }else{
            //it is a producer
            profile = 'Producer';
        }

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
            system.debug('PRODUCT NAME:  ' + qli.vlocity_ins__ProductName__c);
            prodIds.add(qli.Product2Id);
            if(qli.vlocity_ins__ProductName__c.contains('Classic')){
                prodClassicIds.add(qli.Product2Id);
                qliListClassic.add(qli);
                qliListClassicNames.add(qli.vlocity_ins__ProductName__c);
            }else if(qli.vlocity_ins__ProductName__c.contains('Catastrophic')){
                qliListCatastrophic.add(qli);
                prodCatIds.add(qli.Product2Id);
                qliListCatastrophicNames.add(qli.vlocity_ins__ProductName__c);
            }else if(qli.vlocity_ins__ProductName__c.contains('Complete')){
                qliListComplete.add(qli);
                prodCompleteIds.add(qli.Product2Id);
            }else if(qli.vlocity_ins__ProductName__c.contains('Thrive')){
                qliListThrive.add(qli);
                qliListThriveNames.add(qli.vlocity_ins__ProductName__c);
            }else if(qli.vlocity_ins__ProductName__c.contains('Route')){
                qliListRoute.add(qli);
                qliListRouteNames.add(qli.vlocity_ins__ProductName__c);
            }
        }

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
                System.debug(attributes);
                if(qli.vlocity_ins__ProductName__c.contains('Classic')){
                    processClassicAndCatastrophicProducts(qli, attributes, productsClassic, cleanAttributes);
                }else if(qli.vlocity_ins__ProductName__c.contains('Catastrophic')){
                    processClassicAndCatastrophicProducts(qli, attributes, productsCatastrophic, cleanAttributes);
                }else if(qli.vlocity_ins__ProductName__c.contains('Thrive')){
                    processClassicAndCatastrophicProducts(qli, attributes, productsThrive, cleanAttributes);
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
                    debug('productID: ' + qli.Product2Id);
                    listForInOutCoverages = getInOutCoverages(qli.Product2Id); //retreive in/out coverages
                    debug('listForInOutCoverages: ' + listForInOutCoverages);
                    Map <String, Object> attributes1 = (map<String, Object>) JSON.deserializeUntyped(listForInOutCoverages.get(0).vlocity_ins__AttributeDefaultValues__c);
                    Map <String, Object> attributes2 = (map<String, Object>) JSON.deserializeUntyped(listForInOutCoverages.get(1).vlocity_ins__AttributeDefaultValues__c);
                    for(String key : attributes1.keySet()){ // Initialize keys needed for all as not eligible
                        cleanAttributes.put(key,'Not eligible');
                        cleanAttributes.put(key+'2','Not eligible');//adding them as key+2 because key is the same
                    }
                    for (String attribute : attributes1.keySet()) {
                        cleanAttributes.put(attribute, String.valueOf(attributes1.get(attribute)!=null?attributes1.get(attribute):'Not eligible'));
                    }
                    for (String attribute : attributes2.keySet()) {
                        cleanAttributes.put(attribute+'2', String.valueOf(attributes2.get(attribute)!=null?attributes2.get(attribute):'Not eligible'));
                    }
                    cleanAttributes.put('vlocity_ins__TotalAmount__c', '$'+getMonetFormat(qli.vlocity_ins__TotalAmount__c+''));
                    productsComplete.put(qli.vlocity_ins__ProductName__c, cleanAttributes);
                }else if(qli.vlocity_ins__ProductName__c.contains('Route')){
                    for(String key : routeKeysOrder){ 
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
                    debug('productID: ' + qli.Product2Id);
                    listForInOutCoverages = getInOutCoverages(qli.Product2Id); //retreive in/out coverages
                    debug('listForInOutCoverages: ' + listForInOutCoverages);
                    Map <String, Object> attributes1 = (map<String, Object>) JSON.deserializeUntyped(listForInOutCoverages.get(0).vlocity_ins__AttributeDefaultValues__c);
                    Map <String, Object> attributes2 = (map<String, Object>) JSON.deserializeUntyped(listForInOutCoverages.get(1).vlocity_ins__AttributeDefaultValues__c);
                    for(String key : attributes1.keySet()){ // Initialize keys needed for all as not eligible
                        cleanAttributes.put(key,'Not eligible');
                        cleanAttributes.put(key+'2','Not eligible');//adding them as key+2 because key is the same
                    }
                    for (String attribute : attributes1.keySet()) {
                        cleanAttributes.put(attribute, String.valueOf(attributes1.get(attribute)!=null?attributes1.get(attribute):'Not eligible'));
                    }
                    for (String attribute : attributes2.keySet()) {
                        cleanAttributes.put(attribute+'2', String.valueOf(attributes2.get(attribute)!=null?attributes2.get(attribute):'Not eligible'));
                    }
                    cleanAttributes.put('vlocity_ins__TotalAmount__c', '$'+getMonetFormat(qli.vlocity_ins__TotalAmount__c+''));
                    productsRoute.put(qli.vlocity_ins__ProductName__c, cleanAttributes);
                }
            }
            routePrograms = productsRoute.keySet();
            completePrograms = productsComplete.keySet(); //once completed the process, get all complete programs in order to display them in secuence 
            loadCompleteProgramsKeysForInAndOutCoverages(); //this also works for route programs
        }
        debug('Process completed');
    }

    /**
    * Query to get in-out coverages for Complete programs
    */
    public List<vlocity_ins__CompiledAttributeOverride__c> getInOutCoverages(String programId){
        List<vlocity_ins__CompiledAttributeOverride__c> listToReturn =  new List<vlocity_ins__CompiledAttributeOverride__c>();

        listToReturn.add([SELECT vlocity_ins__ProductId__c, vlocity_ins__ProductChildItemId__c, vlocity_ins__AttributeDefaultValues__c, 
        SystemModstamp, LastModifiedById, LastModifiedDate, Name, Id FROM vlocity_ins__CompiledAttributeOverride__c 
        where vlocity_ins__ProductId__c = :programId AND vlocity_ins__ProductChildItemId__c IN (Select Id From vlocity_ins__ProductChildItem__c 
        where vlocity_ins__ChildProductId__r.Name Like '%In Network%')].get(0));

        listToReturn.add([SELECT vlocity_ins__ProductId__c, vlocity_ins__ProductChildItemId__c, vlocity_ins__AttributeDefaultValues__c, 
        SystemModstamp, LastModifiedById, LastModifiedDate, Name, Id FROM vlocity_ins__CompiledAttributeOverride__c 
        where vlocity_ins__ProductId__c = :programId AND vlocity_ins__ProductChildItemId__c IN (Select Id From vlocity_ins__ProductChildItem__c 
        where vlocity_ins__ChildProductId__r.Name Like '%Out of Network%')].get(0));

        //OR vlocity_ins__ChildProductId__r.Name Like '%Out of Network%'
        return listToReturn;
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
     * Method to process classic and Catastrophic products -> applicable also for thrive new products
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
            Integer limitForNonEligibleItems = 22;
            Integer extralimitForNonEligibleItems=0;
            if(proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('Route')){
                limitForNonEligibleItems = 16;
                extralimitForNonEligibleItems = limitForNonEligibleItems + 23;
            }
            List<String> textAndDisclosureList = textAndDisclosure.Text_Area__c.split('#');
            //System.debug(textAndDisclosureList);
            String part1 = '';
            String part2 = '';
            String part3 = '';
            List<String> listToadd = new List<String>();
            for(Integer i = 0 ; i < textAndDisclosureList.size() ; i++){
                if(i<=limitForNonEligibleItems){
                    part1 = part1 + ('-' + textAndDisclosureList.get(i)) + '+';
                }else if(extralimitForNonEligibleItems==0){
                    part2 = part2 + ('-' + textAndDisclosureList.get(i)) + '+';
                }else if(i>limitForNonEligibleItems && i<=extralimitForNonEligibleItems){
                    part2 = part2 + ('-' + textAndDisclosureList.get(i)) + '+';
                }else{
                    part3 = part3 + ('-' + textAndDisclosureList.get(i)) + '+';
                }
            }
            listToadd.add(part1);
            listToadd.add(part2);
            if(proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('Route')){
                listToadd.add(part3);
            }
           // debug('Product name: ' + proDuctsIdsAndNames.get(textAndDisclosure.Product__c));
           // debug('listSameNonEligibleItemsProdId size: ' + listSameNonEligibleItemsProdId.size());
            //debug('continueFlagForSameClassic' + continueFlagForSameClassic + 'continueFlagForComplete ' + continueFlagForComplete );
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
            }else if(proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('Thrive')){
                nonEligibleItems.put(proDuctsIdsAndNames.get(textAndDisclosure.Product__c), listToadd);
            }else if(proDuctsIdsAndNames.get(textAndDisclosure.Product__c).contains('Route')){
                nonEligibleItems.put(proDuctsIdsAndNames.get(textAndDisclosure.Product__c), listToadd);
            }
        }
        //System.debug(nonEligibleItems);
    }

    /**
     * Method to order non eligible items
     */
    public void orderNonEligibleItems(){
        List<String> s = new List<String>(nonEligibleItems.keySet());
       // system.debug('ORIGINAL ORDER FOR PROGRAMS');
       // system.debug(s);
        s.sort();
       // system.debug('ORIGINAL ORDER FOR PROGRAMS ---SORTED ---');
       // system.debug(s);

        for(Integer i = s.size() - 1; i >= 0; i--){
            nonEligibleItemsProdNamesOrder.add(s.get(i));
        }
       // system.debug('ORDER FOR PROGRAMS');
       // system.debug(nonEligibleItemsProdNamesOrder);
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

    /**
     * Method for ordering and get needed keys for display on Route programs
     */
    public void loadRouteListOfKeysAndLabels(){
        routeKeysOrder.add('PRICAREPHY');
        routeKeysOrder.add('SPEC');
        routeKeysOrder.add('URGCAREFAC');
        routeKeysOrder.add('DIAGXLAB');
        routeKeysOrder.add('EMERGROOM');
        routeKeysOrder.add('HOSTP');
        routeKeysOrder.add('INOUTSURG');
        //completedKeysOrder.add('TELEMED');
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