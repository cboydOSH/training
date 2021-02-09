global without sharing class CallGetQuoteDailyCountDR implements Vlocity_ins.VlocityOpenInterface{
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        if (methodName == 'callDR') {
            return callDR(inputMap, outputMap, options);
        }
        if (methodName == 'getNextInfoPacketNumber') {
            return getNextInfoPacketNumber(inputMap, outputMap, options);
        }
        return true;
    }

    private Boolean callDR(Map <String, Object> drInput, Map <String, Object> drOutput, Map <String, Object> drOptions) {
        /* Specify DataRaptor extract or transform to call */
        String DRName = 'DREX_GetQuoteDailyCount'; 
        /* Populate the input JSON */
        Map<String, Object> myTransformData = new Map<String, Object>{'MyKey'=>'MyValue'}; 
        /* Call the DataRaptor */
        vlocity_ins.DRProcessResult result = vlocity_ins.DRGlobal.process(myTransformData, DRName); 
        /* Deserialize the DataRaptor output for processing in Apex */ 
        List<Map<String, Object>> myTransformResult = (List<Map<String, Object>>)result.toJsonList(); 

        drOutput.put('infoPacketNumber',myTransformResult[0].get('infoPacketNumber'));
        return true;
    }

    private Boolean getNextInfoPacketNumber(Map <String, Object> inputMap, Map <String, Object> outputMap, Map <String, Object> optionsMap) {
        //Stablish timezone
        Timezone tz = Timezone.getTimeZone('America/Chicago');
        //Get todays user datetime
        Datetime now = Datetime.now();
        //get offset - time difference
        Integer offset = tz.getOffset(now);
        //Add seconds in order to standardize 
        Datetime local = now.addSeconds(offset/1000);
        //get todays date based on timezone selected
        Date todayDate = date.newinstance(local.year(), local.month(), local.day());
        //Get start of the day
        Datetime todayStartTime = todayDate;
        //Get end of the day
        Datetime todayEndTime = todayStartTime.addHours(23).addMinutes(59).addSeconds(59);
        //Get Counter
        Integer quoteCount = [SELECT COUNT() FROM Quote WHERE CreatedDate >=:todayStartTime AND CreatedDate<=:todayEndTime ALL ROWS];
        //Add one for the new information packet to be generated
        quoteCount = quoteCount + 1;
        //Initialize secuentialnumber
        String secuentialNumber = '';
        //modify secuential number as expected
        if(quoteCount<10){
            secuentialNumber = '0000' + quoteCount;
        }else if(quoteCount>=10 && quoteCount<100){
            secuentialNumber = '000' + quoteCount;
        }else if(quoteCount>=100 && quoteCount<1000){
            secuentialNumber = '00' + quoteCount;
        }else if(quoteCount>=1000 && quoteCount<10000){
            secuentialNumber = '0' + quoteCount;
        }else{
            secuentialNumber = '' + quoteCount;
        }
        //formating info packet number as required
        String infopacketnumber = local.format('MMddyy') + '-'+ secuentialNumber;
        //add to output
        outputMap.put('infoPacketNumber', infopacketnumber);
        //return true
        return true;
    }
}