public class DocuSignReturnPageController {
    public String event{get;set;}
    public String recipientEmail{get;set;}
    public String recipientName{get;set;}
    public String contentVersion{get;set;}
    public String isEmbeded{get;set;}
    public String contractId{get;set;}

    public static String docuSignUrlResponse{get;set;}

    public void sendViaEmail(){
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
        
        ipInput.put('recipientEmail', recipientEmail);
        ipInput.put('recipientName', recipientName);
        ipInput.put('contentVersionId', contentVersion);
        ipInput.put('isEmbeded', false);
        ipInput.put('contractId', contractId);

        callIntegrationProcedure.invokeMethod('callIp', ipInput, ipOutput, ipOptions);
    }

    public PageReference signNow(){
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
        
        ipInput.put('recipientEmail', recipientEmail);
        ipInput.put('recipientName', recipientName);
        ipInput.put('contentVersionId', contentVersion);
        ipInput.put('isEmbeded', true);
        ipInput.put('contractId', contractId);

        callIntegrationProcedure.invokeMethod('callIp2', ipInput, ipOutput, ipOptions);
        pageReference pg = new pageReference('error');
        if(docuSignUrlResponse != null){
            pageReference pg2 = new pageReference(docuSignUrlResponse);
            pg = pg2;
        }
        return pg.setRedirect(true);
    }

    public static void setDocuSignUrlResponse(String docuSignUrl){
        docuSignUrlResponse = docuSignUrl;
    }
    
    public DocuSignReturnPageController() {
        this.event = Apexpages.currentpage().getparameters().get('event');
        this.recipientEmail = Apexpages.currentpage().getparameters().get('recipientEmail');
        this.recipientName = Apexpages.currentpage().getparameters().get('recipientName');
        this.contentVersion = Apexpages.currentpage().getparameters().get('contentVersion');
        this.isEmbeded = Apexpages.currentpage().getparameters().get('isEmbeded');
        this.contractId = Apexpages.currentpage().getparameters().get('contractId');
    }

    public DocuSignReturnPageController(String event, String recipientEmail, String recipientName, String contentVersion, String isEmbeded, String contractId, String docuSignUrlResponse) {
        this.event = event;
        this.recipientEmail = recipientEmail;
        this.recipientName = recipientName;
        this.contentVersion = contentVersion;
        this.isEmbeded = isEmbeded;
        this.contractId = contractId;
        setDocuSignUrlResponse(docuSignUrlResponse);
    }
}