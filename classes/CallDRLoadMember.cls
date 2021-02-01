global without sharing class CallDRLoadMember implements vlocity_ins.VlocityOpenInterface2{

    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        /*
        if(methodName == 'DR_UpdateQuoteWithInformationPacketNumber') {
                return DR_UpdateQuoteWithInformationPacketNumber(methodName, inputMap, outMap, options);                
        }
        if(methodName == 'DR_UpdateQuoteWithServicingWritingAgent') {
            return DR_UpdateQuoteWithServicingWritingAgent(methodName, inputMap, outMap, options);                
        }
        return false;
        */
        return DR_Update(methodName, inputMap, outMap, options);
    }

    public Boolean DR_Update(String DRName, Map<String, Object> drInput, Map<String, Object> drOutput,Map<String, Object> drOptions){

        
        String dataJson = JSON.serialize(drInput.get('Input'));

        System.debug(dataJson);

        vlocity_ins.DRProcessResult result = vlocity_ins.DRGlobal.processObjectsJSON(dataJson, DRName);

        Map<String, Object> resultMap = result.convertToMap();
        System.debug(JSON.serialize(resultMap));

        /*
        List<Map<String, Object>> resultMap = (List<Map<String, Object>>)result.toJsonList();
        Map<String, Object> resultMap = result.convertToMap();
        
        drOutput.put('result', resultMap);
        System.debug(JSON.serialize(resultMap));
        */  

        return true;

    }

    //VLOCITY DOCUMENTATION
    // String dataJson = '{"accountName":"Vlocity", "contractCode":"SKS9181"}';
    // vlocity_ins.DRProcessResult result = vlocity_ins.DRGlobal.processObjectsJSON(dataJson, 'Create Contracts');
    // Map<String, Object> resultMap = result.convertToMap();
    // System.debug(JSON.serialize(resultMap));
    // /* 
    // Process the results of the load: these methods return details about objects affected by the DataRaptor load, plus any errors that occured 
    // */
    // Map<String, Object> createdObjectsByType = (Map<String, Object>)resultMap.get('createdObjectsByType'); 
    // Map<String, Object> createdObjectsByTypeForBundle = (Map<String, Object>)createdObjectsByType.get('Create Contracts');
    // Map<String, Object> createdObjectsByOrder = (Map<String, Object>)resultMap.get('createdObjectsByOrder');
    // Map<String, Object> errors = (Map<String, Object>)resultMap.get('errors');
    // Map<String, Object> errorsByField = (Map<String, Object>)resultMap.get('errorsByField');
    // Map<String, Object> errorsAsJson = (Map<String, Object>)resultMap.get('errorsAsJson'); // Returns input JSON plus per-node errors
    
}