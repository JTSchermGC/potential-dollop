public class SyncEventCallout {
    @Future(callout=true)
	public static Void EventDataCallout(List<Id> idVal) {
             Campaign[] eventData1 = [SELECT Name FROM Campaign where Id=:idVal];
             if(eventData1.get(0).Name !='EventName1'){
			 String AccessToken = GetGcToken.TokenData();
             List<string> SetContactId = new List<string>();
             Campaign[] eventData = [SELECT Id,gc_event_id__c,Name,StartDate,EndDate,Type,ActualCost,Status,BudgetedCost,minimumAmounts__c,suggestedAmount__c,Merchant_Id__c FROM Campaign where Id=:idVal];
             String MIDVal = eventData.get(0).Merchant_Id__c;
             Merchant_Id__c[] merchantData = [SELECT Id,MID__c FROM Merchant_Id__c where Id=:MIDVal];
             String MerchantId = string.valueOf(merchantData.get(0).MID__c);
             
             string GcEventId = (string.valueOf(eventData.get(0).gc_event_id__c) == null) ? '' : string.valueOf(eventData.get(0).gc_event_id__c);
             string eventTitle = (eventData.get(0).Name == null) ? '' : eventData.get(0).Name;
             string eventStartDate = (string.valueOf(eventData.get(0).StartDate) == null) ? '' : string.valueOf(eventData.get(0).StartDate);
             string eventEndDate = (string.valueOf(eventData.get(0).EndDate) == null) ? '' : string.valueOf(eventData.get(0).EndDate);
             string eventType = (eventData.get(0).Type == null) ? '' : eventData.get(0).Type;
             string ticketAmount =  (string.valueOf(eventData.get(0).ActualCost) == null) ? '' : string.valueOf(eventData.get(0).ActualCost);
             string eventStatus = (eventData.get(0).Status == null) ? '' : eventData.get(0).Status;
             string suggestedAmount = (string.valueOf(eventData.get(0).suggestedAmount__c) == null) ? '' : string.valueOf(eventData.get(0).suggestedAmount__c);
             string minimumAmounts = (string.valueOf(eventData.get(0).minimumAmounts__c) == null) ? '' : string.valueOf(eventData.get(0).minimumAmounts__c);

             if(GcEventId !=Null && GcEventId !=''){
                 system.debug(MerchantId);
                 //-------------Edit Doner Api Call-------------------------------------------------------
                 String CampStringNormal = '{"token":"'+AccessToken+'" ,"Api_Link":"'+Label.GcURL+'events'+'/'+GcEventId+'","eventTitle":"'+eventTitle+'","eventStartDate":"'+eventStartDate+'","eventEndDate":"'+eventEndDate+'","eventType":"'+eventType+'","eventFrequency":["Monthly","One-Time","Weekly","Bi-Weekly","Quarterly","Semi-Annually","Annually"],"minimumAmounts":["'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'"],"suggestedAmount":["'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'"],"accountsMerchantId":"'+MerchantId+'","displayOrder":"0","categoryId":"0","eventStatus":"'+eventStatus+'","restrictDonationsBeyondEndDate":"0"}';
				 system.debug(CampStringNormal);
                 Http http = new Http();
                 HttpRequest req = new HttpRequest();
                 req.setMethod('POST');
                 req.setEndpoint(Label.ApiCallUrl+'SalesforceAPICall/GePatchRecord');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 //req.setHeader('Authorization', 'Bearer '+AccessToken[0]); 
                 //req.setHeader('X-HTTP-Method-Override','PATCH');
                 req.setBody(CampStringNormal);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser errParserResult =JSON.createParser(strRes);
                 system.debug(ResCreate);
                 system.debug(strRes);
                 
                 String valRes='';
                 if(ResCreate.getStatusCode() != 200){
                   /*
                     List<String> errStatus=new List<String>();
                     while(errParserResult.nextToken() != null){
                         if ((errParserResult.getText() == 'errorstatus')) {
                             //----------------Get the value.
                             errParserResult.nextToken();
                             errStatus.add(errParserResult.getText());
                         }
                     }
                     
                     Jsonconverterone ErrVall = Jsonconverterone.parse(strRes);
                     //system.debug(ErrVall);
                     String ErrMerchant='';
                     if(ErrVall.detail.validation_messages.accountsMerchantId!=null){
                     	 ErrMerchant = ErrVall.detail.validation_messages.accountsMerchantId.invalidMerchantId;
                 	 }
                     
                     valRes = String.valueOf(errStatus[0]); 
                     List<string> returnstr = new List<string>();
                     */
                     String [] storeData = new List<String>();
                     storeData.add('Event');
                     storeData.add(strRes);
                     storeData.add(string.valueOf(idVal));
                     storeData.add(string.valueOf(ResCreate.getStatusCode()));
                     ErrorLogClass.ErrorLogClass(storeData);
                 }else{
                     //valRes = String.valueOf(ResCreate.getStatusCode());
                     //List<string> returnstr1 = new List<string>();
                     
                 }
                 //system.debug(errStatus[0]);
                 
             }else{
                 String CampStringNormal = '{"eventTitle":"'+eventTitle+'","eventStartDate":"'+eventStartDate+'","eventEndDate":"'+eventEndDate+'","eventType":"'+eventType+'","eventFrequency":["Monthly","One-Time","Weekly","Bi-Weekly","Quarterly","Semi-Annually","Annually"],"minimumAmounts":["'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'","'+minimumAmounts+'"],"suggestedAmount":["'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'","'+suggestedAmount+'"],"accountsMerchantId":"'+MerchantId+'","displayOrder":"0","categoryId":"0","eventStatus":"'+eventStatus+'","restrictDonationsBeyondEndDate":"0","sf_api_call":"0"}';
				 system.debug(CampStringNormal);
                 Http http = new Http();
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(Label.GcURL+'events');
                 req.setMethod('POST');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 req.setHeader('Authorization', 'Bearer '+AccessToken);  
                 req.setBody(CampStringNormal);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser parserResult =JSON.createParser(strRes);
                 
                 system.debug(ResCreate);
                 system.debug(strRes);
                 if(ResCreate.getStatusCode() == 201){
                     List<String> event_id=new List<String>();
                     while(parserResult.nextToken() != null){
                         if ((parserResult.getText() == 'event_id')) {
                             //----------------Get the value.
                             parserResult.nextToken();
                             event_id.add(parserResult.getText());
                         }
                     } 
                     
                    List<Campaign> updateId = new List<Campaign>(); 
                    List<Campaign> eventIds = [select Id,gc_event_id__c from Campaign where Id=:idVal];
                    for(Campaign objUpdate: eventIds){
                        objUpdate.gc_event_id__c = decimal.valueOf(event_id[0]);
                        updateId.add(objUpdate);
                    }
                     //system.debug(updateId);
                     updation.isfutureupdate = true;
                     if(updateId.size() > 0){
                         update updateId;
                     }
                     
                     String valRes = String.valueOf(ResCreate.getStatusCode()); 
                     
                 }else{
                     /*
                     system.debug('ssssss');
                     Jsonconverterone ErrVall = Jsonconverterone.parse(strRes);
                     system.debug(ErrVall);
                     String ErrMerchant='';
                     if(ErrVall.detail.validation_messages.accountsMerchantId!=null){
                     	 ErrMerchant = ErrVall.detail.validation_messages.accountsMerchantId.invalidMerchantId;
                 	 }
                     system.debug(ErrMerchant);
                     String valRes = String.valueOf(ResCreate.getStatusCode());
					*/
                     String [] storeData = new List<String>();
                     storeData.add('Event');
                     storeData.add(strRes);
                     storeData.add(string.valueOf(idVal));
                     storeData.add(string.valueOf(ResCreate.getStatusCode()));
                     ErrorLogClass.ErrorLogClass(storeData);
                 }
                 	
             }
}
    }
}