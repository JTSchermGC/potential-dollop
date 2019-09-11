public class RecurringDonationsCallout {
	@Future(callout=true)
	public static Void RecurringDonationsCalloutData(List<Id> idVal) {
        try{
            String AccessToken = GetGcToken.TokenData();
            npe03__Recurring_Donation__c[] CampQuery = [select Id,Start_Date__c,DonorPaymentMethod__c,GcSignupId__c,npe03__Recurring_Donation_Campaign__c,npe03__Installment_Period__c,npe03__Date_Established__c,npe03__Next_Payment_Date__c,npe03__Last_Payment_Date__c,npe03__Amount__c,npe03__Contact__c,npe03__Schedule_Type__c,npe03__Installment_Amount__c,npe03__Installments__c from npe03__Recurring_Donation__c where Id=:idVal];
            Id CampAutoId = CampQuery.get(0).Id;
            String EventIdVal = CampQuery.get(0).npe03__Recurring_Donation_Campaign__c;
            String ContactId = CampQuery.get(0).npe03__Contact__c;
            String PMTId = CampQuery.get(0).DonorPaymentMethod__c;
            Campaign[] eventData = [SELECT Id,gc_event_id__c FROM Campaign where Id=:EventIdVal];
            Contact[] contactData = [SELECT Id,Name,Donor_Id__c FROM Contact where Id=:ContactId];
            DonorPaymentMethod__c[] PMTData = [select donor_payment_method_id__c from DonorPaymentMethod__c where Id=:PMTId];
            String donorAutoid = string.valueOf(contactData.get(0).Id);
            String donorName = string.valueOf(contactData.get(0).Name);
            String EventAutoid = string.valueOf(eventData.get(0).Id);
            String PMTDataVal = string.valueOf(PMTData.get(0).donor_payment_method_id__c);
            
			String GcEventId = string.valueOf(eventData.get(0).gc_event_id__c);
            String gcid = string.valueOf(contactData.get(0).Donor_Id__c);
            string payment_frequency = (CampQuery.get(0).npe03__Installment_Period__c == null) ? '' : CampQuery.get(0).npe03__Installment_Period__c;
            string pledge_creation_date = (string.valueOf(CampQuery.get(0).npe03__Date_Established__c) == null) ? '' : string.valueOf(CampQuery.get(0).npe03__Date_Established__c);
            //string payment_start_date = (string.valueOf(CampQuery.get(0).npe03__Next_Payment_Date__c) == null) ? '' : string.valueOf(CampQuery.get(0).npe03__Next_Payment_Date__c);
            string payment_end_date = (string.valueOf(CampQuery.get(0).npe03__Last_Payment_Date__c) == null) ? '' : string.valueOf(CampQuery.get(0).npe03__Last_Payment_Date__c);
            string pledge_amount = (string.valueOf(CampQuery.get(0).npe03__Amount__c) == null) ? '' : string.valueOf(CampQuery.get(0).npe03__Amount__c);
            string amount = (string.valueOf(CampQuery.get(0).npe03__Installment_Amount__c) == null) ? '' : string.valueOf(CampQuery.get(0).npe03__Installment_Amount__c);
            string ScheduleType = (CampQuery.get(0).npe03__Schedule_Type__c) == null ? '' : CampQuery.get(0).npe03__Schedule_Type__c;
            Integer Installments = Integer.valueOf(CampQuery.get(0).npe03__Installments__c);
            string SignupIdVal = (string.valueOf(CampQuery.get(0).GcSignupId__c) == null) ? '' : string.valueOf(CampQuery.get(0).GcSignupId__c);
            string payment_start_date = (string.valueOf(CampQuery.get(0).Start_Date__c) == null) ? '' : string.valueOf(CampQuery.get(0).Start_Date__c);
            string PmtidVal1 = (string.valueOf(PMTDataVal) == null) ? '' : string.valueOf(PMTDataVal);

            system.debug(PmtidVal1);
            String StringJson;
            Integer StartYear = Date.valueOf(payment_start_date).year();
            Integer StartDay = Date.valueOf(payment_start_date).day();
            Integer StartMonth = Date.valueOf(payment_start_date).Month();
            date EndDate;
            String EndDateVal;
            Integer InstallmentsVal = Installments -1;
            if(payment_frequency=='Monthly'){
                date myDate = date.newInstance(StartYear, StartMonth, StartDay);
                EndDate = myDate.addMonths(InstallmentsVal);
                EndDateVal = EndDate.year() + '-' + EndDate.month() + '-' + EndDate.day();
                //system.debug(EndDate);
                
            }else if(payment_frequency=='Yearly'){
                date myDate = date.newInstance(StartYear, StartMonth, StartDay);
                EndDate = myDate.addYears(InstallmentsVal);
                EndDateVal = EndDate.year() + '-' + EndDate.month() + '-' + EndDate.day();
            }
            else if(payment_frequency=='Quarterly'){
                date myDate = date.newInstance(StartYear, StartMonth, StartDay);
                EndDate = myDate.addMonths(InstallmentsVal*3);
                EndDateVal = EndDate.year() + '-' + EndDate.month() + '-' + EndDate.day();
            }else if(payment_frequency=='Semi-Annually'){
                date myDate = date.newInstance(StartYear, StartMonth, StartDay);
                EndDate = myDate.addMonths(InstallmentsVal*6);
                EndDateVal = EndDate.year() + '-' + EndDate.month() + '-' + EndDate.day();
            }else if(payment_frequency=='Weekly'){
                date myDate = date.newInstance(StartYear, StartMonth, StartDay);
                EndDate = myDate.addDays(InstallmentsVal*7);
                EndDateVal = EndDate.year() + '-' + EndDate.month() + '-' + EndDate.day();
            }
            else if(payment_frequency=='Bi-Weekly'){
                date myDate = date.newInstance(StartYear, StartMonth, StartDay);
                EndDate = myDate.addDays(InstallmentsVal*14);
                EndDateVal = EndDate.year() + '-' + EndDate.month() + '-' + EndDate.day();
            }
            //system.debug(EndDateVal);
            
            string payment_frequency1;
            if(payment_frequency=='Yearly'){
                payment_frequency1='Annually';
            }else{
                payment_frequency1=payment_frequency;
            }
            //system.debug(SignupIdVal);
            
            if(SignupIdVal != null && SignupIdVal !=''){
            
                if(ScheduleType=='Divide By'){
                	StringJson = '{"token":"'+AccessToken+'" ,"Api_Link":"'+Label.UpdateRecurringApi+'/'+SignupIdVal+'","gcid":"'+gcid+'","payment_frequency":"'+payment_frequency1+'","payment_start_date":"'+payment_start_date+'","pledge_amount":"'+pledge_amount+'","amount":"'+amount+'","donor_payment_method_id":"'+PmtidVal1+'","database_pledge_id":"" , "source_code":"110011", "parish_id":"10","sf_api_call":"0" }';
                }else{
                    StringJson = '{"token":"'+AccessToken+'" ,"Api_Link":"'+Label.UpdateRecurringApi+'/'+SignupIdVal+'","gcid":"'+gcid+'","payment_frequency":"'+payment_frequency1+'","payment_start_date":"'+payment_start_date+'","payment_end_date":"'+EndDateVal+'","amount":"'+amount+'","donor_payment_method_id":"'+PmtidVal1+'","never_end_date":"false","custom_field_id": "","custom_field_value": "","sf_api_call":"0"}';
                }
                 Http http = new Http();
                 HttpRequest req = new HttpRequest();
                //req.setTimeout(120000);
                 req.setMethod('POST');
                 req.setEndpoint('http://sfdc.myworkforce.org/SalesforceAPICall/GePatchRecord');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 //req.setHeader('Authorization', 'Bearer '+AccessToken[0]); 
                 //req.setHeader('X-HTTP-Method-Override','PATCH');
                 req.setBody(StringJson);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser errParserResult =JSON.createParser(strRes);
                system.debug(StringJson);
                system.debug(ResCreate);
                system.debug(strRes);
                
                //-----------------------------------------------------
                String StatusErrRes;
                System.JSONParser parserRes = System.JSON.createParser(strRes);
                while (parserRes.nextToken() != System.JSONToken.END_OBJECT) {
                    if (parserRes.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                        String text = parserRes.getText();
                        if (parserRes.nextToken() != System.JSONToken.VALUE_NULL) {
                    		 if (text == 'status') {
                                 StatusErrRes = String.ValueOf(parserRes.getText());
                             }
                        }
                    }
                }
                //--------------------------------------------------------------
                
                if(StatusErrRes !='422'){
                    //system.debug('dddddf');
                    if(ResCreate.getStatusCode() == 200){
                        //system.debug('update');
                        JSONParser parserResult =JSON.createParser(strRes);
                        JSONParser parserResultAmount =JSON.createParser(strRes);
                        List<String> DonorSignup=new List<String>();
                        List<String> RecAmount=new List<String>();
                        while(parserResult.nextToken() != null){
                            if ((parserResult.getText() == 'donor_events_id')) {
                                //----------------Get the value.
                                parserResult.nextToken();
                                DonorSignup.add(parserResult.getText());
                            }
                        } 
                        while(parserResultAmount.nextToken() != null){
                            if ((parserResultAmount.getText() == 'amount')) {
                                //----------------Get the value.
                                parserResultAmount.nextToken();
                                RecAmount.add(parserResultAmount.getText());
                            }
                        }
                        List<String> TransactionDate=new List<String>();
                        List<String> DonorPaymentScheduleId=new List<String>();
                        List<String>  processResultPmt =new List<String>();
                        List<String>  processResultDate =new List<String>();
                        List<String>  AmountVal =new List<String>();
                        List<String>  statusVal =new List<String>();
                        JSONParser parserResult1 =JSON.createParser(strRes);
                        while(parserResult1.nextToken() != null){
                            if (parserResult1.getText() == 'processedSchedules') {
                                while(parserResult1.nextToken()!= JSONToken.END_ARRAY) {
                                    if(parserResult1.getCurrentToken() == JSONToken.FIELD_NAME) {
                                        parserResult1.nextValue();
                                        if(parserResult1.getCurrentName() == 'DonorPaymentScheduleId') {
                                            DonorPaymentScheduleId.add(parserResult1.getText());
                                            processResultPmt.add(parserResult1.getText());
                                        }else if(parserResult1.getCurrentName() == 'TransactionDate'){
                                            TransactionDate.add(parserResult1.getText());
                                            processResultDate.add(parserResult1.getText());
                                        }else if(parserResult1.getCurrentName() == 'Status'){
                                            statusVal.add(parserResult1.getText());
                                        }else if(parserResult1.getCurrentName() == 'Amount'){
                                            AmountVal.add(parserResult1.getText());
                                        }    
                                    } 
                                }
                            }
                           
                            if (parserResult1.getText() == 'schedules') {
                                while(parserResult1.nextToken()!= JSONToken.END_ARRAY) {
                                    if(parserResult1.getCurrentToken() == JSONToken.FIELD_NAME) {
                                        parserResult1.nextValue();
                                        if(parserResult1.getCurrentName() == 'DonorPaymentScheduleId') {
                                            DonorPaymentScheduleId.add(parserResult1.getText());
                                        }else if(parserResult1.getCurrentName() == 'TransactionDate'){
                                            TransactionDate.add(parserResult1.getText());
                                        }else if(parserResult1.getCurrentName() == 'Amount'){
                                            AmountVal.add(parserResult1.getText());
                                        }else if(parserResult1.getCurrentName() == 'Status'){
                                            statusVal.add(parserResult1.getText());
                                        }    
                                    } 
                                }
                            }
                        }
                        
                         //system.debug(DonorPaymentScheduleId);
                         //   system.debug(processResultPmt);
                        
                        Map<string,string> mapSchRes = new map<string,String>();
                        for(Integer i=0;i<DonorPaymentScheduleId.size();i++){ 
                            mapSchRes.put(TransactionDate[i],DonorPaymentScheduleId[i]);
                        }
                        
                        Map<string,string> mapProcessRes = new map<string,String>();
                        for(Integer i=0;i<processResultPmt.size();i++){ 
                            mapProcessRes.put(processResultDate[i],processResultPmt[i]);
                        }
                        
                        Map<string,string> mapStatus = new map<string,String>();
                        for(Integer i=0;i<statusVal.size();i++){ 
                            mapStatus.put(processResultDate[i],statusVal[i]);
                        }
                        //system.debug(mapSchRes);
                        //system.debug(mapProcessRes);
                        
                        List<npe03__Recurring_Donation__c> updateSignup = new List<npe03__Recurring_Donation__c>();
                        List<npe03__Recurring_Donation__c> DataRec = [select Id,GcSignupId__c,GC_Installment_Amount__c from npe03__Recurring_Donation__c where Id=:idVal];
                        for(npe03__Recurring_Donation__c objRec:DataRec){
                            objRec.GcSignupId__c = Decimal.valueOf(DonorSignup[0]);
                            objRec.GC_Installment_Amount__c = String.valueOf(RecAmount[0]);
                            updateSignup.add(objRec);
                        }
                        //system.debug(updateSignup);
                        updation.isfutureupdate = true;
                        if(updateSignup.size() > 0){
                            update updateSignup;
                        }
                        //system.debug('sdasasdasd');                        
                         //Insert opprtunity-------------------------------------------------------------
                        
                        List<Opportunity> SobjLst = [select Id from Opportunity where npe03__Recurring_Donation__c =:idVal];
						delete SobjLst;
                        
                    	Opportunity[] accts = new List<Opportunity>();
                        Integer countOpp = DonorPaymentScheduleId.size();
                        
                    	for(Integer i=0;i<countOpp;i++) {
                            String mapValProcess = mapProcessRes.get(String.valueOf(TransactionDate[i]));
                            String processVal='No';
                            if(mapValProcess !=Null){
                                processVal ='Yes';
                            }
                            String mapValStatus = mapStatus.get(String.valueOf(TransactionDate[i]));
                            String StageNameVal='Pledged';
                            if(mapValStatus !=Null){
                                if(mapValStatus == 'declined'){
                                    StageNameVal ='Closed Lost'; 
                                }
                                if(mapValStatus == 'Success'){
                                    StageNameVal ='Closed Won'; 
                                }
                            }
                            Integer iVal = i+1;
                            Opportunity con = new Opportunity(
                            Name=donorName+' Donation ('+countOpp+' of '+iVal+') '+TransactionDate[i],
                            npsp__Primary_Contact__c=donorAutoid,
                            CampaignId=EventAutoid,
                            npe03__Recurring_Donation__c=CampAutoId,
                            Amount=Decimal.valueOf(AmountVal[i]),
                            StageName=StageNameVal,
                            CloseDate=Date.valueOf(TransactionDate[i]),
                            GcSignupId__c=Decimal.valueOf(DonorSignup[0]),
                            GcScheduleId__c = Decimal.valueOf(DonorPaymentScheduleId[i]),
                            Is_process__c = processVal);
                            accts.add(con);
                        }
                    
                    	if(accts.size() > 0){
                            Insert accts;
                        }

                    //------------------------------------------------------------------------------
                        
                        List<Opportunity> DeleteDataOppSch = [select Id,GcSignupId__c,GcScheduleId__c,CloseDate from Opportunity where GcSignupId__c =:Decimal.valueOf(DonorSignup[0]) and GcScheduleId__c =:null];
                        if(DeleteDataOppSch.size() > 0){
                            Delete DeleteDataOppSch;
                        }
                    }
                    String valRes = String.valueOf(ResCreate.getStatusCode());
                }else{
                    String pmtError ='';
                    String DateError ='';
                    String eventError = '';
                    //----------------------------------------------------
                    System.JSONParser parser = System.JSON.createParser(strRes);
                    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                            String texts = parser.getText();
                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                if (texts == 'result') {          
                    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                            String text = parser.getText();
                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                 if (text == 'detail') {
                                    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                            String text1 = parser.getText();
                                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                if (text1 == 'validation_messages') {
                                                   while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                                            String text3 = parser.getText();
                                                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                                if (text3 == 'donor_payment_method_id') {
                                                                    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                                                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                                                            String text2 = parser.getText();
                                                                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                                                if (text2 == 'invalidPaymentMethod') {
                                                                                    pmtError = parser.getText();
                                                                                } 
                                                                            }
                                                                        }
                                                                    }
                                                                }else if(text3 == 'payment_start_date'){
                                                                    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                                                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                                                            String text4 = parser.getText();
                                                                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                                                if (text4 == 'lessThanTodayDate') {
                                                                                    DateError = parser.getText();
                                                                                } 
                                                                            }
                                                                        }
                                                                    }
                                                                } 
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                                }
                            }
                        }
                    }
                //---------------------------------------------
                    
                }
            }else{
             String StringJsonVal = '';
            if(ScheduleType=='Divide By'){
             StringJsonVal = '{"event_id":"'+GcEventId+'","donor_type":"User","gcid":"'+gcid+'","payment_frequency":"'+payment_frequency1+'","payment_start_date":"'+payment_start_date+'","pledge_amount":"'+pledge_amount+'","pledge_creation_date":"'+pledge_creation_date+'","payment_end_date":"'+payment_end_date+'","amount":"'+amount+'","donor_payment_method_id":"'+PmtidVal1+'","never_end_date":"false","session_id":"","cartId":"","custom_field_id": "","custom_field_value": "","device_type":"Web","no_payment":"no","memo":"","database_pledge_id":"" , "source_code":"110011", "parish_id":"10" ,"sf_api_call":"0"}';
        
            }else{
               // mylist.add('{"event_id":"'+GcEventId+'","donor_type":"User","gcid":"'+gcid+'","payment_frequency":"'+payment_frequency1+'","payment_start_date":"'+payment_start_date+'","payment_end_date":"'+EndDateVal+'","amount":"'+amount+'","donor_payment_method_id":"'+PmtidVal1+'","never_end_date":"false","session_id":"","cartId":"","custom_field_id": "","custom_field_value": "","device_type":"Web","memo":"","allowAllStatus":""}');
            	 StringJsonVal = '{"event_id":"'+GcEventId+'","donor_type":"User","gcid":"'+gcid+'","payment_frequency":"'+payment_frequency1+'","payment_start_date":"'+payment_start_date+'","payment_end_date":"'+EndDateVal+'","amount":"'+amount+'","donor_payment_method_id":"'+PmtidVal1+'","never_end_date":"false","session_id":"","cartId":"","custom_field_id": "","custom_field_value": "","device_type":"Web","memo":"","allowAllStatus":"","sf_api_call":"0"}';
            }
            //system.debug(mylist);
                //system.debug(AccessToken);
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Label.NewRecurringApi);
            req.setTimeout(120000);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Authorization', 'Bearer '+AccessToken);  
            req.setBody(StringJsonVal);
            HttpResponse ResCreate = http.send(req);
            string strRes=ResCreate.getBody();
                system.debug(StringJsonVal);
                system.debug(ResCreate);
             	system.debug(strRes);
                
            if(ResCreate.getStatusCode() !=422){    
                if(ResCreate.getStatusCode() == 201){
                   
                    JSONParser parserResult =JSON.createParser(strRes);
                    JSONParser parserResultAmount =JSON.createParser(strRes);
                    List<String> DonorSignup=new List<String>();
                    List<String> RecAmount=new List<String>();
                    while(parserResult.nextToken() != null){
                        if ((parserResult.getText() == 'donor_events_id')) {
                            //----------------Get the value.
                            parserResult.nextToken();
                            DonorSignup.add(parserResult.getText());
                        }
                    }
                    while(parserResultAmount.nextToken() != null){
                        if ((parserResultAmount.getText() == 'amount')) {
                            //----------------Get the value.
                            parserResultAmount.nextToken();
                            RecAmount.add(parserResultAmount.getText());
                        }
                    }
                    //system.debug(DonorSignup);
                    List<String> TransactionDate=new List<String>();
                    List<String> DonorPaymentScheduleId=new List<String>();
                    List<String> AmountVal =new List<String>();
                    List<String> TransactionDateVal = new List<String>();
                    List<String>  processResultPmt =new List<String>();
                    List<String>  processResultDate =new List<String>();
                    List<String>  statusVal =new List<String>();
                    List<String> TransactionDateSucc = new List<String>();
                    JSONParser parserResult1 =JSON.createParser(strRes);
                    while(parserResult1.nextToken() != null){
                        if (parserResult1.getText() == 'processedSchedules') {
                            while(parserResult1.nextToken()!= JSONToken.END_ARRAY) {
                                if(parserResult1.getCurrentToken() == JSONToken.FIELD_NAME) {
                                    parserResult1.nextValue();
                                    if(parserResult1.getCurrentName() == 'DonorPaymentScheduleId') {
                                        DonorPaymentScheduleId.add(parserResult1.getText());
                                        processResultPmt.add(parserResult1.getText());
                                    }else if(parserResult1.getCurrentName() == 'TransactionDate'){
                                        TransactionDate.add(parserResult1.getText());
                                        processResultDate.add(parserResult1.getText());
                                    }else if(parserResult1.getCurrentName() == 'Status'){
                                        statusVal.add(parserResult1.getText());
                                    }else if(parserResult1.getCurrentName() == 'Amount'){
                                        AmountVal.add(parserResult1.getText());
                                    }    
                                } 
                            }
                        }
                        
                        if (parserResult1.getText() == 'schedules') {
                            while(parserResult1.nextToken()!= JSONToken.END_ARRAY) {
                                if(parserResult1.getCurrentToken() == JSONToken.FIELD_NAME) {
                                    parserResult1.nextValue();
                                    if(parserResult1.getCurrentName() == 'DonorPaymentScheduleId') {
                                        DonorPaymentScheduleId.add(parserResult1.getText());
                                    }else if(parserResult1.getCurrentName() == 'TransactionDate'){
                                        TransactionDate.add(parserResult1.getText());
                                        TransactionDateSucc.add(parserResult1.getText());
                                    }else if(parserResult1.getCurrentName() == 'Amount'){
                                        AmountVal.add(parserResult1.getText());
                                    }else if(parserResult1.getCurrentName() == 'Status'){
                                        statusVal.add(parserResult1.getText());
                                    }   
                                } 
                            }
                        }
                    }
                    
                    //system.debug(DonorPaymentScheduleId);
                    system.debug(TransactionDate);
                    
                    Map<string,string> mapSchRes = new map<string,String>();
                    for(Integer i=0;i<DonorPaymentScheduleId.size();i++){ 
                        mapSchRes.put(TransactionDate[i],DonorPaymentScheduleId[i]);
                    }
                    
                    Map<string,string> mapProcessRes = new map<string,String>();
                    for(Integer i=0;i<processResultPmt.size();i++){ 
                        mapProcessRes.put(processResultDate[i],processResultPmt[i]);
                    }
                    Map<string,string> mapStatus = new map<string,String>();
                        for(Integer i=0;i<statusVal.size();i++){ 
                            mapStatus.put(processResultDate[i],statusVal[i]);
                        }
                    //system.debug(mapSchRes);
                    
                    system.debug(TransactionDateSucc);
                   system.debug(Date.valueOf(TransactionDateSucc[0]).month());
                    
                    List<npe03__Recurring_Donation__c> updateSignup = new List<npe03__Recurring_Donation__c>();
                    List<npe03__Recurring_Donation__c> DataRec = [select Id,GcSignupId__c,GC_Installment_Amount__c,npe03__Next_Payment_Date__c from npe03__Recurring_Donation__c where Id=:idVal];
                    for(npe03__Recurring_Donation__c objRec:DataRec){
                        objRec.GcSignupId__c = Decimal.valueOf(DonorSignup[0]);
                        objRec.GC_Installment_Amount__c = String.valueOf(RecAmount[0]);
                        
                        Integer mnth = Date.valueOf(TransactionDateSucc[0]).month();
                        Integer dy = Date.valueOf(TransactionDateSucc[0]).day();
                        Integer yr = Date.valueOf(TransactionDateSucc[0]).Year();
                        date myDate = date.newInstance(yr, mnth, dy);
                        //system.debug(myDate);
                        //objRec.npe03__Next_Payment_Date__c = Date.valueOf(mnth+'/'+dy+'/'+yr);
                        updateSignup.add(objRec);
                    }
                    system.debug(updateSignup);
                    updation.isfutureupdate = true;
                    if(updateSignup.size() > 0){
                        update updateSignup;
                    }
                   
                    //--------------------------Delete-------------------------
                    
                    List<Opportunity> SobjLst = [select Id from Opportunity where npe03__Recurring_Donation__c =:idVal];
					delete SobjLst;
                    
                    //-----------------------------------------------
                    //system.debug('sdasasdasd');
                    //Insert opprtunity-------------------------------------------------------------
                    	Opportunity[] accts = new List<Opportunity>();
                        Integer countOpp = DonorPaymentScheduleId.size();
                    	for(Integer i=0;i<countOpp;i++) {
                            String mapValProcess = mapProcessRes.get(String.valueOf(TransactionDate[i]));
                            String processVal='No';
                            if(mapValProcess !=Null){
                                processVal ='Yes';
                            }
                            String mapValStatus = mapStatus.get(String.valueOf(TransactionDate[i]));
                            String StageNameVal='Pledged';
                            if(mapValStatus !=Null){
                                if(mapValStatus == 'declined'){
                                    StageNameVal ='Closed Lost'; 
                                }
                                if(mapValStatus == 'Success'){
                                    StageNameVal ='Closed Won'; 
                                }
                            }
                            Integer iVal = i+1;
                            Opportunity con = new Opportunity(
                            Name=donorName+' Donation ('+countOpp+' of '+iVal+') '+TransactionDate[i],
                            npsp__Primary_Contact__c=donorAutoid,
                            CampaignId=EventAutoid,
                            npe03__Recurring_Donation__c=CampAutoId,
                            Amount=Decimal.valueOf(AmountVal[i]),
                            StageName=StageNameVal,
                            CloseDate=Date.valueOf(TransactionDate[i]),
                            GcSignupId__c=Decimal.valueOf(DonorSignup[0]),
                            GcScheduleId__c = Decimal.valueOf(DonorPaymentScheduleId[i]),
                            Is_process__c = processVal);
                            accts.add(con);
                        }
                    
                    	if(accts.size() > 0){
                            Insert accts;
                        }

                    //------------------------------------------------------------------------------
                }

            }else{
                String pmtError ='';
                String DateError ='';
                String eventError='';
                    //----------------------------------------------------
                System.JSONParser parser = System.JSON.createParser(strRes);
                while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                        String text = parser.getText();
                        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    		 if (text == 'detail') {
                                while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                        String text1 = parser.getText();
                                        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                            if (text1 == 'validation_messages') {
                                               while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                                    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                                        String text3 = parser.getText();
                                                        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                            if (text3 == 'donor_payment_method_id') {
                                                                while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                                                    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                                                        String text2 = parser.getText();
                                                                        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                                            if (text2 == 'invalidPaymentMethod') {
                                                                                pmtError = parser.getText();
                                                                            } 
                                                                        }
                                                                    }
                                                                }
                                                            }else if(text3 == 'payment_start_date'){
                                                                    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                                                        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                                                            String text4 = parser.getText();
                                                                            if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                                                                if (text4 == 'lessThanTodayDate') {
                                                                                    DateError = parser.getText();
                                                                                } 
                                                                            }
                                                                        }
                                                                    }
                                                                }  
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                //---------------------------------------------
                } 
        }  
        }catch(exception e){
            system.debug(String.valueOf(e));            
        }
    }
}