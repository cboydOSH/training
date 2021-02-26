global without sharing class OSH_AccountCreation implements vlocity_ins.VlocityOpenInterface2 {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options) {
        if(methodName == 'createUserAccount'){
            return createUserAccount(inputs, output, options);
        }
        return false;
    }

    public boolean createUserAccount(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
        try{
            String quotEid =  (String)inputs.get('ContextId');
            Map<String,Object> accountMap = (Map<String,Object>)inputs.get('CreateAccount');
            System.debug('accountMap' + accountMap);
            User u = new User();
            u.lastname =  accountMap.get('LastName') + '' ; 
            u.firstname =  accountMap.get('FirstName') + '' ;
            u.Username = accountMap.get('ChooseUsername') + '';
            u.Email = accountMap.get('Email') + '';
            String randomToken = String.valueOf(Crypto.getRandomInteger() > 0 ? Crypto.getRandomInteger() : -(Crypto.getRandomInteger())).subString(0,4);
            
            List<User> existingUser = [SELECT Id From User Where UserName =:u.Username];
            System.debug('existingUser' + existingUser);
            if(!existingUser.isEmpty()){
                output.put('error','There is already an account associated with this email address. Please log in or, if you\'ve forgotten the password, use the Forgot Password? link in the Profile menu above.');
                return false;
                
            }

            String nickName = (u.lastname).substring(0,4) + randomToken;
            u.CommunityNickname  = nickName;
            String password = accountMap.get('Password') + '';
            String userId = null;

            try {
                if(!u.firstname.contains('Test')){
                    userId = Site.createPortalUser(u, '0018A00000Sq6IrQAJ', password);
                }else{
                    userId = '1';
                }
                System.debug('UserId' + userId);
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }

            if (userId != null) { 
                if (password.length() > 1) {
                    if(!u.firstname.contains('Test')){
                        Pagereference pageRef = Site.login(u.Username , password , '/s/');
                        output.put('redirectUrl',pageRef.getUrl() );
                    }
                    return true;
                }
            }
            output.put('error',
                        'Username should be unique and password should contains Alphanumeric'+ 
                        ' with atleast one uppercase and one special character. '+ '\n' + ' Your Password cannot equal or contain your user name.');
            return false;
        }
        catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            if(ex.getMessage().contains('User already exists') || ex.getMessage().contains('Duplicate Username')){
               output.put('error','There is already an account associated with this email address. Please log in or, if you\'ve forgotten the password, use the Forgot Password? link in the Profile menu above.');
            }else{
               output.put('error',String.join(errors,','));
            }
            System.debug('Ex--->'+ex.getMessage());
            return false;
        } 
        catch(Exception e){
            system.debug('Exception--->'+e + e.getLineNumber());
            output.put('error',e.getMessage());
            return false;
        }
    }

    // @future
    // public static void createPermissionSetAssignment(String userId){
    //     PermissionSet perm = [select id,Name from PermissionSet where name = 'Vlocity_Health_Insurance' LIMIT 1];
    //     PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = perm.id, AssigneeId = userId);
    //     insert psa;    
    //     PackageLicense pkg  = [SELECT Id, NamespacePrefix FROM PackageLicense where NameSpacePRefix = 'vlocity_ins' LIMIT 1];
    //     insert new UserPackageLicense(UserId = userId, PackageLicenseId=pkg.Id);
    // }

    // public boolean createUpdateQuote(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
    //     //Map<String,Object> planSelectionsMap = (Map<String,Object>)inputs.get('planSelection');
    //     Map<String,Object> planSelectionsMap = (Map<String,Object>)inputs.get('quoteJson');
    //     List<Object> selectedPlansList = (List<Object>)planSelectionsMap.get('selectedPlans');
    //     //List<Map<String,Object>> selectedPlans = (List<Map<String,Object>>)selectedPlansList;
    //     QuoteLineItem qli;
    //     List<QuoteLineItem> qliToInsertList = new List<QuoteLineItem>();
    //     Set<Id> productIdSet = new Set<Id>();
    //     Map<Id,Id> productPriceBookEntryMap = new Map<Id,Id>();
    //     for(Integer i=0; i<selectedPlansList.size(); i++){
    //         //selectedPlan = null;
    //         Map<String,Object> selectedPlan = (Map<String,Object>)selectedPlansList[i];
    //         productIdSet.add((Id)selectedPlan.get('productId'));
    //     }
    //     Map<Id,Product2> productMap = new Map<Id,Product2>([Select Id, vlocity_ins__AttributeDefaultValues__c 
    //                                                        From Product2 
    //                                                        Where id in : productIdSet]);
    //     for(PriceBookEntry pbe : [SELECT Id,Name,Pricebook2Id,Product2Id 
    //                               FROM PricebookEntry 
    //                               WHERE Product2Id IN : productIdSet AND PriceBook2.Name = 'Standard Price Book']){
    //         productPriceBookEntryMap.put(pbe.Product2Id, pbe.Id);
    //     }
    //     for(Integer i=0; i<selectedPlansList.size(); i++){
    //         //selectedPlan = null;
    //         qli = new QuoteLineItem();
    //         Map<String,Object> selectedPlan = (Map<String,Object>)selectedPlansList[i];
    //         qli.QuoteId = (Id)inputs.get('DRId_Quote');
    //         qli.UnitPrice = (Decimal)selectedPlan.get('Price');
    //         qli.PricebookEntryId = productPriceBookEntryMap.get((Id)selectedPlan.get('productId'));
    //         qli.product2Id = (Id)selectedPlan.get('productId');
    //         qli.vlocity_ins__AttributeSelectedValues__c = productMap.get((Id)selectedPlan.get('productId')).vlocity_ins__AttributeDefaultValues__c;
    //         qli.Quantity = 1;
    //         qliToInsertList.add(qli);
    //     }
    //     if(qliToInsertList.size() > 0){
    //         insert qliToInsertList;
    //         return true;
    //     }
    //     return false;
    // }
    
    // public  boolean createUserAccountExit(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
    //     String quotEid =  (String)inputs.get('ContextId');
    //     Map<String,Object> accountMap = (Map<String,Object>)inputs.get('CreateAccount');
    //     //Id adminUserId=Label.AdminUserId;
    //     Account ac = new Account();
    //     ac.Name = accountMap.get('FirstName') + ' ' + accountMap.get('LastName');
    //     ac.OwnerId =  UserInfo.getUserId();
    //     insert ac;
    //     ac.IsPartner = true; 
    //     update ac;
    //     User u = new User();
        
    //     u.lastname =  accountMap.get('LastName') + ' ' ; 
    //     u.firstname =  accountMap.get('FirstName') + ' ' ;
    //     u.Username = accountMap.get('ChooseUsername') + '';
    //     u.Email = accountMap.get('Email') + '';
    //     String randomToken = String.valueOf(Crypto.getRandomInteger() > 0 ? Crypto.getRandomInteger() : -(Crypto.getRandomInteger())).subString(0,4);
        
    //     String nickName = (u.lastname).substring(0,4) + randomToken;
    //     u.CommunityNickname  = nickName;
    //     String password = accountMap.get('Password') + '';
    //     String userId = Site.createExternalUser(u, ac.Id, password);
    //     String marketSegment = 'Medicare';
    //     if (userId != null) {
    //         createPermissionSetAssignment(userId);
    //         if(String.isNotBlank(quotEid)){
                
    //             Quote quote = [SELECT vlocity_ins__MarketSegment__c ,OpportunityId, Opportunity.AccountId From Quote where Id =:quotEid];
    //             marketSegment = quote.vlocity_ins__MarketSegment__c;
    //             AccountShare accountShare = new AccountShare();
    //             accountShare.AccountId = quote.Opportunity.AccountId;
    //             accountShare.UserOrGroupId = userId;
    //             accountShare.AccountAccessLevel = 'Edit';
    //             accountShare.CaseAccessLevel = 'Edit'; 
    //             accountShare.OpportunityAccessLevel = 'Edit';
    //             insert accountShare;
                
    //             //upsert new quote(Id= quotEid,OwnerId = userId);
    //         }
            
    //         Pagereference pageRef = Site.login(u.Username , password , '/s/detail/'+quotEid);
    //         output.put('redirectUrl',pageRef.getUrl() );
    //     }
    //     return true;
    // }
    
}