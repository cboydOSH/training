public class AccountOperations {
    public static Account setDefaultDescription(Account a) {
        a.Description = 'Default Description';
        return a;
    }
    public static Account setDefaultURL(Account a) {//DEV2
    	a.Website = 'www.copa.do';//DEV2
    	return a;
	}
}