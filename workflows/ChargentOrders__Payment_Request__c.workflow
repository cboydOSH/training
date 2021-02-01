<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ChargentOrders__Payment_Request</fullName>
        <description>Payment Request</description>
        <protected>false</protected>
        <recipients>
            <field>ChargentOrders__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ChargentOrders__Chargent_Templates/ChargentOrders__Payment_Request_Email_Html</template>
    </alerts>
    <rules>
        <fullName>ChargentOrders__Payment Request Email</fullName>
        <actions>
            <name>ChargentOrders__Payment_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChargentOrders__Payment_Request__c.ChargentOrders__Send_Payment_Request_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ChargentOrders__Payment_Request__c.ChargentOrders__Status__c</field>
            <operation>notEqual</operation>
            <value>Paid</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
