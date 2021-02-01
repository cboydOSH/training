@isTest
public class OSH_ChargentOrdersTest {

    @testSetup
    public static void setup() {
           //Create Account
           RecordType rtAcct = [SELECT Id from RecordType WHERE SobjectType = 'Account' limit 1];
           Account acc= new Account(Name = 'Test Account', RecordType = rtAcct);
           insert acc;
   
           //Create Asset
           Asset ass = new Asset(Name= 'AssetTest');
           insert ass;
   
           //Create Opp
           Opportunity opp = new Opportunity (Name = 'Opp Name', StageName= 'Prospecting', CloseDate = Date.newInstance(2024, 12, 9));
           insert opp;
   
           //Create Quote
           Quote qu = new Quote(Name= 'Quote Test', OpportunityId = opp.Id); 
           insert qu;
   
           //Create Chargent Order
           ChargentOrders__ChargentOrder__c newChargentOrder = new ChargentOrders__ChargentOrder__c();
           newChargentOrder.ChargentOrders__Account__c= acc.Id;
           newChargentOrder.Asset__c= ass.Id;
           newChargentOrder.ChargentOrders__Payment_Stop__c= 'Date';
           newChargentOrder.ChargentOrders__Charge_Amount__c= 89237923;
           newChargentOrder.ChargentOrders__Subtotal__c= 78;
           newChargentOrder.ChargentOrders__Charge_Date__c= '01';
           newChargentOrder.ChargentOrders__Order_Note__c= 'test test test';
           newChargentOrder.ChargentOrders__Manual_Charge__c= false;
           newChargentOrder.ChargentOrders__Payment_End_Date__c= Date.newInstance(2024, 04, 12);
           newChargentOrder.ChargentOrders__Payment_Frequency__c= 'Once';
           newChargentOrder.ChargentOrders__Payment_Status__c= 'Stopped';
           newChargentOrder.ChargentOrders__Payment_Start_Date__c= Date.newInstance(2023, 04, 12);
           newChargentOrder.ChargentOrders__Status__c= 'Initiated';
           newChargentOrder.Quote__c= qu.Id;
           insert newChargentOrder;
     
    }

