global with sharing class CLMDocuSignSubmit implements vlocity_ins.VlocityOpenInterface2  {


    // I think it just saves typo bugs to def the argnames in one place.
    // Copy the string in a half dozen places and there will be errors.
    // put this in a private class keeps the namespace clear - not sure if
    // I like the all caps here that is sort of an old C convention from
    // preprocessor macros
    private Class ArgumentNames {
        final String CONTRACTID='ContractId';
        // final String DOCUMENTID= 'DocumentId';
        final String CONTRACTVERSIONID= 'ContractVersionId';
        final String RECIPIENTLIST= 'RecipientList';
        final String CONTENTVERSIONID= 'ContentVersionId';
        final String NAME='Name';
        final String EMAIL='Email';
        final String PHONE='Phone';
        final String SIGNER='Signer';
        final String DOCUSIGNENVELOPE='DocuSignEnvelope';
        final String DOCUSIGNSTATUS='DocuSignStatus';
    }
    
    private Static ArgumentNames argNames = new ArgumentNames();
    
    final Boolean notifyEvent = true;         // do we update the Dehq callout? // generally do it if async or for testing..
    Id parentId;
    Id contractId;
    // Id documentId;
    Id contractVersionId;
    Id brokerContactId;         // docusign Recipient needs Entity needs salesforce Id representing the signer...
    List<dfsle.Document> documentList;
    dfsle.Entity contractEntity;
    dfsle.Entity brokerContactEntity;
    List<dfsle.Recipient> recipientList;
    List<dfsle.Entity> recipientEntityList;
    dfsle.Envelope envelope;
    
    //contract details for custom email 
    String contractName;
    String contractDate;
    String contractTerm; 
    
    //apex constructors indicated by NO RETURN TYPE
    //the interface caller will instantiate (obvious since the interface method "invokeMethod" is not static )
    //so having any other constructors is odd and confusing
    global CLMDocuSignSubmit(){
    }
    
     global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        //try
        //{
            System.debug('CLMDocuSignSubmit.invokeMethod('+methodName+')');
            System.debug(input);
            if (methodName.equals('sendEnvelope'))
            {
                return sendEnvelope(input,output,options);
            }
            if (methodName.equals('createContentVersion'))
            {
                contractId = (Id)input.get(argNames.CONTRACTID);
                Id contentVersionId = createContentVersion(contractId);
                output.put(argNames.CONTENTVERSIONID,contentVersionId);
                output.put(argNames.DOCUSIGNSTATUS, 'SUCCESS'); return true;
            }
            if (methodName.equals('embeddedSignature2')) {
                return embeddedSignature2(input,output,options);
            }
            if (methodName.equals('embeddedSignatureAssignments')) {
                return embeddedSignatureAssignments(input,output,options);
            }
            if (methodName.equals('embeddedSignatureGetURL')) {
                 embeddedSignatureGetURL(input,output,options);
            }
      //  }
        //catch (Exception e) {
            //output.put(argNames.DOCUSIGNSTATUS, 'FAIL');
           // output.put('Error', e.getMessage());
           // output.put('ErrorLine', e.getLineNumber());
          //  output.put('Method', methodName);
          //  return false;
        //}
         return false;
    }
    
    public Boolean embeddedSignatureAssignments(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        String contractIDString = (String) options.get('contractId');
        Id mySourceId = (Id) contractIDString;
        String documentIdString = (String) options.get('documentId');
        Id documentId = (Id) documentIdString;

        List<dfsle.Document> myDocumentId = dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> {documentId});
      
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
            new dfsle.Entity(mySourceId)) // The initiating Salesforce entity.
            .withDocuments(myDocumentId )
            .withRecipients(new List<dfsle.Recipient> {
                dfsle.Recipient.newEmbeddedSigner() // An embedded signer
            });

        // Send the envelope.
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // Send now?
        
        updateContractStatus(mySourceId,  new ContractStatus().awaitingSignature);    

        output.put('DocuSignEnvelopeId', String.valueOf(myEnvelope.docuSignId));
      
        return true;
    }

    public static void embeddedSignatureGetURL(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        dfsle.UUID myEnvelopeId = dfsle.UUID.parse((String)input.get('DocuSignEnvelopeId'));
        
        Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
        myEnvelopeId, // DocuSign envelope ID
        new Url('https://www.onesharehealth.com/en/')); 
        // "Url:[delegate=https://na3.docusign.net/Signing/StartInSession.aspx?t=127f82da-5157-4aae-b372-4737de5390e4]"

        String urlString = String.valueOf(mySigningUrl);
        urlString = urlString.removeStart('Url:[delegate=');
        urlString = urlString.removeEnd(']');
        output.put('DocuSignURL', urlString);
    }
    
    // helper func to check parameters, return proper error in output, takes string parameter name
    // returns true if missing, so conditional can OR all of the expressions in guard like this
    // if ( missingRequiredParameter(PARAMETER_ONE) || ( missingRequiredParameter(PARAMETER_TWO)) { return false; }
    public static boolean missingRequiredParameter(Map<String,Object> input, Map<String,Object> output, String parameter){
        if(input.get(parameter)==null)
        {
            output.put('Error','required parameter '+ parameter +' not populated');
            output.put('input',input);
            System.debug('missingRequiredParameter: '+output);
            return true;
        }
        // now check for null?
        return false;        // nothing missing!
    }
    
    public Boolean sendEnvelope(Map<String,Object> input,Map<String,Object> output,Map<String,Object> options){
        output.put('executeEmbeddedSignatureRemoteActions', false);
        // guard for missing parameters and typos - they are so easy to get wrong in all the VIPs etc...
        // should do our best to be helpful here...
        if( missingRequiredParameter(input, output, argNames.RECIPIENTLIST))
        {
            output.put(argNames.DOCUSIGNSTATUS, 'FAIL');
            return false;
        }
    
        // need one of these three
        getRecipients( (List<Object>)input.get(argNames.RECIPIENTLIST) );
        Id contractId =(Id) input.get(argNames.CONTRACTID);
        Id contractVersionId =(Id) input.get(argNames.CONTRACTVERSIONID);
        Id contentVersionId = (Id) input.get(argNames.CONTENTVERSIONID);
        if((contractId == null)&&(contractVersionId==null)&&(contentVersionId==null))
        {
            output.put('Error','need one of ContractId, ContractVersionId, ContentVersionId');
            output.put(argNames.DOCUSIGNSTATUS, 'REQUESTERROR');
            return false;
        }
    
        if((contractId ==null)&&(contractVersionId !=null)) {
            contractId=contractFromContractVersion(contractVersionId);
        }
    
        this.contractId=contractId;
        this.contractVersionId=contractVersionId;
    
        getContractDetails();// query a few fields and store in object to construct subject in email
    
        contractEntity = new dfsle.Entity( contractId );
        brokerContactEntity = new dfsle.Entity(brokerContactId);
        if(contentVersionId!=null) {
            getContractDocumentsByContentVersion(contentVersionId);
    
        }
        else {
            getContractDocumentsByContract(contractId);
        }
    
        getEnvelopeAndSend();
    
        // the docusign api just returns so if no exception assume all is well
        // update contract status to awaiting signature.
        updateContractStatus(contractId,  new ContractStatus().awaitingSignature);
    
        output.put(argNames.DOCUSIGNSTATUS, 'SUCCESS');
        
        return true;
    }
    
    void updateContractStatus(Id contractId, String contractStatus){
        System.debug('CLMDocuSignSubmit.updateContractStatus '+contractId+' '+contractStatus);
        Contract c = [SELECT Id, Status, Name from Contract
                      WHERE Id =: contractId];
        System.debug('CLMDocuSignSubmit.updateContractStatus '+c);
        c.Status = contractStatus;
        System.debug('CLMDocuSignSubmit.updateContractStatus '+c);
        update c;
        c = [SELECT Id, Status, Name from Contract
             WHERE Id =: contractId];
        System.debug('CLMDocuSignSubmit.updateContractStatus '+c);
    }
    
    
    
    
    // vlocity contract status values
    // label and API name are same by default
    /*
       Draft
       Negotiating
       Legal Review
       Awaiting Approval
       Approved
       Awaiting Signature
       Signed
       Cancelled
       Expired
       Rejected Internally
       Signature Declined
       Terminated
       In Booking
       Booked
     */
    
    class ContractStatus {
    final String awaitingSignature = 'Awaiting Signature';
    final String signed = 'Signed';
    final String cancelled = 'Cancelled';
    final String expired = 'Expired';
    final String signatureDeclined = 'Signature Declined';
    final String inBooking = 'In Booking';
    final String booked = 'Booked';
    }
    
    
    // query contract from contractVersion
    public static Id contractFromContractVersion(Id contractVersionId)
    {
        System.debug(argNames.CONTRACTVERSIONID+' = '+contractVersionId);
        System.assertNotEquals(null,contractVersionId,argNames.CONTRACTVERSIONID+' required');
    
        // contract to contractversion
        vlocity_ins__ContractVersion__c cv =
        [ SELECT
          Id, vlocity_ins__VersionNumber__c, vlocity_ins__DocumentTemplateId__c, vlocity_ins__ContractId__r.Name
          FROM vlocity_ins__ContractVersion__c
          WHERE Id =:contractVersionId];
    
        System.debug('contractVersion = '+cv);
        System.assertNotEquals(null,cv,'contractVersion not found');
        return cv.vlocity_ins__ContractId__c;
    }
    
    // query contract->contractversion
    public static Id contractVersionFromContract(Id contractId)
    {
        System.debug(argNames.CONTRACTID+' = '+contractId);
        System.assertNotEquals(null,contractId,argNames.CONTRACTID+' required');
        System.assertNotEquals('',contractId,argNames.CONTRACTID+' required');
    
        // contract to contractversion
        List<vlocity_ins__ContractVersion__c> cvlist =
        [ SELECT
          Id, vlocity_ins__VersionNumber__c, vlocity_ins__DocumentTemplateId__c, vlocity_ins__ContractId__r.Name
          FROM vlocity_ins__ContractVersion__c
          WHERE vlocity_ins__ContractId__c  =: contractId
                                              ORDER BY vlocity_ins__VersionNumber__c DESC
        ];
    
        if(cvlist.size()>0)
        {
            vlocity_ins__ContractVersion__c cv = cvlist[0];
            System.debug('contractVersion = '+cv);
            System.assertNotEquals(null,cv,'contractVersion not found');
            return cv.Id;
        }
        else {
            MissingDataException e = new MissingDataException('No ContractVersion found for Contract');
            throw(e);
        }
    }
    
    public class MissingDataException extends Exception {}
    
    public static Id attachmentFromContractVersion(Id contractVersionId)
    {
        // contractversion to attachment
        Attachment at =
        [ SELECT
          Id, CreatedDate, Name, ParentId
          FROM Attachment
          WHERE ParentId =: contractVersionId
                           ORDER BY CreatedDate DESC
                           LIMIT 1 ];
    
        System.debug('attachment = '+at);
        System.assertNotEquals(null,at,'attachment not found');
    
        return at.Id;
    }
    
    public static Id contentDocumentFromContractVersion(Id contractVersionId)
    {
        System.debug('contentVersionFromContractVersion contractVersionId= '+contractVersionId);
    
        List<ContentDocumentLink>  cdlList =
        [ SELECT
          Id, ContentDocumentId, Visibility, ShareType
          FROM ContentDocumentLink
          WHERE LinkedEntityId =: contractVersionId
                                 LIMIT 1 ];
    
        if (cdlList.size() == 0) {
            return null;
        }
    
        ContentDocumentLink cdl = cdlList[0];
        System.debug('contentVersionFromContractVersion contentDocumentLink = '+cdl);
    
        Id contentDocumentId = cdl.ContentDocumentId;
        System.debug('contentDocumentId = '+ contentDocumentId);
        return contentDocumentId;
    }
    
    public static Id contentVersionFromContentDocument(Id contentDocumentId)
    {
        System.debug('contentVersionFromContentDocument contentDocumentId= '+contentDocumentId);
    
        ContentVersion cv =
        [ SELECT
          Id, Description, Title, ContentModifiedDate
          FROM ContentVersion
          WHERE ContentDocumentId =: contentDocumentId
                                    AND IsLatest = true ];
    
        System.debug('contentVersionFromContentDocument contentVersion = ' +cv);
        return cv.Id;
    }
    
    public static Id contentVersionFromContract(Id contractId){
        System.assertNotEquals(null, contractId,'contentVersionFromnContract: contractId required');
        System.debug('contentVersionFromContract contractId = '+contractId);
    
        Id contractVersionId = contractVersionFromContract(contractId);
        System.debug('contentVersionFromContract contractVersionId = '+contractVersionId);
    
        Id contentDocumentId = contentDocumentFromContractVersion(contractVersionId);
        Id contentVersionId = contentVersionFromContentDocument(contentDocumentId);
        return contentVersionId;
    }
    
    // convert and insert a duplicate content file (ContentVersion) from an attachment...
    public static ContentVersion createContentVersionFromAttachment(Id attachmentId){
        System.AssertNotEquals(null,attachmentId,'ContentVersionFromAttachment: attachmentId required');
        Attachment a = [select Body, Name, ContentType from Attachment where Id =:attachmentId];
        System.debug('attachment = '+a);
        System.assertNotEquals(null,a,'Attachment query returns null');
        ContentVersion cv = new ContentVersion();
    
        cv.VersionData = a.Body;
        cv.Title = a.Name;
        cv.PathOnClient = a.Name;
        //  'tempContentVersion';
        insert cv;
    
        System.debug('cv = '+cv);
        cv = [select Id, VersionData, ContentDocumentId from ContentVersion where Id =: cv.Id ];
        System.debug('cv = '+cv);
    
        return cv;
    }
    
    public static void linkContentDocumentToContractVersion(Id contentDocumentId, Id contractVersionId){
        System.AssertNotEquals(null,contentDocumentId,'linkContentDocumentToContract: contentDocumentId required');
        System.AssertNotEquals(null,contractVersionId,'linkContentDocumentToContract: contractVersionId required');
    
        // if there is an associated cd cv for the entity (contractversion) then just return
        if ( contentDocumentFromContractVersion(contractVersionId) != null)
            return;
    
        // check if its already linked.
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = contractVersionId;
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
    
    // find cv from contract, find attachment from contract version
    // copy attachment to contentVersion
    // find the contentVersion's contentDocument
    // create ContentDocumentLink linking ContentDocument to ContractVersion
    // check that contentVersion is linked from Contract
    public static Id createContentVersion(Id contractId){
        System.debug('CLMDocuSignSubmit.createContentVersion contractId = '+contractId);
    
        // get from contract to contractversion to attachment.
        Id contractVersionId = contractVersionFromContract(contractId);
        Id attachmentId = attachmentFromContractVersion(contractVersionId);
    
        /* BECAUSE THIS DOES AN INSERT ( DML ), IT CANNOT HAPPEN IN THE SAME TRANSACTION WITH A CALLOUT ( docusign envelope send)*/
        // duplicate the attachment to a contentversion
        // because this does DML (Insert) - we can't call the send envelope callout after in the same transaction so it has to be  separate transaction
        // so call this first from the VIP? Maybe that will fix it?
        ContentVersion cv = createContentVersionFromAttachment(attachmentId);
    
        linkContentDocumentToContractVersion(cv.ContentDocumentId, contractVersionId);
        Id contentVersionId = contentVersionFromContract(contractId);
        System.assertNotEquals(null, contentVersionId,'could not retrieve content version from contract');
        System.debug('CLMDocuSignSubmit.createContentVersion contractId/contentVersion = '+contractId+' / '+contentVersionId);
        return contentVersionId;
    }
    
    //helper type from id
    private Schema.SObjectType getType(Id theId){
        return theId.getSObjectType();
    }
    
    //use static helper funcs to query from contract to contractversion to contentVersion
    //then create the document list from dfsle document service and assign that to the object
    //member variable
    public void getContractDocumentsByContract(Id contractId){
        System.debug('CLMDocuSignSubmit.getContractDocuments contractId = '+contractId);
    
        // get from contract to contractversion to attachment.
    //  Id contractVersionId = contractVersionFromContract(contractId);
    //  Id attachmentId = attachmentFromContractVersion(contractVersionId);
    
        // contentVersion has to exist already or fail here
        Id contentVersionId = contentVersionFromContract(contractId);
        System.assertNotEquals(null, contentVersionId,'contentVersion not found from Contract');
        System.debug('CLMDocuSignSubmit.contractId/contentVersion = '+parentId+' / '+contentVersionId);
    
        getContractDocumentsByContentVersion(contentVersionId);
    }
    
    public void getContractDocumentsByContentVersion(Id contentVersionId)
    {
        // use the contentversion to build a list of documents with docusign package
        List<dfsle.Document> documents = dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> {contentVersionId});
        System.assertNotEquals(null,documents,'getDocuments returned null');
        this.documentList= documents;
    
        System.debug('CLMDocuSignSubmit.getContractDocuments this.documentList = '+this.documentList);
    }
    
    
    public void getRecipients(List<Object>recipientMapList){
        System.debug('recipientMapList = '+recipientMapList);
        System.debug('recipientMapList.size = '+recipientMapList.size());
        // recipientMapList
        //List<dfsle.Recipient> recipientList
        this.recipientList = new List<dfsle.Recipient>();
    
        Integer signerCount = 1;
        for(Object recipientObject : recipientMapList) {
            System.debug('recipient =  '+recipientObject);
            Map<String,Object> rmap = (Map<String,Object>)recipientObject;
    
            dfsle.Recipient r = dfsle.Recipient.fromSource(
                (String)rmap.get(argNames.NAME),
                (String)rmap.get(argNames.EMAIL),
                (String)rmap.get(argNames.PHONE),
                rmap.get(argNames.SIGNER)==true ? 'Signer '+signerCount++ : 'Needs to View',
                new dfsle.Entity(brokerContactId));
    
            System.debug('Recipient  = '+r);
            this.recipientList.add(r);
        }
    }
    
    public void getEnvelopeAndSend(){
        try{
            // Get an empty envelope definition to begin.
            this.envelope = dfsle.EnvelopeService.getEmptyEnvelope(contractEntity);
            // Add source documents and recipients
            this.envelope = this.envelope.withRecipients(this.recipientList).withDocuments(this.documentList);
    
            // vlocity DocuSignIntegrationService which polls docusign for envelope status updates
            // filters by custom field SalesforceOrgId so we need to include it here or this envelope wont be returned
            // this is the rest url it uses to query : 
            // https://eu.docusign.net/restapi/v2/accounts/505077422/envelopes?from_date=5/19/2020 3:45 GMT&custom_field=SalesforceOrgId=00D210000009hOjEAI
            // log the pre-sent envelope to see if it updates
            List<dfsle.CustomField> fieldlist = new List<dfsle.CustomField>();
            dfsle.CustomField sfOrg = new dfsle.CustomField('text','SalesforceOrgId',UserInfo.getOrganizationId(),null,true,false);
            fieldlist.add(sfOrg);
            this.envelope = this.envelope.withCustomFields(fieldlist);
    
            // set the custom email body and subject
            this.envelope = this.envelope.withEmail(
                            constructEmailSubject(), constructEmailBody());
    
            System.debug('CLMDocuSignSubmit.getEnvelopeAndSend: Envelope before send envelope = '+envelope);
            //Send envelope
            this.envelope = dfsle.EnvelopeService.sendEnvelope(envelope, true);
            System.debug('CLMDocuSignSubmit.getEnvelopeAndSend: Envelope after send envelope = '+envelope);
    
            dfsle.UUID dsi =envelope.docuSignId;
            System.debug('dsi = '+dsi);
    
            String sdsi = String.valueOf(dsi);
            // need to creat the locity_cmt__ContractEnvelope__c/
    
            //Stores information about DocuSign envelopes created during the DocuSign eSignature process.
    
            if(contractVersionId == null)
            {
                contractVersionId = contractVersionFromContract(contractId);
            }
    
            vlocity_ins__ContractEnvelope__c contractEnvelope = new vlocity_ins__ContractEnvelope__c();
            contractEnvelope.vlocity_ins__ContractId__c = contractId;
            contractEnvelope.vlocity_ins__ContractVersionId__c = contractVersionId;
            contractEnvelope.vlocity_ins__DocumentIdentifier__c = '1';
            contractEnvelope.vlocity_ins__DocumentName__c = documentList[0].name;
            // contractEnvelope.vlocity_ins__DocumentName = '';
            contractEnvelope.vlocity_ins__EnvelopeIdentifier__c = sdsi;
            contractEnvelope.vlocity_ins__EnvelopeUri__c ='/envelopes/'+sdsi;
            contractEnvelope.vlocity_ins__Status__c ='Sent';
            insert contractEnvelope;
    
            vlocity_ins__ContractRecipient__c contractRecipient = new vlocity_ins__ContractRecipient__c();
            contractRecipient.vlocity_ins__DeliveryMethod__c = 'Email';
            contractRecipient.vlocity_ins__EnvelopeId__c = contractEnvelope.Id;
            contractRecipient.vlocity_ins__HostEmail__c = recipientList[0].email;
            contractRecipient.vlocity_ins__RecipientFullName__c = recipientList[0].name;
            contractRecipient.vlocity_ins__RecipientId__c = 1;
            contractRecipient.vlocity_ins__RoutingOrder__c = 1;
            contractRecipient.vlocity_ins__Status__c  = 'Sent';
            contractRecipient.vlocity_ins__Type__c = 'Signer 1';// String.valueOf(recipientList[0].role);
            insert contractRecipient;
    
        }        // end try
        catch(Exception e)
        {
            System.debug('getEnvelopeAndSend() caught '+e.getMessage());
            throw e;
        }
    
    }
    
    
        /* this subject and body are duplicate to javascript found in the OC_SendForeSignatureComp */
        /* it should be refactored to be more DRY. Clearly it should be configurable in data not code also */
    // set member body subject and email by contract id query
    
        void getContractDetails()
        {
            Contract c = [SELECT Name, StartDate, ContractTerm from CONTRACT where Id=: contractId];
            this.contractName = c.Name;
            this.contractDate = String.valueOf(c.StartDate);
            this.contractTerm = String.valueOf(c.ContractTerm);
        }
    
        String constructEmailSubject(){
            return ('Contract for Signature - '  + contractName + ' - ' + contractDate + ' - ' + ' Term ' + contractTerm );
        }
    
        String constructEmailBody(){
            String emailBody = 'Hello,' +
                               '\n I am sending you this contract for your electronic signature, please review and electronically sign by following the link below.'+
                                '\n PLEASE NOTE - DUE TO CONSIDERABLE MARKET VOLATILITY, PRICING IS SUBJECT TO CHANGE AT TIME OF CUSTOMER ACCEPTANCE.  PLEASE ADHERE TO THE FOLLOWING DEADLINE TIMES FOR HEDGING PURPOSES:'+
                                '\n '+
                                '\n      * ELECTRIC FIXED,  BLOCK OR INDEX WITH CAPACITY CONTRACTS RETURNED BY 3:00 PM ON DATE OF ISSUE - 1:00 PM ON FRIDAYS' +
                                '\n      * NATURAL GAS FIXED PRICE CONTRACT RETURNED BY 3:00 PM ON DATE OF ISSUE'+
                                '\n      * NATURAL GAS (BASIS) NYMEX PLUS PRICE CONTRACT RETURNED BY 4:30 PM ON DATE OF ISSUE'+
                                '\n      * OIL CONTRACTS RETURNED BY 1:30 PM ON DATE OF ISSUE'+ 
                                '\n' +
                                '\n If received after the above deadlines, we will hold until market open the following business day to confirm if we can accept, or whether we need to update the price'; 
    
                                return emailBody;
        }

        public Boolean embeddedSignature2(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {

            Id mySourceId = '8008A000000WlYIQA0'; // The ID of the initiating Salesforce object.
            List<dfsle.Document> myDocumentId = dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> {'0688A000000nky1QAA'});
          
            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
                new dfsle.Entity(mySourceId)) // The initiating Salesforce entity.
                .withDocuments(myDocumentId )
                .withRecipients(new List<dfsle.Recipient> {
                    dfsle.Recipient.newEmbeddedSigner() // An embedded signer
                });

            // Send the envelope.
            myEnvelope = dfsle.EnvelopeService.sendEnvelope(
                myEnvelope, // The envelope to send
                true); // Send now?
                system.debug(dfsle.SigningService.shouldSignNow(myEnvelope));
                futureMethodT(String.valueOf(myEnvelope.docuSignId));
          
            return true;
        }

        @future(callout=true)
        public static void futureMethodT(String docuSignId){
            dfsle.UUID myEnvelopeId = dfsle.UUID.parse(docuSignId);
            
            Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
            myEnvelopeId, // DocuSign envelope ID
            new Url('https://onesharehealth.com')); 
            system.debug(mySigningUrl);
        }
            
    }// end class