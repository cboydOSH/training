global without sharing class callIntegrationProcedure implements Vlocity_ins.VlocityOpenInterface{
    global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        if (methodName == 'callIp') {
            return callIp(methodName, inputMap, outputMap, options);
        }
        if (methodName == 'callIp2') {
            return callIp2(methodName, inputMap, outputMap, options);
        }
        return true;
    }

    global static Boolean callIp(String procedureName, Map <String, Object> ipInput, Map <String, Object> ipOutput, Map <String, Object> ipOptions) {
        ipOutput = (Map<String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService('DocuSign_DocuSign', ipInput, ipOptions);
        System.debug(ipOutput);
        return true;
    }

    global static Boolean callIp2(String procedureName, Map <String, Object> ipInput, Map <String, Object> ipOutput, Map <String, Object> ipOptions) {
        ipOutput = (Map<String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService('DocuSign_DocuSign', ipInput, ipOptions);
        String docuSignUrl = (String) ipOutput.get('DocuSignURL');
        DocuSignReturnPageController.setDocuSignUrlResponse(docuSignUrl);
        return true;
    }
}