    @isTest
    static void createChargentOrdersTest1() {

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Asset ass = [SELECT Id FROM Asset WHERE Name = 'AssetTest'];
        Quote qu = [SELECT Id FROM Quote WHERE Name = 'Quote Test'];
        ChargentOrders__ChargentOrder__c newChargentOrder = [SELECT Id FROM ChargentOrders__ChargentOrder__c WHERE ChargentOrders__Account__c=: acc.Id ];
   
    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Map<String, Object> selectedMonthlyContributionDiscount = new Map<String,Object>();
        selectedMonthlyContributionDiscount.put('Recurrency', 'Forever');
        Map<String, Object> bill =new Map<String, Object>();
        String datebill = Datetime.now().format('yyyy-MM-dd');
        bill.put('billingDatePlan', datebill);
        Double formulaCont = 093820283;
        bill.put('FormulaContributionAmount', formulaCont);
        bill.put('FormulaContributionAmountWithPromotions', 98989);

        inputMap.put('bill', bill);
        inputMap.put('selectedMonthlyContributionDiscount', selectedMonthlyContributionDiscount);
        inputMap.put('chargentOrderId', newChargentOrder.Id);
        inputMap.put('AssetId', ass.Id);
        inputMap.put('incomingQuoteId', qu.Id);

        OSH_ChargentOrders ins = new OSH_ChargentOrders();
        Boolean ret = ins.invokeMethod('createChargentOrders', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @isTest
    static void createChargentOrdersForeverTest2() {

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Asset ass = [SELECT Id FROM Asset WHERE Name = 'AssetTest'];
        Quote qu = [SELECT Id FROM Quote WHERE Name = 'Quote Test'];
        ChargentOrders__ChargentOrder__c newChargentOrder = [SELECT Id FROM ChargentOrders__ChargentOrder__c WHERE ChargentOrders__Account__c=: acc.Id ];
   
    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Map<String, Object> selectedMonthlyContributionDiscount = new Map<String,Object>();
        selectedMonthlyContributionDiscount.put('Recurrency', '1,2,3');
        Map<String, Object> bill =new Map<String, Object>();
        String datebill = Datetime.now().format('yyyy-MM-dd');
        bill.put('billingDatePlan', datebill);
        Double formulaCont = 093820283;
        bill.put('FormulaContributionAmount', formulaCont);
        bill.put('FormulaContributionAmountWithPromotions', 98989);

        inputMap.put('bill', bill);
        inputMap.put('selectedMonthlyContributionDiscount', selectedMonthlyContributionDiscount);
        inputMap.put('chargentOrderId', newChargentOrder.Id);
        inputMap.put('AssetId', ass.Id);
        inputMap.put('incomingQuoteId', qu.Id);

        OSH_ChargentOrders ins = new OSH_ChargentOrders();
        Boolean ret = ins.invokeMethod('createChargentOrders', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @isTest
    static void createChargentOrdersForeverTest3() {

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Asset ass = [SELECT Id FROM Asset WHERE Name = 'AssetTest'];
        Quote qu = [SELECT Id FROM Quote WHERE Name = 'Quote Test'];
        ChargentOrders__ChargentOrder__c newChargentOrder = [SELECT Id FROM ChargentOrders__ChargentOrder__c WHERE ChargentOrders__Account__c=: acc.Id ];
   
    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Map<String, Object> selectedMonthlyContributionDiscount = new Map<String,Object>();
        selectedMonthlyContributionDiscount.put('Recurrency', '4');
        Map<String, Object> bill =new Map<String, Object>();
        String datebill = Datetime.now().format('yyyy-MM-dd');
        bill.put('billingDatePlan', datebill);
        Double formulaCont = 093820283;
        bill.put('FormulaContributionAmount', formulaCont);
        bill.put('FormulaContributionAmountWithPromotions', 98989);

        inputMap.put('bill', bill);
        inputMap.put('selectedMonthlyContributionDiscount', selectedMonthlyContributionDiscount);
        inputMap.put('chargentOrderId', newChargentOrder.Id);
        inputMap.put('AssetId', ass.Id);
        inputMap.put('incomingQuoteId', qu.Id);

        OSH_ChargentOrders ins = new OSH_ChargentOrders();
        Boolean ret = ins.invokeMethod('createChargentOrders', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @isTest
    static void createChargentOrdersForeverTest4() {

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Asset ass = [SELECT Id FROM Asset WHERE Name = 'AssetTest'];
        Quote qu = [SELECT Id FROM Quote WHERE Name = 'Quote Test'];
        ChargentOrders__ChargentOrder__c newChargentOrder = [SELECT Id FROM ChargentOrders__ChargentOrder__c WHERE ChargentOrders__Account__c=: acc.Id ];
   
    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Map<String, Object> selectedMonthlyContributionDiscount = new Map<String,Object>();
        selectedMonthlyContributionDiscount.put('Recurrency', '2,3');
        Map<String, Object> bill =new Map<String, Object>();
        String datebill = Datetime.now().format('yyyy-MM-dd');
        bill.put('billingDatePlan', datebill);
        Double formulaCont = 093820283;
        bill.put('FormulaContributionAmount', formulaCont);
        bill.put('FormulaContributionAmountWithPromotions', 98989);

        inputMap.put('bill', bill);
        inputMap.put('selectedMonthlyContributionDiscount', selectedMonthlyContributionDiscount);
        inputMap.put('chargentOrderId', newChargentOrder.Id);
        inputMap.put('AssetId', ass.Id);
        inputMap.put('incomingQuoteId', qu.Id);

        OSH_ChargentOrders ins = new OSH_ChargentOrders();
        Boolean ret = ins.invokeMethod('createChargentOrders', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }

    @isTest
    static void createChargentOrdersForeverTest5() {

        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Asset ass = [SELECT Id FROM Asset WHERE Name = 'AssetTest'];
        Quote qu = [SELECT Id FROM Quote WHERE Name = 'Quote Test'];
        ChargentOrders__ChargentOrder__c newChargentOrder = [SELECT Id FROM ChargentOrders__ChargentOrder__c WHERE ChargentOrders__Account__c=: acc.Id ];
   
    	Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        //Fill input
        Map<String, Object> selectedMonthlyContributionDiscount = new Map<String,Object>();
        selectedMonthlyContributionDiscount.put('Recurrency', 'Never');
        Map<String, Object> bill =new Map<String, Object>();
        String datebill = Datetime.now().format('yyyy-MM-dd');
        bill.put('billingDatePlan', datebill);
        Double formulaCont = 093820283;
        bill.put('FormulaContributionAmount', formulaCont);
        bill.put('FormulaContributionAmountWithPromotions', 98989);

        inputMap.put('bill', bill);
        inputMap.put('selectedMonthlyContributionDiscount', selectedMonthlyContributionDiscount);
        inputMap.put('chargentOrderId', newChargentOrder.Id);
        inputMap.put('AssetId', ass.Id);
        inputMap.put('incomingQuoteId', qu.Id);

        OSH_ChargentOrders ins = new OSH_ChargentOrders();
        Boolean ret = ins.invokeMethod('createChargentOrders', inputMap, outMap, options);
        System.assertEquals(true, ret);
    }
}