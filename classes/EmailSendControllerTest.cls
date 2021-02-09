@IsTest global class EmailSendControllerTest {

    @IsTest global static void testSendMailMethod() {
        Test.StartTest();
        EmailSendController.sendMailMethod('jose.rossi@arcsona.com','EmailSendControllerTest','This is the Tests Body','Don','Heladio','2025550171');
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations, 'An email has not been sent');
    }
    
}