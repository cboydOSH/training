global with sharing class TemporaryPathGetQuoteDetails implements vlocity_ins.VlocityOpenInterface2{

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
       Boolean result = false;
       if('getQuoteDetails'.equalsIgnoreCase(methodName)) {
           return getQuoteDetails(input, outMap, options);
       }
       return result;
    }

    private Boolean getQuoteDetails(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
        String qId = (String)input.get('incomingQuoteId');

        Quote quote = [SELECT Information_Packet_Number__c, vlocity_ins__EffectiveDate__c, vlocity_ins__EndDate__c, vlocity_ins__Term__c, vlocity_ins__TotalSumInsured__c, 
                        vlocity_ins__TotalPremiumforTerm__c, AccountId, vlocity_ins__RootItemTotal__c, vlocity_ins__RatingType__c, vlocity_ins__GroupCensusId__c, 
                        vlocity_ins__TotalAmount__c, vlocity_ins__TotalTaxAmount__c, vlocity_ins__TotalFeeAmount__c, vlocity_ins__DaysRemaining__c, 
                        vlocity_ins__TotalAmountTermDifference__c, vlocity_ins__TotalFeeTermDifference__c, vlocity_ins__TotalPremiumTermDifference__c, 
                        vlocity_ins__TotalTaxTermDifference__c, vlocity_ins__Type__c, RecordTypeId,
                        vlocity_ins__RecordTypeName__c 
                        FROM Quote WHERE Id = :qId Limit 1];
        outMap.put('quoteDetail', quote);
        outMap.put('insuredItems', new Map<String,Object>());
        // Map<String,Object> quoteDetail = new Map<String,Object>();
        // quoteDetail.put(arg0, arg1);

        Map<Id,QuoteLineItem> mapqlis = new Map<Id,QuoteLineItem>([SELECT Product2.Id, Product2.ProductCode, Product2.Name, Product2.Description, 
                                                            Product2.vlocity_ins__Term__c, Product2.RecordTypeId, Product2.vlocity_ins__PricingFormula__c, 
                                                            Product2.vlocity_ins__PricingSource__c, vlocity_ins__CalculatedPriceJSON__c, Id, Product2Id, 
                                                            vlocity_ins__ItemName__c, vlocity_ins__ParentItemId2__c, vlocity_ins__ParentItemId__c, 
                                                            vlocity_ins__SubParentItemId__c, LineNumber, CreatedDate, vlocity_ins__AttributeSelectedValues__c, 
                                                            vlocity_ins__PrimaryChildLineItemId__c, vlocity_ins__RenewSourcePlanId__c, Future_Price__c, 
                                                            vlocity_ins__ImageId__c, QuoteId, UnitPrice, vlocity_ins__RecordTypeName__c, vlocity_ins__Type__c, 
                                                            TotalPrice, LastModifiedDate, vlocity_ins__PricingSource__c, vlocity_ins__ProductName__c, 
                                                            vlocity_ins__TaxAmount__c, vlocity_ins__FeeAmount__c, vlocity_ins__TotalAmount__c, 
                                                            vlocity_ins__ProductChildItemSequence__c, vlocity_ins__NeedReprice__c, vlocity_ins__JurisdictionId__c, 
                                                            vlocity_ins__RatingType__c, vlocity_ins__AttributeMetadataChanges__c, Product2.RecordType.DeveloperName, 
                                                            Quote.Name, vlocity_ins__LineNumber__c
                                                FROM QuoteLineItem 
                                                WHERE QuoteId = :qId  AND vlocity_ins__RecordTypeName__c = 'Product']);
        List<Object> listToReturn = new List<Object>();
        for(QuoteLineItem qli : mapqlis.values()){
            Map<String,Object> temporalProductMap = new Map<String,Object>();
            temporalProductMap.put('Name', qli.vlocity_ins__ProductName__c);
            temporalProductMap.put('quoteLineItemId', qli.Id);
            temporalProductMap.put('Id', qli.Id);
            temporalProductMap.put('LastModifiedDate', qli.LastModifiedDate);
            temporalProductMap.put('Product2Id', qli.Product2.Id);
            temporalProductMap.put('QuoteId', qli.QuoteId);
            temporalProductMap.put('TotalPrice', qli.TotalPrice);
            temporalProductMap.put('Price', qli.UnitPrice);
            temporalProductMap.put('UnitPrice', qli.UnitPrice);
            temporalProductMap.put('vlocity_ins__AttributeSelectedValues__c', qli.vlocity_ins__AttributeSelectedValues__c);
            temporalProductMap.put('vlocity_ins__CalculatedPriceJSON__c', qli.vlocity_ins__CalculatedPriceJSON__c);
            temporalProductMap.put('vlocity_ins__ItemName__c', qli.vlocity_ins__ItemName__c);
            temporalProductMap.put('LineNumber', qli.vlocity_ins__LineNumber__c);
            temporalProductMap.put('vlocity_ins__NeedReprice__c', qli.vlocity_ins__NeedReprice__c);
            temporalProductMap.put('vlocity_ins__ProductChildItemSequence__c', qli.vlocity_ins__ProductChildItemSequence__c);
            temporalProductMap.put('vlocity_ins__ProductName__c', qli.vlocity_ins__ProductName__c);
            temporalProductMap.put('lineRecordType', qli.vlocity_ins__RecordTypeName__c);
            temporalProductMap.put('vlocity_ins__TotalAmount__c', qli.vlocity_ins__TotalAmount__c);
            temporalProductMap.put('vlocity_ins__RecordTypeName__c', qli.vlocity_ins__RecordTypeName__c);
            temporalProductMap.put('recordType', qli.vlocity_ins__RecordTypeName__c);
            temporalProductMap.put('ProductCode', qli.Product2.ProductCode);
            temporalProductMap.put('productName', qli.vlocity_ins__ProductName__c);
            temporalProductMap.put('instanceKey', qli.vlocity_ins__ProductName__c);
            temporalProductMap.put('needReprice', qli.vlocity_ins__NeedReprice__c);
            temporalProductMap.put('productId', qli.Product2.Id);
            temporalProductMap.put('currencyCode', UserInfo.getDefaultCurrency());//need to check
            temporalProductMap.put('currencySymbol', '$');//need to check
            temporalProductMap.put('displaySequence', '0');//need to check

            Map<String,Object> attMetadataWithUserValues = mergeUserValuesMetadataForAttributes(
                                    (Map<String, Object>)JSON.deserializeUntyped(qli.vlocity_ins__AttributeSelectedValues__c), 
                                    (Map<String, Object>)JSON.deserializeUntyped(getProductInfo(qli.Product2Id).vlocity_ins__AttributeMetadata__c),
                                    null);
            temporalProductMap.put('attributeCategories', attMetadataWithUserValues);
            temporalProductMap.put('hasAttributes', attMetadataWithUserValues!=null);
            List<QuoteLineItem> quoteLineItemsOfProduct = [SELECT Product2.Id, Product2.ProductCode, Product2.Name, vlocity_ins__CalculatedPriceJSON__c, Id, Product2Id, 
                                                    vlocity_ins__ItemName__c, vlocity_ins__ParentItemId2__c, vlocity_ins__ParentItemId__c, 
                                                    vlocity_ins__SubParentItemId__c, QuoteId, LineNumber, CreatedDate, vlocity_ins__AttributeSelectedValues__c, 
                                                    UnitPrice, vlocity_ins__RecordTypeName__c, vlocity_ins__Type__c, 
                                                    TotalPrice, vlocity_ins__ProductName__c, LastModifiedDate,
                                                    vlocity_ins__TotalAmount__c, vlocity_ins__LineNumber__c,
                                                    vlocity_ins__ProductChildItemSequence__c, vlocity_ins__NeedReprice__c
                                                    FROM QuoteLineItem 
                                                    WHERE vlocity_ins__ParentItemId2__c = :qli.Id  AND vlocity_ins__RecordTypeName__c = 'CoverageSpec'];

            List<vlocity_ins__ProductChildItem__c> childProductsList = new List<vlocity_ins__ProductChildItem__c>
                ([SELECT Id, vlocity_ins__IsOptional__c, vlocity_ins__ParentProductId__c, vlocity_ins__ChildProductId__c, 
                vlocity_ins__ChildProductId__r.vlocity_ins__PricingSource__c, vlocity_ins__ChildProductId__r.vlocity_ins__PricingFormula__c, 
                vlocity_ins__ChildProductId__r.vlocity_ins__InstanceKeyFormula__c, vlocity_ins__childProductId__r.vlocity_ins__HasCustomAttributesProcess__c, 
                vlocity_ins__ChildLineNumber__c, vlocity_ins__MinQuantity__c, vlocity_ins__MaxQuantity__c, vlocity_ins__ChildRecordType__c 
                FROM vlocity_ins__ProductChildItem__c 
                WHERE vlocity_ins__ParentProductId__c =: qli.Product2Id]);

            Map<String,vlocity_ins__ProductChildItem__c> childProductsMap = new Map<String,vlocity_ins__ProductChildItem__c>();

            for(vlocity_ins__ProductChildItem__c childItem : childProductsList){
                childProductsMap.put(childItem.vlocity_ins__ChildProductId__c, childItem);
            }

            List<Object> listOfChildItems = new List<Object>();
            for(QuoteLineItem qliOfProduct : quoteLineItemsOfProduct){
                Map<String,Object> mapOfChildItems = new Map<String,Object>();

                vlocity_ins__ProductChildItem__c childProduct = childProductsMap.get(qliOfProduct.Product2Id);
                
                mapOfChildItems.put('pciId', childProduct.Id);
                //mapOfChildItems.put('isSelected', );
                mapOfChildItems.put('ProductCode', qliOfProduct.Product2.ProductCode);
                mapOfChildItems.put('Name', qliOfProduct.Product2.Name);
                mapOfChildItems.put('productName', qliOfProduct.Product2.Name);
                mapOfChildItems.put('isOptional', childProduct.vlocity_ins__IsOptional__c);
                mapOfChildItems.put('lineRecordType', qliOfProduct.vlocity_ins__RecordTypeName__c);
                mapOfChildItems.put('quoteLineItemId', qliOfProduct.Id);
                mapOfChildItems.put('vlocity_ins__NeedReprice__c', qliOfProduct.vlocity_ins__NeedReprice__c);
                mapOfChildItems.put('needReprice', qliOfProduct.vlocity_ins__NeedReprice__c);
                mapOfChildItems.put('vlocity_ins__ProductChildItemSequence__c', qliOfProduct.vlocity_ins__ProductChildItemSequence__c);
                mapOfChildItems.put('vlocity_ins__TotalAmount__c', qliOfProduct.vlocity_ins__TotalAmount__c);
                mapOfChildItems.put('vlocity_ins__ProductName__c', qliOfProduct.vlocity_ins__ProductName__c);
                mapOfChildItems.put('LastModifiedDate', qliOfProduct.LastModifiedDate);
                mapOfChildItems.put('TotalPrice', qliOfProduct.TotalPrice);
                mapOfChildItems.put('vlocity_ins__RecordTypeName__c', qliOfProduct.vlocity_ins__RecordTypeName__c);
                mapOfChildItems.put('UnitPrice', qliOfProduct.UnitPrice);
                mapOfChildItems.put('Price', qliOfProduct.UnitPrice); //need to check
                mapOfChildItems.put('QuoteId', qliOfProduct.QuoteId);
                mapOfChildItems.put('vlocity_ins__AttributeSelectedValues__c', qliOfProduct.vlocity_ins__AttributeSelectedValues__c);
                mapOfChildItems.put('CreatedDate', qliOfProduct.CreatedDate);
                mapOfChildItems.put('LineNumber', childProduct.vlocity_ins__ChildLineNumber__c);
                mapOfChildItems.put('vlocity_ins__SubParentItemId__c', qliOfProduct.vlocity_ins__SubParentItemId__c);
                mapOfChildItems.put('vlocity_ins__ParentItemId__c', qliOfProduct.vlocity_ins__ParentItemId__c);
                mapOfChildItems.put('vlocity_ins__ParentItemId2__c', qliOfProduct.vlocity_ins__ParentItemId2__c);
                mapOfChildItems.put('Product2Id', qliOfProduct.Product2Id);
                mapOfChildItems.put('productId', qliOfProduct.Product2Id);
                mapOfChildItems.put('Id', qliOfProduct.Id);
                mapOfChildItems.put('currencyCode', UserInfo.getDefaultCurrency());//need to check
                mapOfChildItems.put('currencySymbol', '$');
                mapOfChildItems.put('displaySequence', qliOfProduct.vlocity_ins__ProductChildItemSequence__c);

                Map<String,Object> rules = getRules(childProduct.Id);
 
                Map<String,Object> attMerged = new Map<String,Object>();
                if(qliOfProduct.vlocity_ins__AttributeSelectedValues__c!=null){
                    attMerged = mergeUserValuesMetadataForAttributes(
                                            (Map<String, Object>)JSON.deserializeUntyped(qliOfProduct.vlocity_ins__AttributeSelectedValues__c), 
                                            (Map<String, Object>)JSON.deserializeUntyped(getProductInfo(childProduct.vlocity_ins__ChildProductId__c).vlocity_ins__AttributeMetadata__c),
                                            rules);
                }else{
                    system.debug('was null?');
                    system.debug(qliOfProduct);
                    attMerged = (Map<String, Object>)JSON.deserializeUntyped(getProductInfo(childProduct.vlocity_ins__ChildProductId__c).vlocity_ins__AttributeMetadata__c);
                }
                mapOfChildItems.put('attributeCategories', attMerged);
                listOfChildItems.add(mapOfChildItems);

                
            }
            Map<String,Object> recordsVlocityStandardModel = new Map<String,Object>();
            recordsVlocityStandardModel.put('records', listOfChildItems);
            recordsVlocityStandardModel.put('actions', new List<Object>());
            recordsVlocityStandardModel.put('totalSize', listOfChildItems.size());
            temporalProductMap.put('coverageCount', listOfChildItems.size());
            temporalProductMap.put('hasCoverages', listOfChildItems.size()>0);
            temporalProductMap.put('childProducts', recordsVlocityStandardModel);
            listToReturn.add(temporalProductMap);
        }
        Map<String,Object> recordsVlocityStandardModel = new Map<String,Object>();
        recordsVlocityStandardModel.put('records', listToReturn);
        recordsVlocityStandardModel.put('totalSize', listToReturn.size());
        outMap.put('productConfigurationDetail', recordsVlocityStandardModel);
        return true;
   }

   public Map<String,Object> mergeUserValuesMetadataForAttributes(Map<String,Object> userSelectedValues, Map<String,Object> attributeMetadata, Map<String,Object> rules){
        system.debug('attributeMetadata '+ attributeMetadata);
        List<Object> records = (List<Object>)attributeMetadata.get('records');
        Map<String,Object> record = (Map<String,Object>)records.get(0);
        Map<String,Object> productAttributes = (Map<String,Object>)record.get('productAttributes');
        List<Object> recordsOfProductAttributes = (List<Object>)productAttributes.get('records');

        for(Object recordOfProductAttribute : recordsOfProductAttributes){
            Map<String,Object> mapOfRecord = (Map<String,Object>)recordOfProductAttribute;
            String code = (String)mapOfRecord.get('code');
            String value = (String)userSelectedValues.get(code);
            mapOfRecord.put('userValues', value);
            //rules mapping
            if(rules!= null && rules.get(code)!= null){
                mapOfRecord.put('rules', rules.get(code));
            }
        }

        system.debug('userSelectedValues '+ userSelectedValues);
        return attributeMetadata;
   }

   public List<vlocity_ins__ProductChildItem__c> getProductChildItems(String prodId){
        return [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                vlocity_ins__AllowIndependentLifeCycle__c, vlocity_ins__ChildLineNumber__c, vlocity_ins__ChildProductId__c, vlocity_ins__ChildRecordType__c, 
                vlocity_ins__CollapseHierarchy__c, vlocity_ins__CoverageCalculationFormula__c, vlocity_ins__DefaultSelectedCriteriaComments__c, 
                vlocity_ins__DefaultSelectedCriteria__c, vlocity_ins__EligibilityCriteriaComments__c, vlocity_ins__EligibilityCriteria__c, vlocity_ins__GlobalKey__c, 
                vlocity_ins__IsOptional__c, vlocity_ins__IsOverride__c, vlocity_ins__IsRootProductChildItem__c, vlocity_ins__IsVirtualItem__c, 
                vlocity_ins__MaxQuantity__c, vlocity_ins__MaximumChildItemQuantity__c, vlocity_ins__MinMaxDefaultQty__c, vlocity_ins__MinQuantity__c, 
                vlocity_ins__MinimumChildItemQuantity__c, vlocity_ins__ParentProductId__c, vlocity_ins__PricingFormula__c, vlocity_ins__PricingSource__c, 
                vlocity_ins__Quantity__c, vlocity_ins__RelationshipType__c, vlocity_ins__RequiredCriteriaComments__c, vlocity_ins__RequiredCriteria__c, 
                vlocity_ins__SelectValidationCriteria__c, vlocity_ins__SelectValidationMessage__c, vlocity_ins__SelectionMethodImplementation__c, 
                vlocity_ins__SeqNumber__c, vlocity_ins__SubParentSpecId__c, vlocity_ins__TotalCoverageCalculationFormula__c, vlocity_ins__ParentProductChildItemId__c, 
                vlocity_ins__ParentRecordType__c 
                FROM vlocity_ins__ProductChildItem__c
                WHERE vlocity_ins__ParentProductId__c =:prodId];
    }

    public Product2 getProductInfo(String prodId){
        return [SELECT Id, Name, ProductCode,  vlocity_ins__AttributeDefaultValues__c, vlocity_ins__AttributeMetadata__c, vlocity_ins__HasCustomAttributesProcess__c
                FROM Product2 
                WHERE Id =:prodId];
    }

    public Map<String,Object> getRules(String childProductId){
        List<vlocity_ins__CompiledAttributeOverride__c> compiledAtts = [SELECT Id, vlocity_ins__ProductChildItemId__c, vlocity_ins__ProductId__c, vlocity_ins__AttributeDefaultValues__c, vlocity_ins__AttributeMetadata__c, 
                                                                            vlocity_ins__JSONAttribute__c, vlocity_ins__AttributeRules__c, vlocity_ins__ProductChildItemId__r.vlocity_ins__ChildProductId__r.Name, 
                                                                            vlocity_ins__ProductChildItemId__r.vlocity_ins__ChildProductId__r.ProductCode, vlocity_ins__ProductChildItemId__r.vlocity_ins__ChildProductId__r.vlocity_ins__Type__c, 
                                                                            vlocity_ins__ProductChildItemId__r.vlocity_ins__ChildProductId__c 
                                                                            FROM vlocity_ins__CompiledAttributeOverride__c 
                                                                            WHERE vlocity_ins__ProductChildItemId__c =: childProductId];
        Map<String,Object> rules = new Map<String,Object>();
        for(vlocity_ins__CompiledAttributeOverride__c compiledChildAtt : compiledAtts){
            if(compiledChildAtt.vlocity_ins__AttributeRules__c!=null){
                Map<String,Object> compiledChildAttMap =  (Map<String, Object>)JSON.deserializeUntyped(compiledChildAtt.vlocity_ins__AttributeRules__c);
                for(String key : compiledChildAttMap.keySet()){
                    Map<String,Object> listAttributeRules = (Map<String,Object>)compiledChildAttMap.get(key);
                    system.debug('key: '+ key);
                    if(listAttributeRules.get('attributeRules')!=null){
                        rules.put(key, listAttributeRules.get('attributeRules'));
                    }else if(listAttributeRules.get('valueRules')!=null){
                        rules.put(key, listAttributeRules.get('valueRules'));
                    }
                }
            }
        }
        return rules;
    }

   public TemporaryPathGetQuoteDetails() {}
}