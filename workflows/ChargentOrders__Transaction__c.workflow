<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ChargentOrders__Customer_Receipt</fullName>
        <description>Customer Receipt</description>
        <protected>false</protected>
        <recipients>
            <field>ChargentOrders__Billing_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ChargentOrders__Chargent_Templates/ChargentOrders__Customer_Receipt</template>
    </alerts>
    <alerts>
        <fullName>ChargentOrders__Recurring_Transaction_Failure_Email_Alert</fullName>
        <description>Recurring Transaction Failure Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ChargentOrders__Billing_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ChargentOrders__Chargent_Templates/ChargentOrders__Payment_Issue_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>ChargentOrders__Invert_Refund</fullName>
        <description>Used to convert the transaction amount to a negative upon successful refund of a transaction. This will now calculate properly in Balance Due and Total Transactions</description>
        <field>ChargentOrders__Amount__c</field>
        <formula>0</formula>
        <name>Invert Refund</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ChargentOrders__Customer Receipt</fullName>
        <actions>
            <name>ChargentOrders__Customer_Receipt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChargentOrders__Transaction__c.ChargentOrders__Type__c</field>
            <operation>equals</operation>
            <value>Charge</value>
        </criteriaItems>
        <criteriaItems>
            <field>ChargentOrders__Transaction__c.ChargentOrders__Response_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This rule fires on successful Chargent payment transactions.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChargentOrders__Error with Recurring Payment</fullName>
        <actions>
            <name>ChargentOrders__Recurring_Transaction_Failure_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ChargentOrders__Transaction__c.ChargentOrders__Response_Status__c</field>
            <operation>equals</operation>
            <value>Declined,Error</value>
        </criteriaItems>
        <criteriaItems>
            <field>ChargentOrders__Transaction__c.ChargentOrders__Recurring__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule fires when a recurring transaction fails to be completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChargentOrders__Invert Refund</fullName>
        <actions>
            <name>ChargentOrders__Invert_Refund</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>No longer used. A Refund will now create a NEW transaction with a negative amount.</description>
        <formula>1=2</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
