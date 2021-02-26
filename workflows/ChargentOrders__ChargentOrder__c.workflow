<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ChargentOrders__PartialPayment</fullName>
        <field>ChargentOrders__Payment_Received__c</field>
        <literalValue>Partial</literalValue>
        <name>Partial Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChargentOrders__PaymentFull</fullName>
        <field>ChargentOrders__Payment_Received__c</field>
        <literalValue>Full</literalValue>
        <name>Payment Full</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChargentOrders__Set_Manual_Charge_to_True</fullName>
        <field>ChargentOrders__Manual_Charge__c</field>
        <literalValue>1</literalValue>
        <name>Set Manual Charge to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChargentOrders__UpdateChargeAmount</fullName>
        <field>ChargentOrders__Charge_Amount__c</field>
        <formula>ChargentOrders__Total__c -  ChargentOrders__Transaction_Total__c</formula>
        <name>Update Charge Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ChargentOrders__Full Payment</fullName>
        <actions>
            <name>ChargentOrders__PaymentFull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ChargentOrders__Total__c = ChargentOrders__Transaction_Total__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ChargentOrders__Partial Payment</fullName>
        <actions>
            <name>ChargentOrders__PartialPayment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ChargentOrders__Total__c &gt;  ChargentOrders__Transaction_Total__c, ChargentOrders__Transaction_Total__c &gt; 0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ChargentOrders__Payment Status Recurring</fullName>
        <actions>
            <name>ChargentOrders__Set_Manual_Charge_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChargentOrders__ChargentOrder__c.ChargentOrders__Payment_Status__c</field>
            <operation>equals</operation>
            <value>Recurring</value>
        </criteriaItems>
        <description>This rule fires when the Chargent Payment Status field equals &quot;Recurring.&quot;  Use this rule to set any values that you want defined every time the value in the Payment Status field is recurring.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChargentOrders__Update Charge Amount</fullName>
        <actions>
            <name>ChargentOrders__UpdateChargeAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChargentOrders__ChargentOrder__c.ChargentOrders__Manual_Charge__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
