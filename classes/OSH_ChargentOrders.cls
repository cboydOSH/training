global without sharing class OSH_ChargentOrders implements vlocity_ins.VlocityOpenInterface2 {

    static final String RECURRENCY_FOREVER = 'Forever';
    static final String RECURRENCY_ONE_TWO_TREE = '1,2,3';
    static final String RECURRENCY_TWO_TREE = '2,3';
    static final String RECURRENCY_FOUR = '4';
    static final String RECURRENCY_NOCOUPON = 'Never';

    global Boolean invokeMethod(String methodName, Map<String,Object> inputs, Map<String, Object> output, Map<String, Object> options) {
        if(methodName == 'createChargentOrders'){
            system.debug('initiated createChargentOrders');
            return createChargentOrders(inputs, output, options);
        }
        return false;
    }

    public Boolean createChargentOrders(Map<String,Object> inputs, Map<String,Object> output, Map<String,Object> options){
        try{
            //Get chargent order id
            String chargentOrderId = (String)inputs.get('chargentOrderId');
            //Get chargent order information
            ChargentOrders__ChargentOrder__c chargentOrderObj = getChargentOrderInfo(chargentOrderId);
            //Get promotion detail
            Map<String, Object> promotionMap = (Map<String, Object>)inputs.get('selectedMonthlyContributionDiscount');
            //Get recurrency
            String recurrency = (String)promotionMap.get('Recurrency');
            //Get assetId
            String assetId = (String)inputs.get('AssetId');
            //Get quoteId
            String quoteId = (String)inputs.get('incomingQuoteId');
            //Get billing information
            Map<String, Object> billingMap = (Map<String, Object>)inputs.get('bill');
            //Get plan contribution date
            String contributionDateString = (String)billingMap.get('billingDatePlan');
            //Convert it to 'date'
            Date contributionDate = Date.valueOf(contributionDateString);
            //system.debug('contributionDate: ' + contributionDate);
            Date contributionDatePlusOneMonth = contributionDate.addMonths(1);
            //system.debug('contributionDatePlusOneMonth: ' + contributionDatePlusOneMonth);
            String contributionDay = contributionDate.day()+'';
            //system.debug('contributionDay: ' + contributionDay);
            //Get plan contribution amount
            Double contributionAmountWithoutDiscounts = (Double)billingMap.get('FormulaContributionAmount');
            //Get plan contribution amount with discount
            Double contributionAmountWithDiscounts = (Double)billingMap.get('FormulaContributionAmountWithPromotions');
            
            ChargentOrders__ChargentOrder__c secondChargentOrder = null;

            //Compare recurrency
            if(RECURRENCY_FOREVER.equals(recurrency)){
                //If discount is forever let's create one unending chargent order WITH discounted amount
                createChargentOrder(chargentOrderObj, contributionAmountWithDiscounts, 'Recurring', 'Unending', 'Recurrent Contribution', 
                 'Monthly', contributionDate.addMonths(1), null, contributionDate.addMonths(1), contributionDay);

            }else if(RECURRENCY_ONE_TWO_TREE.equals(recurrency)){
                //If discount is 1,2,3 let's create one ending chargent order WITH discounted amount 
                createChargentOrder(chargentOrderObj, contributionAmountWithDiscounts, 'Recurring', 'Date', 'Recurrent Contribution',
                 'Monthly', contributionDate.addMonths(1), contributionDate.addMonths(3).addDays(-1), contributionDate.addMonths(1), contributionDay);
                //and other unending WITH NO discounted amount
                createChargentOrder(chargentOrderObj, contributionAmountWithoutDiscounts, 'Recurring', 'Unending', 'Recurrent Contribution', 
                 'Monthly', contributionDate.addMonths(3), null, contributionDate.addMonths(3), contributionDay);

            }else if(RECURRENCY_TWO_TREE.equals(recurrency)){
                //If discount is 2,3 let's create one ending chargent order WITH discounted amount 
                createChargentOrder(chargentOrderObj, contributionAmountWithDiscounts, 'Recurring', 'Date', 'Recurrent Contribution', 
                 'Monthly', contributionDate.addMonths(1), contributionDate.addMonths(3).addDays(-1), contributionDate.addMonths(1), contributionDay);
                //and other unending WITH NO discounted amount
                createChargentOrder(chargentOrderObj, contributionAmountWithoutDiscounts, 'Recurring', 'Unending', 'Recurrent Contribution', 
                 'Monthly', contributionDate.addMonths(3), null, contributionDate.addMonths(3), contributionDay);

            }else if(RECURRENCY_FOUR.equals(recurrency)){
                //If discount is 4 let's create one ending chargent order WITH NO discounted amount 
                createChargentOrder(chargentOrderObj, contributionAmountWithoutDiscounts, 'Recurring', 'Date', 'Recurrent Contribution', 
                 'Monthly', contributionDate.addMonths(1), contributionDate.addMonths(3).addDays(-1), contributionDate.addMonths(1), contributionDay);
                //and other chargent order WITH NO discounted amount 
                createChargentOrder(chargentOrderObj, contributionAmountWithDiscounts, 'Recurring', 'Date', 'Recurrent Contribution', 
                 'Once', contributionDate.addMonths(3), contributionDate.addMonths(4).addDays(-1), contributionDate.addMonths(3), contributionDay);
                //and other unending WITH NO discounted amount
                createChargentOrder(chargentOrderObj, contributionAmountWithoutDiscounts, 'Recurring', 'Unending', 'Recurrent Contribution', 
                 'Monthly', contributionDate.addMonths(4), null, contributionDate.addMonths(4), contributionDay);

            }else if(RECURRENCY_NOCOUPON.equals(recurrency)){
                 //If THERE IS NOO discount let's create one unending chargent order WITH OUT discounted amount
                secondChargentOrder = createChargentOrder(chargentOrderObj, contributionAmountWithoutDiscounts, 'Recurring', 'Unending', 'Recurrent Contribution', 
                 'Monthly', contributionDatePlusOneMonth, null, contributionDatePlusOneMonth, contributionDay);

            }else{
                //Throw error if there is no known recurrency and show the coupon for troubleshoot
                output.put('error', 'Please check your promotion('+ promotionMap.get('Coupon') +') setup recurrency');
                return false;
            }
            
            if(secondChargentOrder!=null){
                //Insert second chargent order
                Asset assetInExecution = [SELECT Id, Second_Chargent_Order__c FROM Asset WHERE Id =: assetId];
                assetInExecution.Second_Chargent_Order__c = secondChargentOrder.Id;
                update assetInExecution;
            }

            //Get all chargent orders associated with the asset Id
            List<ChargentOrders__ChargentOrder__c> chargentOrders = getChargentOrdersRelatedWithAsset(assetId);
            //Update the payment details!
            updatePaymentDetails(chargentOrders, chargentOrderObj);
            //Return true as execution result!
            return true;
        }catch(Exception e){
            //Something bad happened, return errors and false as execution result
            output.put('error', e);
            system.debug(e);
            return false;
        }
    }

    private ChargentOrders__ChargentOrder__c createChargentOrder(ChargentOrders__ChargentOrder__c chargentOrderModel, Double chargeAmount, String paymentStatus,
                                    String paymentStop, String orderNote, String frequency, Date nextTransactionDate, Date paymentEndDate,
                                    Date startDate, String contributionDay){

        ChargentOrders__ChargentOrder__c newChargentOrder = new ChargentOrders__ChargentOrder__c(
            //ChargentOrders__Date__c='',
            ChargentOrders__Account__c=chargentOrderModel.ChargentOrders__Account__c,
            Asset__c=chargentOrderModel.Asset__c,
            ChargentOrders__Payment_Stop__c=paymentStop,
            ChargentOrders__Charge_Amount__c=chargeAmount,
            ChargentOrders__Subtotal__c=chargeAmount,
            ChargentOrders__Charge_Date__c=contributionDay,
            ChargentOrders__Order_Note__c=orderNote,
            ChargentOrders__Manual_Charge__c=false,
            //ChargentOrders__Next_Transaction_Date__c=nextTransactionDate,
            ChargentOrders__Payment_End_Date__c=paymentEndDate,
            ChargentOrders__Payment_Frequency__c=frequency,
            ChargentOrders__Payment_Status__c=paymentStatus,
            ChargentOrders__Payment_Start_Date__c=startDate,
            ChargentOrders__Status__c='Initiated',
            Quote__c=chargentOrderModel.Quote__c,
            Contract__c=chargentOrderModel.Contract__c,
            ChargentOrders__Billing_Email__c=chargentOrderModel.ChargentOrders__Billing_Email__c,
            ChargentOrders__Billing_First_Name__c=chargentOrderModel.ChargentOrders__Billing_First_Name__c,
            ChargentOrders__Billing_Last_Name__c=chargentOrderModel.ChargentOrders__Billing_Last_Name__c,
            ChargentOrders__Billing_Address__c=chargentOrderModel.ChargentOrders__Billing_Address__c,
            ChargentOrders__Billing_City__c=chargentOrderModel.ChargentOrders__Billing_City__c,
            ChargentOrders__Billing_Country__c=chargentOrderModel.ChargentOrders__Billing_Country__c,
            ChargentOrders__Billing_State__c=chargentOrderModel.ChargentOrders__Billing_State__c,
            ChargentOrders__Billing_Zip_Postal__c=chargentOrderModel.ChargentOrders__Billing_Zip_Postal__c,
            ChargentOrders__Billing_Phone__c=chargentOrderModel.ChargentOrders__Billing_Phone__c
            );
            system.debug('before inserting chargent order');
            system.debug( newChargentOrder );
            insert newChargentOrder;
            system.debug('after inserting chargent order');
            system.debug( newChargentOrder );
            return newChargentOrder;
    }

    private void updatePaymentDetails(List<ChargentOrders__ChargentOrder__c> chargentOrders, ChargentOrders__ChargentOrder__c chargentOrderModel){
        for(ChargentOrders__ChargentOrder__c chargentOrderToUpdate : chargentOrders){
            chargentOrderToUpdate.ChargentOrders__Account__c=chargentOrderModel.ChargentOrders__Account__c;
            chargentOrderToUpdate.Quote__c=chargentOrderModel.Quote__c;
            chargentOrderToUpdate.Contract__c=chargentOrderModel.Contract__c;
            chargentOrderToUpdate.ChargentOrders__Manual_Charge__c = false;
            chargentOrderToUpdate.ChargentOrders__Billing_Email__c=chargentOrderModel.ChargentOrders__Billing_Email__c;
            chargentOrderToUpdate.ChargentOrders__Billing_First_Name__c=chargentOrderModel.ChargentOrders__Billing_First_Name__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Last_Name__c=chargentOrderModel.ChargentOrders__Billing_Last_Name__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Address__c=chargentOrderModel.ChargentOrders__Billing_Address__c;
            chargentOrderToUpdate.ChargentOrders__Billing_City__c=chargentOrderModel.ChargentOrders__Billing_City__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Country__c=chargentOrderModel.ChargentOrders__Billing_Country__c;
            chargentOrderToUpdate.ChargentOrders__Billing_State__c=chargentOrderModel.ChargentOrders__Billing_State__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Zip_Postal__c=chargentOrderModel.ChargentOrders__Billing_Zip_Postal__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Phone__c=chargentOrderModel.ChargentOrders__Billing_Phone__c;
            chargentOrderToUpdate.ChargentOrders__Card_Expiration_Month__c=chargentOrderModel.ChargentOrders__Card_Expiration_Month__c;
            chargentOrderToUpdate.ChargentOrders__Card_Expiration_Year__c=chargentOrderModel.ChargentOrders__Card_Expiration_Year__c;
            chargentOrderToUpdate.ChargentOrders__Card_Last_4__c=chargentOrderModel.ChargentOrders__Card_Last_4__c;
            chargentOrderToUpdate.ChargentOrders__Card_Month_Indicator__c=chargentOrderModel.ChargentOrders__Card_Month_Indicator__c;
            chargentOrderToUpdate.ChargentOrders__Card_Number__c=chargentOrderModel.ChargentOrders__Card_Number__c;
            chargentOrderToUpdate.ChargentOrders__Card_Type__c=chargentOrderModel.ChargentOrders__Card_Type__c;
            chargentOrderToUpdate.ChargentOrders__Tokenization__c=chargentOrderModel.ChargentOrders__Tokenization__c;
            chargentOrderToUpdate.ChargentOrders__Card_Year_Indicator__c=chargentOrderModel.ChargentOrders__Card_Year_Indicator__c;
            chargentOrderToUpdate.ChargentOrders__Bank_Account_Last_4__c=chargentOrderModel.ChargentOrders__Bank_Account_Last_4__c;
            chargentOrderToUpdate.ChargentOrders__Bank_Account_Name__c=chargentOrderModel.ChargentOrders__Bank_Account_Name__c;
            chargentOrderToUpdate.ChargentOrders__Bank_Account_Number__c=chargentOrderModel.ChargentOrders__Bank_Account_Number__c;
            chargentOrderToUpdate.ChargentOrders__Bank_Account_Type__c=chargentOrderModel.ChargentOrders__Bank_Account_Type__c;
            chargentOrderToUpdate.ChargentOrders__Bank_Name__c=chargentOrderModel.ChargentOrders__Bank_Name__c;
            chargentOrderToUpdate.ChargentOrders__Bank_Routing_Number__c=chargentOrderModel.ChargentOrders__Bank_Routing_Number__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Address_Line_2__c=chargentOrderModel.ChargentOrders__Billing_Address_Line_2__c;
            chargentOrderToUpdate.ChargentOrders__Billing_Company__c=chargentOrderModel.ChargentOrders__Billing_Company__c;
        }
        update chargentOrders;
    }

    /**
     * Method to get the chargent order details related with an assetId
     */
    private List<ChargentOrders__ChargentOrder__c> getChargentOrdersRelatedWithAsset(String assetId){
        return [SELECT Id, ChargentOrders__Account__c, Asset__c, ChargentOrders__Payment_Stop__c, ChargentOrders__Charge_Amount__c, 
        ChargentOrders__Subtotal__c, ChargentOrders__Charge_Date__c, ChargentOrders__Order_Note__c, ChargentOrders__Manual_Charge__c, 
        ChargentOrders__Next_Transaction_Date__c, ChargentOrders__Payment_End_Date__c, ChargentOrders__Payment_Frequency__c, 
        ChargentOrders__Payment_Status__c, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Status__c, Quote__c, Contract__c, 
        ChargentOrders__Billing_Email__c, ChargentOrders__Billing_First_Name__c, ChargentOrders__Billing_Last_Name__c, 
        ChargentOrders__Billing_Address__c, ChargentOrders__Billing_City__c, ChargentOrders__Billing_Country__c, 
        ChargentOrders__Billing_State__c, ChargentOrders__Billing_Zip_Postal__c, ChargentOrders__Billing_Phone__c, 
        ChargentOrders__Card_Expiration_Month__c, ChargentOrders__Card_Expiration_Year__c, 
        ChargentOrders__Card_Last_4__c, ChargentOrders__Card_Month_Indicator__c, ChargentOrders__Card_Number__c, 
        ChargentOrders__Card_Type__c, ChargentOrders__Card_Year_Indicator__c, ChargentOrders__Bank_Account_Last_4__c, 
        ChargentOrders__Bank_Account_Name__c, ChargentOrders__Bank_Account_Number__c, ChargentOrders__Bank_Account_Type__c, 
        ChargentOrders__Bank_Name__c, ChargentOrders__Bank_Routing_Number__c, ChargentOrders__Billing_Address_Line_2__c, 
        ChargentOrders__Billing_Company__c, ChargentOrders__Tokenization__c
        FROM ChargentOrders__ChargentOrder__c 
        WHERE Asset__c =: assetId];
    }

    /**
     * Method to get the chargent order details to copy
     */
    private ChargentOrders__ChargentOrder__c getChargentOrderInfo(String chargentOrderId){
        return [SELECT Id, ChargentOrders__Account__c, ChargentOrders__Balance_Due__c, 
        ChargentOrders__Bank_Account_Last_4__c, ChargentOrders__Bank_Account_Name__c, ChargentOrders__Bank_Account_Number__c,
        ChargentOrders__Bank_Account_Type__c, ChargentOrders__Bank_Name__c, ChargentOrders__Bank_Routing_Number__c, 
        ChargentOrders__Billing_Address_Line_2__c, ChargentOrders__Billing_Address__c, ChargentOrders__Billing_City__c, 
        ChargentOrders__Billing_Company__c, ChargentOrders__Billing_Country__c, ChargentOrders__Billing_Email__c, 
        ChargentOrders__Billing_Fax__c, ChargentOrders__Billing_First_Name__c, ChargentOrders__Billing_Last_Name__c, 
        ChargentOrders__Billing_Phone__c, ChargentOrders__Billing_State_Province__c, ChargentOrders__Billing_State__c, 
        ChargentOrders__Billing_Zip_Postal__c, ChargentOrders__Birthdate__c, ChargentOrders__CPF_Number__c, 
        ChargentOrders__Card_Expiration_Month__c, ChargentOrders__Card_Expiration_Year__c, ChargentOrders__Card_Last_4__c, 
        ChargentOrders__Card_Month_Indicator__c, ChargentOrders__Card_Number__c, ChargentOrders__Card_Type__c, 
        ChargentOrders__Card_Year_Indicator__c, ChargentOrders__Charge_Amount__c, ChargentOrders__Charge_Date__c, 
        ChargentOrders__Check_Number__c, ChargentOrders__Credit_Amount__c, ChargentOrders__Credit_Card_Name__c, 
        ChargentOrders__Currency__c, ChargentOrders__Customer_IP__c, ChargentOrders__Customer_Token__c, 
        ChargentOrders__Date__c, ChargentOrders__Date_of_Birth__c, ChargentOrders__Description__c, 
        ChargentOrders__Gateway_Card_Handling__c, ChargentOrders__Gateway__c, ChargentOrders__Invoice_Number__c, 
        ChargentOrders__Manual_Charge__c, ChargentOrders__Mercury_ID__c, ChargentOrders__Next_Transaction_Date__c, 
        ChargentOrders__No_Tax__c, ChargentOrders__OrderNumber__c, ChargentOrders__OrderSource__c, 
        ChargentOrders__Order_Information__c, ChargentOrders__Order_Link__c, ChargentOrders__Order_Note__c, 
        ChargentOrders__PO_Number__c, ChargentOrders__Payment_Count__c, ChargentOrders__Payment_End_Date__c, 
        ChargentOrders__Payment_Frequency__c, ChargentOrders__Payment_Method__c, ChargentOrders__Payment_Received__c, 
        ChargentOrders__Payment_Start_Date__c, ChargentOrders__Payment_Status__c, ChargentOrders__Payment_Stop__c, 
        ChargentOrders__Shipping_Address_Line_2__c, ChargentOrders__Shipping_Address__c, ChargentOrders__Shipping_City__c, 
        ChargentOrders__Shipping_Company__c, ChargentOrders__Shipping_Country__c, ChargentOrders__Shipping_Duty__c, 
        ChargentOrders__Shipping_First_Name__c, ChargentOrders__Shipping_Instructions__c, ChargentOrders__Shipping_Name__c, 
        ChargentOrders__Shipping_Phone__c, ChargentOrders__Shipping_State__c, ChargentOrders__Shipping_Zip_Postal__c, 
        ChargentOrders__Shipping__c, ChargentOrders__Status__c, ChargentOrders__Subtotal__c, ChargentOrders__Tax_Exempt__c, 
        ChargentOrders__Tax__c, ChargentOrders__Tokenization__c, ChargentOrders__Total__c, ChargentOrders__Tracking_Number__c, 
        ChargentOrders__Update_Token__c, ChargentOrders__UseTokenization__c, ChargentOrders__Last_Recurring_Transaction__c, 
        ChargentOrders__Last_Transaction__c, ChargentOrders__Transaction_Count_Recurring__c, ChargentOrders__Transaction_Count__c, 
        ChargentOrders__Transaction_Total__c, Quote__c, Contract__c, Asset__c 
        FROM ChargentOrders__ChargentOrder__c 
        WHERE Id =: chargentOrderId];
    }
}