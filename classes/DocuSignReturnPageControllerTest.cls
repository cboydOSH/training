@IsTest public with sharing class DocuSignReturnPageControllerTest {
    @IsTest public static void sendViaEmailTest() {
        
        String event = 'signing_complete';
        String recipientEmail = 'andres.deus@arcsona.com';
        String recipientName = 'Andres Deus';
        String contentVersion = '0688A0000011PrUQAU';
        String isEmbeded = 'false';
        String contractId = '8008A000000WzJ2QAK';

        String docuSignUrlResponse = 'https://demo.docusign.net/Signing/MTRedeem/v1/f5b9f383-2982-4502-885a-90a660cb856e?slt=eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQUAAAABAAMABwCAL03KXJHYSAgAgI0dfV2R2EgYAAEAAAAAAAAAIQCCAgAAeyJUb2tlbklkIjoiYzMyZjkwZDAtOGYyMy00MzZhLWFlNTctN2Q1MDgxZGRkZjAxIiwiRXhwaXJhdGlvbiI6IjIwMjAtMTEtMjVUMTY6MTY6MzkrMDA6MDAiLCJJc3N1ZWRBdCI6IjIwMjAtMTEtMjVUMTY6MTE6MzkuMzM0MjQxNiswMDowMCIsIlJlc291cmNlSWQiOiJjOWY2NGVhYS1kYzkzLTRkYzgtOTYyOC0yYzUxOGJmZTAxNjIiLCJSZXNvdXJjZXMiOiJ7XCJFbnZlbG9wZUlkXCI6XCJjOWY2NGVhYS1kYzkzLTRkYzgtOTYyOC0yYzUxOGJmZTAxNjJcIixcIkFjdG9yVXNlcklkXCI6XCJhNzk1MGFkNy1lNGFiLTRlNjQtOWI1MC1iY2YwYzFiMTMzMmZcIixcIlJlY2lwaWVudElkXCI6XCJjZDliZWIzMC0yMzExLTQ5MjEtOGIyOC03ZTM4MjQ4ZGU5MzBcIixcIkZha2VRdWVyeVN0cmluZ1wiOlwidD1mMmYyNTU1OS0wMzA1LTQyNmUtYjY5Ny00MGMzYmVlOTVjOWNcIn0iLCJUb2tlblR5cGUiOjEsIkF1ZGllbmNlIjoiMjVlMDkzOTgtMDM0NC00OTBjLThlNTMtM2FiMmNhNTYyN2JmIiwiUmVkaXJlY3RVcmkiOiJodHRwczovL2RlbW8uZG9jdXNpZ24ubmV0L1NpZ25pbmcvU3RhcnRJblNlc3Npb24uYXNweCIsIkhhc2hBbGdvcml0aG0iOjAsIkhhc2hSb3VuZHMiOjAsIlRva2VuU3RhdHVzIjowLCJJc1NpbmdsZVVzZSI6ZmFsc2V9.3MNfTgv1ifbtSh4SXgiZ0cxC-JXJGSiEfe3t9_8hMQkqibuHT6efyh5Gv3FgPLYGjZtSlMXSgOgxkQ1bSppodhyfcAuKfpCFNbIeTaiQJMPAjh9X-UIZtuCX81kusmu_CjaJvyqmJ8DbEPayHLvxGzywE2RYZ21Co64hPBSs9xflRRWC4nWITVBxnKL4_lZXWL5t1JLeOTE4QOLnL_JKxNTh_iRYrz10FjDfCnq0eVcuPOOdBCsktu3jnN1l93QivIjJUkX2OhxhmnXwSZh0A8tRXMiLih06yVQwqs8P3rEUY0q9PZrYJBU8Y-ppQN_78ZTAZCHqGnWf_kY9SQDInA';
        
        DocuSignReturnPageController controller = new DocuSignReturnPageController(event, recipientEmail, recipientName, contentVersion, isEmbeded, contractId, docuSignUrlResponse);
		controller.sendViaEmail();
        System.assertEquals(true,true);
    }

    @IsTest(SeeAllData=true)
    public static void signNowTest() {
        
        String event = 'signing_complete';
        String recipientEmail = 'andres.deus@arcsona.com';
        String recipientName = 'Andres Deus';
        String contentVersion = '0688A0000011PrUQAU';
        String isEmbeded = 'false';
        String contractId = '8008A000000WzJ2QAK';

        String docuSignUrlResponse = 'https://demo.docusign.net/Signing/MTRedeem/v1/f5b9f383-2982-4502-885a-90a660cb856e?slt=eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQUAAAABAAMABwCAL03KXJHYSAgAgI0dfV2R2EgYAAEAAAAAAAAAIQCCAgAAeyJUb2tlbklkIjoiYzMyZjkwZDAtOGYyMy00MzZhLWFlNTctN2Q1MDgxZGRkZjAxIiwiRXhwaXJhdGlvbiI6IjIwMjAtMTEtMjVUMTY6MTY6MzkrMDA6MDAiLCJJc3N1ZWRBdCI6IjIwMjAtMTEtMjVUMTY6MTE6MzkuMzM0MjQxNiswMDowMCIsIlJlc291cmNlSWQiOiJjOWY2NGVhYS1kYzkzLTRkYzgtOTYyOC0yYzUxOGJmZTAxNjIiLCJSZXNvdXJjZXMiOiJ7XCJFbnZlbG9wZUlkXCI6XCJjOWY2NGVhYS1kYzkzLTRkYzgtOTYyOC0yYzUxOGJmZTAxNjJcIixcIkFjdG9yVXNlcklkXCI6XCJhNzk1MGFkNy1lNGFiLTRlNjQtOWI1MC1iY2YwYzFiMTMzMmZcIixcIlJlY2lwaWVudElkXCI6XCJjZDliZWIzMC0yMzExLTQ5MjEtOGIyOC03ZTM4MjQ4ZGU5MzBcIixcIkZha2VRdWVyeVN0cmluZ1wiOlwidD1mMmYyNTU1OS0wMzA1LTQyNmUtYjY5Ny00MGMzYmVlOTVjOWNcIn0iLCJUb2tlblR5cGUiOjEsIkF1ZGllbmNlIjoiMjVlMDkzOTgtMDM0NC00OTBjLThlNTMtM2FiMmNhNTYyN2JmIiwiUmVkaXJlY3RVcmkiOiJodHRwczovL2RlbW8uZG9jdXNpZ24ubmV0L1NpZ25pbmcvU3RhcnRJblNlc3Npb24uYXNweCIsIkhhc2hBbGdvcml0aG0iOjAsIkhhc2hSb3VuZHMiOjAsIlRva2VuU3RhdHVzIjowLCJJc1NpbmdsZVVzZSI6ZmFsc2V9.3MNfTgv1ifbtSh4SXgiZ0cxC-JXJGSiEfe3t9_8hMQkqibuHT6efyh5Gv3FgPLYGjZtSlMXSgOgxkQ1bSppodhyfcAuKfpCFNbIeTaiQJMPAjh9X-UIZtuCX81kusmu_CjaJvyqmJ8DbEPayHLvxGzywE2RYZ21Co64hPBSs9xflRRWC4nWITVBxnKL4_lZXWL5t1JLeOTE4QOLnL_JKxNTh_iRYrz10FjDfCnq0eVcuPOOdBCsktu3jnN1l93QivIjJUkX2OhxhmnXwSZh0A8tRXMiLih06yVQwqs8P3rEUY0q9PZrYJBU8Y-ppQN_78ZTAZCHqGnWf_kY9SQDInA';
        
        DocuSignReturnPageController controller = new DocuSignReturnPageController(event, recipientEmail, recipientName, contentVersion, isEmbeded, contractId, docuSignUrlResponse);

        System.assertNotEquals(controller.signNow(),null);
    }

    @IsTest(SeeAllData=true)
    public static void setDocuSignUrlResponseTest() {
        String docuSignUrlResponse = 'testUrl';
        
        DocuSignReturnPageController controller = new DocuSignReturnPageController();
        DocuSignReturnPageController.setDocuSignUrlResponse(docuSignUrlResponse);

        System.assertEquals(DocuSignReturnPageController.docuSignUrlResponse,'testUrl');
    }

    @IsTest(SeeAllData=true)
    public static void DocuSignReturnPageControllerTest() {
        
        DocuSignReturnPageController controller = new DocuSignReturnPageController();

        System.assertNotEquals(controller,null);
    }

    @IsTest(SeeAllData=true)
    public static void DocuSignReturnPageControllerTest2() {
        
        String event = 'signing_complete';
        String recipientEmail = 'andres.deus@arcsona.com';
        String recipientName = 'Andres Deus';
        String contentVersion = '0688A0000011PrUQAU';
        String isEmbeded = 'false';
        String contractId = '8008A000000WzJ2QAK';

        String docuSignUrlResponse = 'testUrl';
        
        DocuSignReturnPageController controller = new DocuSignReturnPageController(event, recipientEmail, recipientName, contentVersion, isEmbeded, contractId, docuSignUrlResponse);

        System.assertNotEquals(controller,null);
        System.assertEquals(controller.event,'signing_complete');
        System.assertEquals(controller.recipientEmail,'andres.deus@arcsona.com');
        System.assertEquals(controller.recipientName,'Andres Deus');
        System.assertEquals(controller.contentVersion,'0688A0000011PrUQAU');
        System.assertEquals(controller.isEmbeded,'false');
        System.assertEquals(controller.contractId,'8008A000000WzJ2QAK');
        System.assertEquals(DocuSignReturnPageController.docuSignUrlResponse,'testUrl');
    }
}