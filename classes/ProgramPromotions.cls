global without sharing class ProgramPromotions implements vlocity_ins.VlocityOpenInterface2 {
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
        Boolean result = false;
        if('format'.equalsIgnoreCase(methodName)) {
            result = format(input,outMap,options);
        }
        if('filter'.equalsIgnoreCase(methodName)) {
            result = filter(input,outMap,options);
        }
        return result;
    }

    public static Boolean format(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
        try{
            if((String)(input.get('promotionsCollection'))=='[]'){
                outMap.put('promotionsCollectionFormated', new List<Object>());
            }
            return true;
        }catch(Exception e){
            List<Object> listOfPromotions = (List<Object>) input.get('promotionsCollection');
            for(Object promotion : listOfPromotions){
                Map<String,Object> promotionMap = (Map<String,Object>)promotion;
                String programMetadata = (String)promotionMap.get('ProgramMetadata');
                if(programMetadata!=null){
                    List<Object> formateMetadata = (List<Object>)JSON.deserializeUntyped(programMetadata);
                    promotionMap.put('FormatedMetadata', formateMetadata);        
                    promotionMap.remove('ProgramMetadata'); 
                }
            }
            outMap.put('promotionsCollectionFormated', listOfPromotions);
            return true;
        }
    }

    public static Boolean filter(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
        List<Object> listOfPromotionsOut = new List<Object>();
        List<Object> listOfPromotions = null;
        try{
            listOfPromotions =(List<Object>) input.get('promotionsCollection');
        }catch(Exception e){
            outMap.put('promotionsCollectionFiltered', listOfPromotionsOut);
            return true;
        }         
        String selectedProductCode = (String) input.get('productCode');
        system.debug('selectedProductCode: ' + selectedProductCode);
        for(Object promotion : listOfPromotions){
            Boolean add = false;
            Map<String,Object> promotionMap = (Map<String,Object>)promotion;
            List<Object> formateMetadata = new List<Object>();
            if(promotionMap.get('FormatedMetadata')!=null){
                formateMetadata = (List<Object>)promotionMap.get('FormatedMetadata');
            }
            for(Object promotionMetadata: formateMetadata){
                Map<String,Object> promotionMetadataMap = (Map<String,Object>)promotionMetadata;
                if(promotionMetadataMap.get('code').equals(selectedProductCode)
                    && promotionMetadataMap.get('available').equals('applicable')){
                    system.debug('was true!: ' + promotionMetadataMap);
                    add = true;
                }
            }
            if(add){
                system.debug('was added!: ' + promotion);
                promotionMap.remove('FormatedMetadata'); 
                listOfPromotionsOut.add(promotion);
            }
        }
        outMap.put('promotionsCollectionFiltered', listOfPromotionsOut);
        return true;
    }
}