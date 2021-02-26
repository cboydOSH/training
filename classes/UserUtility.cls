global without sharing class UserUtility implements vlocity_ins.VlocityOpenInterface2 {
	global Boolean invokeMethod(String methodName, Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options) {
        if (methodName == 'getUserId') {
            return getUserId(inputs, output, options);
        }
        else if (methodName == 'getUserEmail') {
            return getUserId(inputs, output, options);
        } else if (methodName == 'getUserIdAndEmail') {
            return getUserIdAndEmail(inputs, output, options);
        }
        return false;
    }

    public boolean getUserId(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
		Id userId = UserInfo.getUserId();
        output.put('userId',userId);
        return true;
    }

    public boolean getUserEmail(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
		String userEmail = UserInfo.getUserEmail();
        output.put('userEmail',userEmail);
        return true;
    }

    public boolean getUserIdAndEmail(Map < String, Object > inputs, Map < String, Object > output, Map < String, Object > options){
        this.getUserId(inputs, output, options);
        this.getUserEmail(inputs, output, options);
        return true;
	}
}