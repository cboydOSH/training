global without sharing class OSH_AccountMemberCreation implements vlocity_ins.VlocityOpenInterface2 {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options) {
        if(methodName == 'createUserAccount'){
            return createUserAccount(inputs, output, options);
        }
        if(methodName == 'createUserAfterQuoteProcess'){
            return createUserAfterQuoteProcess(inputs, output, options);
        }
        return false;
    }

    public boolean createUserAccount(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
        try{
            //System.debug('createUserAccount');
            String portalUserOnSessionId = (String)inputs.get('userId');
            Map<String,Object> accountMap = (Map<String,Object>)inputs.get('Account');
            Map<String,Object> userMap = (Map<String,Object>)inputs.get('Welcome');
            String accountId = (String)accountMap.get('Id');
            String ownerId = (String)inputs.get('OwnerId');
            String randomToken = String.valueOf(Crypto.getRandomInteger() > 0 ? Crypto.getRandomInteger() : -(Crypto.getRandomInteger())).subString(0,4);
            //Get contact data for user fields
            Contact con = [Select id,name,email,lastname,firstname,accountid from contact where accountid=:accountId limit 1];
            //Verify if the member already has a user
            String email = (String)userMap.get('Email');
            List<User> existingUser = [SELECT Id From User Where UserName =:email];
            if(!existingUser.isEmpty()){
                output.put('error','There is already an account associated with this email address');
                system.debug(output.get('error'));
                return false;
            }
            //Get the account data in order to change the ownerId as a partner user cannot be the owner of a 
            Account userAccount = [SELECT Id, OwnerId FROM Account WHERE Id =: accountId];
            userAccount.OwnerId = ownerId;
            update userAccount;
            //Insert account share
            accountShare(accountId, portalUserOnSessionId);
            //Get the member corresponding profile
            Profile pf = [Select id,name from Profile where name ='Member Community Admin Test' limit 1];
            //System.debug('pf' + pf);
            //Create the user
            User u2 = new User(
                    contactId=con.Id, 
                    username='member'+'.'+email, 
                    firstname=con.FirstName,
                    lastname=con.LastName, 
                    email=email,
                    communityNickname = con.LastName + '_' + randomToken,
                    alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)),
                    profileid = pf.Id, 
                    emailencodingkey='UTF-8',
                    languagelocalekey='en_US', 
                    localesidkey='en_US', 
                    timezonesidkey='America/Chicago',
                    ManagerId = ownerId);
            //Set creation options to send an email after creation
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail= true;
            system.debug('before saving the user');
            system.debug('user: ' + u2);
            Database.saveresult sr = Database.insert(u2,dlo);
            if (sr.isSuccess()) {
                System.debug('Successfully inserted user. User ID: ' + sr.getId());
                output.put('UserId', sr.getId());
                system.debug('after saving the user');
                system.debug('user: ' + u2);
                return true;
            }else {              
                output.put('error', sr.getErrors());
                return false;
            }
        }catch(Exception e){
            system.debug('exception: ' + e);
            output.put('error', e);
            return false;
        }
    }

    /**
     * Testing method for member creation at the end of quote
     */
    public boolean createUserAfterQuoteProcess(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
        try{
            //Get user owner
            User userOwner = [SELECT Id, name from user WHERE name ='Owner Guest User' limit 1];
            //Get quoteId
            String quoteId = (String)inputs.get('QuoteIdDecrypted');
            //Get leadId
            String leadId = (String)inputs.get('DRId_Lead');
            //Get Quote Object Information
            Quote quoteObj = [SELECT Id, OpportunityId FROM Quote WHERE Id =: quoteId];
            //Declare opportunityId
            String opportunityId = quoteObj.OpportunityId;
            //Get the password
            Map<String, Object> mapReviewQuote = (Map<String,Object>)options.get('UserDosentExist');
            Map<String, Object> mapUserCreation = (Map<String,Object>)mapReviewQuote.get('UserCreationBlock');
            //system.debug('mapUserCreation: ' + mapUserCreation);
            String password = (String)mapUserCreation.get('UserPassword');
            //Get account details
            List<Object> listAccountPrimary = (List<Object>)inputs.get('Account_1');
            Map<String, Object> mapAccountInfo = (Map<String,Object>)listAccountPrimary.get(0);
            //system.debug('mapAccountInfo: ' + mapAccountInfo);
            //Get account email
            String email = (String)mapAccountInfo.get('PersonEmail');
            //Get account Id
            String accountId = (String)mapAccountInfo.get('Id');
            //Generate random token for comunity nickname
            String randomToken = String.valueOf(Crypto.getRandomInteger() > 0 ? Crypto.getRandomInteger() : -(Crypto.getRandomInteger())).subString(0,4);
            //Get Contact for information
            Contact con = [Select id,name,email,lastname,firstname,OwnerId from contact where accountid=:accountId limit 1];
            con.OwnerId = userOwner.Id;
            Database.SaveResult SR = Database.update(con);
            if (sr.isSuccess()) {
                //Validate if there is an existing user with specified email
                List<User> existingUser = [SELECT Id From User Where UserName =:email];
                if(!existingUser.isEmpty()){
                    output.put('error','There is already an account associated with this email address');
                    return false;
                }
                //Get the profile id
                Profile pf = [Select Id, Name from Profile where name ='Member Community Admin Test' limit 1];
                //Get the account owner
                //Account ownerAccount = [Select Id, Name from Account where name ='Master Account Member Portal' limit 1];
                //Create the user object for creation
                User u2 = new User(
                        contactId=con.Id, 
                        username='member'+'.'+con.email, 
                        firstname=con.FirstName,
                        lastname=con.LastName, 
                        email=con.email,
                        communityNickname = con.LastName + '_' + randomToken,
                        alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)),
                        profileid = pf.Id,
                        emailencodingkey='UTF-8',
                        languagelocalekey='en_US', 
                        localesidkey='en_US', 
                        timezonesidkey='America/Chicago',
                        USERPERMISSIONSSFCONTENTUSER = true);
                //system.debug('User: ' + u2);
                //Compare if the execution is for testing purposes
                String userId; 
                if(Test.isRunningTest()){
                    userId=UserInfo.getUserID();
                }else{
                    //Create the user
                    userId=Site.createExternalUser(u2, accountid, password);
                }
                //Compare if the userId generated was null
                if(userId!=null){
                    //Insert account share
                    accountShare(accountId, userId);
                    //Insert opportunity sharing
                    shareQuoteQliAndPrograms(quoteId, opportunityId, userId);
                    //Insert lead sharing
                    shareLead(leadId, userId);
                    //If succesfull then redirect for direct enrolling
                    if(!Test.isRunningTest()){
                        Pagereference pageRef = Site.login(u2.Username , password , '/s/enroll-now?ContextId='+quoteId+'&Thisisdirect=true&thisIsCommunity=true');
                        output.put('redirectUrl',pageRef.getUrl());
                    }
                    return true;
                }else{
                    output.put('error', 'error, the userId was null');
                    return false;
                }
            }else{
                output.put('error', 'Error updating the contact');
                return false;
            }
        }catch(Exception e){
            output.put('error', e);
            return false;
        }
    }

    private void accountShare(String accountId, String portalUserOnSessionId){
        //Account share object in order to share the account with the partner user
        //https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_accountshare.htm
        AccountShare accountShare = new AccountShare();
        accountShare.AccountId = accountId; // Account to share
        accountShare.UserOrGroupId = portalUserOnSessionId; // Sharing with the user running the process
        //accountShare.RowCause = 'PortalImplicit'; // The Account is associated with the portal user.
        accountShare.OpportunityAccessLevel = 'Edit'; // Sharing opportunity
        accountShare.AccountAccessLevel = 'Edit';// Sharing account
        accountShare.CaseAccessLevel = 'Edit';// Sharing cases
        insert accountShare;// Insert account share
    }

    private void shareQuoteQliAndPrograms(String quoteId, String opportunityId, String userId){
        OpportunityShare shareOpportunity = new OpportunityShare();
        shareOpportunity.OpportunityId = opportunityId;
        shareOpportunity.UserOrGroupId = userId;
        shareOpportunity.OpportunityAccessLevel = 'Edit';
        insert shareOpportunity;
    }

    private void shareLead(String leadId, String userId){
        LeadShare leadShare = new LeadShare();
        leadShare.LeadId = leadId;
        leadShare.UserOrGroupId = userId;
        leadShare.LeadAccessLevel = 'Edit';
        insert leadShare;
    }
}