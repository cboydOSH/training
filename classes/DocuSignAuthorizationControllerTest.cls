/**
 * An apex class that handles the various processes to send an envelope via DocuSign
 */
@IsTest 
global class DocuSignAuthorizationControllerTest {

    @TestSetup
    public static void setup(){
        ContentVersion cv = new ContentVersion();
        cv.Title = 'OSH - Contract - Master v27.pdf';
        cv.PathOnClient = 'OSH - Contract - Master v27.pdf';
        cv.VersionData = Blob.valueOf('/services/data/v50.0/sobjects/ContentVersion/0688A00000125adQAA/VersionData');
        insert cv;
    }

    @IsTest
    static void getOAuthTokenTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('getOAuthToken', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @IsTest
    static void getBodyTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('getBody', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @IsTest
    static void getInputTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('getInput', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @IsTest
    static void getAssertionTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        inputMap.put('header','eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9');
        inputMap.put('body','eyJleHAiOjE2MDYzMzc5NDUsImlhdCI6MTYwNjMzNDM0NSwiaXNzIjoiMmJlOTIzNTgtMTgzMy00OWI4LWI5YjAtZjZmNWYwYzc5ZDU3Iiwic3ViIjoiZmU5ZDY3NzItZDFiMi00NGZmLWJiYjItNWY2OTkwOWQwMTUzIiwiYXVkIjoiYWNjb3VudC1kLmRvY3VzaWduLmNvbSIsInNjb3BlIjoic2lnbmF0dXJlIGltcGVyc29uYXRpb24ifQ');
        inputMap.put('input','eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDYzMzc5NDUsImlhdCI6MTYwNjMzNDM0NSwiaXNzIjoiMmJlOTIzNTgtMTgzMy00OWI4LWI5YjAtZjZmNWYwYzc5ZDU3Iiwic3ViIjoiZmU5ZDY3NzItZDFiMi00NGZmLWJiYjItNWY2OTkwOWQwMTUzIiwiYXVkIjoiYWNjb3VudC1kLmRvY3VzaWduLmNvbSIsInNjb3BlIjoic2lnbmF0dXJlIGltcGVyc29uYXRpb24ifQ');
        inputMap.put('privateKey','MIIEogIBAAKCAQEAma5F/PNRrykm5ue2/ZTO9W32XVcXVR8i5waS+1vqGSLcl7W9 UKgAiUwzlYKmnp2tsr65kZGB5XrW3Kgm0ieMU8geAJMFYNRqXg1Nud9mlXDoXxI0 eV1nY/ssYwN1YGNdx+dVxbevPHMtSwmiCC+UKucabFmPBntXyRengOhKfrf1Q4ER 61EdT6YvZFxhc4LjeRsdjbhGpjibVK8U5TXyhY4XIERPpb5kfxPUsXYHlZqYbM18 PuPQlauz7o1uKyIbLUe083C7VHwlcQE0KxBuVMHZfTR0jNl0uIBUUAczPkl8appT yld+C3PfnsXPMiCrBJ1wifGgaWknqN6IVrL9ZwIDAQABAoIBADwrjyyEKfG+V4Rl qfBsIIHYfXK7RB/oUnaIzOiMasJPs3XUytw3Awq+op3BqzIEQ3tuEGLtySGLsG9x iM2UfW1aN2D7L0pjsIfFhq6lSNlu/RQoIRJ5nx72u0DDHGRSU2gO67a/feVZpRyx l1bEJiuME3zjrcuYZF0QHV2r1Wr6SRzsdd1gqVXp9SZK3/YxZRc5WU4O7ZnF8RkO wPO7mDhl05zuS6PDdy+bfov3l+czl+FVdbFUptvN4eN6Bevtq/rSZq70ZeaCnicK MvH4a/u+v+k0KGECoMI8ZuD/nXUeWt2vh9IhW7eAu5Tl0GP1afS5KFr00GJEFPl4 WEIe8/UCgYEAz0tBZxmgmlKg9VCgT4UdVmJOoNg2cLZ+NinVEmmk2M1Y4UM4CTzj dgeLx253qd3rttCkdIoX5k4O9ZCWcOTV7kuog4eO3zOock0envDvttMSUWfyDXD4 tjP0op9tWsWBQ9qQYNaDwAwql68v5bYVYm5bhAXEQl/hL53N00a98e0CgYEAvcou Fxlbj94f0cWiy9al9/RZdY57BRrT16LncDpNkqiWtCW63RGfNLFmcDoguPesp9hR KqMb9QzWI2dUNCcMm+X7n4gs+gtr6MyDv5yimvsw4R8e616sLwXLLi52px/JLIPn MdrJ3JZmiYMdHrK5VHKwZXbNNmDsYM3hGHyRUiMCgYArjsmoa2cm5lPyGEYHT5ZR j4isHaKa3o34vaOLIe3ErKmPc/tzXXsCUyWY+2pjpEEiggb8ggPxnddg3EfwYvVd BELdmH96ATXVBsV3anNEfGet+WSQVHu+dX5jKZLl7vhxlJyf7JN0qFnO074By9gE feH3BOsvc0wzIDqeuY+yJQKBgAEeKbtVGOb2BfX0VgshToTxWX2Jw0u6ZrkEapyM m1xbxdd1yW335pom2VWb4gl02/15FrFLmKSO2MwIlcRg3oAkkKDV6n3mh1ItsjD0 uTh0dks9Ja95NUZpoFK7T1OYqlSqyjfO9BVqhVwV+5vsrY7Dxioy0u6ZD4taaxL7 2NdFAoGAd6qN5lwQZACmThYNyKRCn6XVfiVGuEdapTbuhMBwwdkoT8HZRRdBm5ND gkYAB3APN0M41ngMwMrDOAUwsKCsi/kyaOogz8eEGZHrW7hEn5qGFA0x0e9h+dL7 wuJFEt5FSwCUM/N6aNGF04xi0ZcX5DfnT59ag+OluXVOszgo6Q8=');

        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('getAssertion', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @IsTest
    static void convertToBase64UrlTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        inputMap.put('assertion','eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDYzMzc5NDUsImlhdCI6MTYwNjMzNDM0NSwiaXNzIjoiMmJlOTIzNTgtMTgzMy00OWI4LWI5YjAtZjZmNWYwYzc5ZDU3Iiwic3ViIjoiZmU5ZDY3NzItZDFiMi00NGZmLWJiYjItNWY2OTkwOWQwMTUzIiwiYXVkIjoiYWNjb3VudC1kLmRvY3VzaWduLmNvbSIsInNjb3BlIjoic2lnbmF0dXJlIGltcGVyc29uYXRpb24ifQ.KO3iFHcqNxpgx8wOvTDlaO4vlTUXT8BrpbRr6xzc9LTGBGbjxJqXiqIraPV2++gaAes5uuUqp/8OkAJTFxUoC8uRbSEQ1X8zOIxT5tsbzff7ne58Xjdkje6K+FK8Urvs5bCvXLaTDGk3pOoJkSvlWihotTDn2vPClBwoPEGOVfOkxZXFeRipGtV6xSaDvpv/XeXCIsx1O8kX1k+Lw0TSLCfpstmcm9d1/gRL7oIoiYxPdY0mQ0R52aDeeiJ7jsvfab0mKzHSXuEMRQXmqEEkeZLKysWxQJeZYMKQDbWQHqtv/9zPdDg4FVjWqIdFkHujlvBE75fhhGA49L3S9iH5OA==');

        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('convertToBase64Url', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
    
    @IsTest
    static void createEmailToSendTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ContentVersion cv = [SELECT Id FROM ContentVersion LIMIT 1];

        inputMap.put('documentContentVersion', cv.id);
        inputMap.put('contractId', '8008A000000X7j2QAC');
        inputMap.put('emailSubject','Example Subject');
        inputMap.put('fileExtension','PDF');
        inputMap.put('fileName','8008A000000X7j2QAC');
        inputMap.put('signerEmail','andres.deus@arcsona.com');
        inputMap.put('signerName','Andres Deus');
        inputMap.put('recipientId','1');
        inputMap.put('clientUserId','1234');
        inputMap.put('returnURL','https://devvl2-oshtraining.cs45.force.com/membercommunity/apex/DocuSignReturnPage?recipientEmail=andres.deus@arcsona.com&recipientName=Andres Deus&contentVersion=0688A00000125adQAA&isEmbeded=true&contractId=8008A000000X7j2QAC');


        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('sendEmail', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @IsTest
    static void createEnvelopeTest() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ContentVersion cv = [SELECT Id FROM ContentVersion LIMIT 1];

        inputMap.put('documentContentVersion', cv.id);
        inputMap.put('contractId', '8008A000000X7j2QAC');
        inputMap.put('emailSubject','Example Subject');
        inputMap.put('fileExtension','PDF');
        inputMap.put('fileName','8008A000000X7j2QAC');
        inputMap.put('signerEmail','andres.deus@arcsona.com');
        inputMap.put('signerName','Andres Deus');
        inputMap.put('recipientId','1');
        inputMap.put('clientUserId','1234');
        inputMap.put('returnURL','https://devvl2-oshtraining.cs45.force.com/membercommunity/apex/DocuSignReturnPage?recipientEmail=andres.deus@arcsona.com&recipientName=Andres Deus&contentVersion=0688A00000125adQAA&isEmbeded=true&contractId=8008A000000X7j2QAC');

        DocuSignAuthorizationController controller = new DocuSignAuthorizationController();
        Boolean ret = controller.invokeMethod('createEnvelope', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
}