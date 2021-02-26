<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ChargentOrders__Account_Updater_Notification</fullName>
        <description>Account Updater Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ChargentOrders__Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ChargentOrders__Chargent_Templates/ChargentOrders__Account_Updater_Feature_Html</template>
    </alerts>
    <alerts>
        <fullName>ChargentOrders__Transaction_Error_Notification</fullName>
        <description>Transaction Error Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ChargentOrders__Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ChargentOrders__Chargent_Templates/ChargentOrders__SObject_Error_Email</template>
    </alerts>
    <rules>
        <fullName>ChargentOrders__Send Account Update Email</fullName>
        <actions>
            <name>ChargentOrders__Account_Updater_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChargentOrders__Email_Notification__c.ChargentOrders__Account_Updater_Link__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ChargentOrders__Send Sobject Error Email</fullName>
        <actions>
            <name>ChargentOrders__Transaction_Error_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChargentOrders__Email_Notification__c.ChargentOrders__Email__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>ChargentOrders__Email_Notification__c.ChargentOrders__Status__c</field>
            <operation>contains</operation>
            <value>Error,Unresolved Transaction</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
