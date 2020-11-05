<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Producer_Needs_Application_Sent</fullName>
        <description>Producer Needs Application Sent</description>
        <protected>false</protected>
        <recipients>
            <recipient>Contracting</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_in_Application_3_Days</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Compliance_when_LOI_Created</fullName>
        <ccEmails>compliance@onesharehealth.com</ccEmails>
        <description>Send email to Compliance when LOI Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>cmoore@onesharehealth.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sweaver@onesharehealth.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LOI_Created_notification</template>
    </alerts>
</Workflow>
