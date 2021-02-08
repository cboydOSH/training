global without sharing class OSH_userMemberVerification implements vlocity_ins.VlocityOpenInterface2 {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options) {
        if(methodName == 'verifyUserAccount'){
            return verifyUserAccount(inputs, output, options);
        }
        return false;
    }
    public boolean verifyUserAccount(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
        try{
            String email = (String)options.get('Email');
            List<User> existingUser = [SELECT Id FROM User WHERE Email =:email];
            System.debug('existingUser' + existingUser);
            if(existingUser.isEmpty()){
                output.put('UserExist',false);
                return true; 
            }else {
                output.put('UserExist', true);              
                //output.put('error', sr.getErrors());
                return true;
            }
        }catch(Exception e){
            //system.debug('exception: ' + e);
            output.put('error', 'internal error 404: '+e);
            return false;
        }
    }
}