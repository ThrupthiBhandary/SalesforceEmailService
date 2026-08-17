public with sharing class MyEmailService {
   
    public static void sendSimpleEmail(String toAddress, String subject, String body) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { toAddress });
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static void sendEmailWithAttachment(
        String toAddress,
        String subject,
        String body,
        String fileName
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { toAddress });
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
       
        try {
            ContentVersion fileRecord = [
                SELECT Id, Title, VersionData, PathOnClient
                FROM ContentVersion
                WHERE Title = :fileName
                AND IsLatest = true
                LIMIT 1
            ];
           
            Messaging.EmailFileAttachment attachment =
                new Messaging.EmailFileAttachment();

            attachment.setFileName(fileRecord.PathOnClient);
            attachment.setBody(fileRecord.VersionData);
           
            mail.setFileAttachments(
                new Messaging.EmailFileAttachment[] { attachment }
            );
           
        } catch (QueryException e) {
            System.debug(
                '>>> Warning: No file found with the name: '
                + fileName
            );
        }
       
        Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail }
        );
    }
}