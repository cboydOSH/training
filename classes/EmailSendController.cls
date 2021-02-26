public class EmailSendController {
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mBody, String mFirstName, String mLastName, String mPhone){
    system.debug('sendEmailMethod executed');
    system.debug('parameters');
    system.debug(mMail + ', ' + mSubject + ', ' + mBody+ ', ' + mFirstName + ', ' + mLastName + ', ' +mPhone);
    List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();       
        // Step 1: Create a new Email
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Step 2: Set list of people who should get the email
    List<String> sendTo = new List<String>();
    sendTo.add(mMail);
    mail.setToAddresses(sendTo);
        // Step 3: Set who the email is sent from
    mail.setReplyTo('vicente.martinez@arcsona.com'); 
    mail.setSenderDisplayName('OSH Contact US Support'); 
        // Step 4. Set email contents - you can use variables!
    mail.setSubject(mSubject);
    mail.setHtmlBody(mBody);
        // Step 5. Add your email to the master list
    mails.add(mail);
        // Step 6: Send all emails in the master list
    Messaging.sendEmail(mails);
   }   
}