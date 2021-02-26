global class DocuSignAuthorizationController implements Vlocity_ins.VlocityOpenInterface{
    
    private String METHOD_NAME_BODY = 'getBody';
    private String METHOD_NAME_INPUT = 'getInput';
    private String METHOD_NAME_ASSERTION = 'getAssertion';
    private String METHOD_NAME_CONVERT = 'convertToBase64Url';
    private String METHOD_NAME_SENDEMAIL = 'sendEmail';
    private String METHOD_NAME_CREATEENVELOPE = 'createEnvelope';
    //public getOAuthToken(){}//Default constructor initialization.
    
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        Boolean isSuccess = true;
        String processErrors = 'Ok';
        try {
            
            if(methodName.equalsIgnoreCase(METHOD_NAME_BODY)) {
                getBody( inputMap, outMap);
            }  
            else if(methodName.equalsIgnoreCase(METHOD_NAME_INPUT)) {
                getInput( inputMap, outMap);
            }  
            else if(methodName.equalsIgnoreCase(METHOD_NAME_ASSERTION)) {
                getAssertion( inputMap, outMap);
            }  
            else if(methodName.equalsIgnoreCase(METHOD_NAME_CONVERT)) {
                convertToBase64Url( inputMap, outMap);
            }  
            else if(methodName.equalsIgnoreCase(METHOD_NAME_SENDEMAIL)) {
                createEmailToSend( inputMap, outMap);
            }  
            else if(methodName.equalsIgnoreCase(METHOD_NAME_CREATEENVELOPE)) {
                createEnvelope( inputMap, outMap);
            }  
        } catch(Exception e) {
            
            isSuccess = false;
            processErrors = e.getMessage();
        }
        
        outMap.put('sucess', isSuccess);
        outMap.put('errors', processErrors);
        return isSuccess;
    }
    
    
    private void getOAuthToken(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        
        Map<String, Object> headerMap = new Map<String, Object>();
        headerMap.put('typ', 'JWT');
        headerMap.put('alg', 'RS256');
        String header = JSON.serialize(headerMap);
        header = EncodingUtil.base64Encode(Blob.valueOf(header));
        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.putAll(inputMap);
        bodyMap.put('scope', String.valueOf(inputMap.get('scope')));
        Datetime now = Datetime.now();
        Long nowInt = now.getTime()/1000;
        bodyMap.put('iat', nowInt);
        bodyMap.put('exp', nowInt + 3600);
        String body = JSON.serialize(bodyMap);
        body = EncodingUtil.base64Encode(Blob.valueOf(body));
        String input = header + '.' + body;
        input = EncodingUtil.base64Encode(Blob.valueOf(input));
        Blob inputBlob = EncodingUtil.base64Decode(input);
        String algorithmName = 'RSA-SHA256';
        String privateKey = String.ValueOf(inputMap.get('privateKey'));
        Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
        Blob signatureBlob = Crypto.sign(algorithmName,inputBlob,privateKeyBlob);
        String signature = EncodingUtil.base64Encode(signatureBlob);
        String assertion = header + '.' + body + '.' + signature;
        outputMap.put('assertion', assertion);
    }
    
    private void getBody(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        
        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.putAll(inputMap);
        bodyMap.put('scope', String.valueOf(inputMap.get('scope')));
        Datetime now = Datetime.now();
        Long nowInt = now.getTime()/1000;
        bodyMap.put('iat', nowInt);
        bodyMap.put('exp', nowInt + 3600);
        String body = JSON.serialize(bodyMap);
        body = EncodingUtil.base64Encode(Blob.valueOf(body));
        outputMap.put('body', body);
    }
    
    private void getInput(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        
        String body = String.valueOf(inputMap.get('body'));
        Map<String, Object> headerMap = new Map<String, Object>();
        headerMap.put('typ', 'JWT');
        headerMap.put('alg', 'RS256');
        String header = JSON.serialize(headerMap);
        header = EncodingUtil.base64Encode(Blob.valueOf(header));
        String input = header + '.' + body;
        outputMap.put('input', input);
        outputMap.put('header', header);
    }
    
    private void getAssertion(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        
        String header = String.valueOf(inputMap.get('header'));
        String body = String.valueOf(inputMap.get('body'));
        String input = String.valueOf(inputMap.get('input'));
        Blob inputBlob = Blob.valueOf(input);
        String algorithmName = 'RSA-SHA256';
        String privateKey = String.valueOf(inputMap.get('privateKey'));
        Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
        Blob signatureBlob = Crypto.sign(algorithmName, inputBlob, privateKeyBlob);
        String signature = EncodingUtil.base64Encode(signatureBlob);
        String assertion = header + '.' + body + '.' + signature;
        outputMap.put('assertion', assertion);
    }

    private void convertToBase64Url(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        
        String assertion = String.valueOf(inputMap.get('assertion'));
        String toReturn = '';
        toReturn = assertion.remove('=');
        toReturn = toReturn.replace('+', '-');
        toReturn = toReturn.replace('/', '_');
        outputMap.put('assertion', toReturn);
    }


    private void createEmailToSend(Map<String,Object> inputMap, Map<String,Object> outputMap) {
        
        String contentDocId = String.valueOf(inputMap.get('documentContentVersion'));
        String contractId = String.valueOf(inputMap.get('contractId'));
        ContentVersion cv=[select id,ContentDocumentId,versiondata from Contentversion where id =: contentDocId ];
        Blob csvFileBody =cv.VersionData;
        String csvAsString= EncodingUtil.base64Encode(csvFileBody);
        String emailBlurb = 'Please DocuSign this Contract <br> <br>This Contract will be voided by 10:00 PM, if this was an error please visit onesharehealth.com <br> <br> Thank you, One Share Health';

        String transactionBody ='{' +
                '"emailSubject": ' + '"'+ String.valueOf(inputMap.get('emailSubject')) + '"'  + ',' +
                '"emailBlurb": ' + '"'+ emailBlurb + '"'  + ',' +  
                '"status": "sent",' +
                '"documents": [{' +
                      '"documentBase64": ' + '"' + csvAsString + '",' +
                      '"documentId": "1",' + 
                      '"fileExtension": ' + '"'+ String.valueOf(inputMap.get('fileExtension')) + '"' + ',' +
                      '"name": ' + '"'+ String.valueOf(inputMap.get('fileName')) + '"' +
                    '}],'+
                '"recipients": {' +
                    '"signers": [{' +
                        '"email": ' + '"'+ String.valueOf(inputMap.get('signerEmail')) + '"' + ',' +
                        '"name": ' + '"'+ String.valueOf(inputMap.get('signerName')) + '"' + ',' +
                        '"recipientId": ' + '"' + String.valueOf(inputMap.get('recipientId')) + '"' + ',' +
                        '"roleName": ' + '"'+ String.valueOf(inputMap.get('signerRole')) + '"' +
                    '}]}}';


        outputMap.put('transactionBody', transactionBody);   
    }

    

   private void createEnvelope(Map<String,Object> inputMap, Map<String,Object> outputMap) {

        String contentDocId = String.valueOf(inputMap.get('documentContentVersion'));
        String contractId = String.valueOf(inputMap.get('contractId'));
        ContentVersion cv=[select id,ContentDocumentId,versiondata from Contentversion where id =: contentDocId ];
        Blob csvFileBody =cv.VersionData;
        String csvAsString= EncodingUtil.base64Encode(csvFileBody);
        String emailBlurb = 'Please DocuSign this Contract <br> <br>This Contract will be voided by 10:00 PM, if this was an error please visit onesharehealth.com <br> <br> Thank you, One Share Health';

        String transactionBody ='{' +
                '"emailSubject": ' + '"'+ String.valueOf(inputMap.get('emailSubject')) + '"'  + ',' + 
                '"emailBlurb": ' + '"'+ emailBlurb + '"'  + ',' + 
                '"status": "sent",'+
                '"contractId": "8008A000000WtzeQAC",'+
                '"documents": [{' +
                      '"documentBase64": ' + '"' + csvAsString + '",' +
                      '"documentId": "1",' + 
                      '"fileExtension": ' + '"'+ String.valueOf(inputMap.get('fileExtension')) + '"' + ',' +
                      '"name": ' + '"'+ String.valueOf(inputMap.get('fileName')) + '"' +
                    '}],'+
                '"recipients": {' +
                    '"signers": [{' +
                        '"email": ' + '"'+ String.valueOf(inputMap.get('signerEmail')) + '"' + ',' +
                        '"name": ' + '"'+ String.valueOf(inputMap.get('signerName')) + '"' + ',' +
                        '"recipientId":  ' + '"' + String.valueOf(inputMap.get('recipientId')) + '"' + ',' +
                        '"clientUserId": ' + '"' +String.valueOf(inputMap.get('clientUserId')) + '"' +
                    '}]}}';
                     outputMap.put('transactionBody', transactionBody);   

        String requestEmbededURL ='{' +
        '"userName": ' + '"'+ String.valueOf(inputMap.get('signerName')) + '"'  + ',' + 
        '"email": ' + '"'+ String.valueOf(inputMap.get('signerEmail')) + '"'  + ',' + 
        '"recipientId": ' + '"'+ String.valueOf(inputMap.get('recipientId')) + '"'  + ',' + 
        '"clientUserId": ' + '"'+ String.valueOf(inputMap.get('clientUserId')) + '"'  + ',' + 
        '"authenticationMethod": "email",' +      
        '"returnUrl": ' + '"'+ String.valueOf(inputMap.get('returnURL')) + '"' +  
        '}';
        outputMap.put('requestEmbededURL', requestEmbededURL);   
    }
}