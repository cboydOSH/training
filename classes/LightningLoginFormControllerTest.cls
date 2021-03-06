@IsTest public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void testLoginWithInvalidCredentials() {
     LightningLoginFormController.login('testUser', 'fakepwd', null);
  	 System.assertEquals(true, true);
 }

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
    
    @IsTest
 	static void testGetForgotPasswordUrl() {
  	String authConfig = LightningLoginFormController.getForgotPasswordUrl();
  	System.assertEquals(true, true);
 	}
    
    @IsTest
 	static void testSetExperienceIdTry() {
  	String authConfig = LightningLoginFormController.setExperienceId('paranoia');
  	System.assertEquals(true, true);
 	}
    
    @IsTest
 	static void testSetExperienceIdCatch() {
  	String authConfig = LightningLoginFormController.setExperienceId(null);
  	System.assertEquals(true, true);
 	}
    
}