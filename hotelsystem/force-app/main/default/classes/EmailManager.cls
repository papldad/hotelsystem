public with sharing class EmailManager{
    public static void sendMail(String address, String subject, String body) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { address };
        message.subject = subject;
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        
        try{
        	Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        	if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }catch(System.EmailException er){
            System.debug('The email failed to send: Email out of limit');
        }
    }
}