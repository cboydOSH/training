<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Affinity_Approval_Needed</fullName>
        <description>Affinity Approval Needed</description>
        <protected>false</protected>
        <recipients>
            <recipient>bnabors@onesharehealth.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mbaum@onesharehealth.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Email_Templates/Approval_Requested</template>
    </alerts>
    <alerts>
        <fullName>Producer_Contract_level_is_approved</fullName>
        <description>Producer Contract level is approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>bnabors@onesharehealth.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mbaum@onesharehealth.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Email_Templates/Approval_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Producer_Contract_level_is_not_approved</fullName>
        <description>Producer Contract level is not approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Process_Email_Templates/Approval_Request_Not_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_an_internal_lead_is_created</fullName>
        <description>Send email when an internal lead is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Leadership</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Internal_Lead</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Blank</fullName>
        <field>Approval_Status__c</field>
        <name>Approval Status to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Not_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Approved</literalValue>
        <name>Approval Status to Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Contract_Level</fullName>
        <field>Contract_Level__c</field>
        <name>Clear Contract Level</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Send Email When Internal Lead Created</fullName>
        <actions>
            <name>Send_email_when_an_internal_lead_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
            <value>Carrlos Boyd</value>
        </criteriaItems>
        <description>When an internal lead is created by Contracting, Producer Onboarding, or Producer Support, send an email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
