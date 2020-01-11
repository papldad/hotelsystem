public class EmailSendController {
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {mMail};
            mail.setToAddresses(toAddresses);
        mail.setSubject(mSubject);
        mail.setPlainTextBody(mbody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }   
}