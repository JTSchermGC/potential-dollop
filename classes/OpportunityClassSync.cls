public class OpportunityClassSync {
	@AuraEnabled
    public static List<String> OpportunityData(Id idVal){
        try{
            system.debug('tetttttttt'+ idVal);
            String AccessToken = '';
            AccessToken = GetGcToken.TokenData();
            system.debug(AccessToken);
            Opportunity[] OppData=[select Id,GcSignupId__c,GcScheduleId__c,npe03__Recurring_Donation__c,npsp__Primary_Contact__c,Amount,CloseDate from Opportunity where Id =:idVal];
            Contact[] ContactData=[select Id,Donor_Id__c from Contact where Id =:OppData.get(0).npsp__Primary_Contact__c];
            string ReccuringId = string.valueOf(OppData.get(0).npe03__Recurring_Donation__c);
            npe03__Recurring_Donation__c[] CampQuery = [select Id,DonorPaymentMethod__c,GcSignupId__c from npe03__Recurring_Donation__c where Id=:ReccuringId];
            String PMTId = CampQuery.get(0).DonorPaymentMethod__c;
            string donorEventsId = (string.valueOf(CampQuery.get(0).GcSignupId__c) == null) ? '' : string.valueOf(CampQuery.get(0).GcSignupId__c);

            DonorPaymentMethod__c[] PMTData = [select donor_payment_method_id__c from DonorPaymentMethod__c where Id=:PMTId];
            String PMTDataVal = string.valueOf(PMTData.get(0).donor_payment_method_id__c);
            string donorPaymentScheduleId = string.valueOf(OppData.get(0).GcScheduleId__c);
            //string donorEventsId = (string.valueOf(OppData.get(0).GcSignupId__c) == null) ? '' : string.valueOf(OppData.get(0).GcSignupId__c);
            string gcid = (string.valueOf(ContactData.get(0).Donor_Id__c) == null) ? '' : string.valueOf(ContactData.get(0).Donor_Id__c);
			string amount = (string.valueOf(OppData.get(0).Amount) == null) ? '' : string.valueOf(OppData.get(0).Amount);
			string dateVal = (string.valueOf(OppData.get(0).CloseDate) == null) ? '' : string.valueOf(OppData.get(0).CloseDate);
            
            String paymentScheduleId = '';
            if(donorPaymentScheduleId!=Null){
                paymentScheduleId = ',"donorPaymentScheduleId":"'+donorPaymentScheduleId+'"';
            }else{
                
            }
            
            String PostString='{"sfEventType":"editPaymentSchedule","sfId":"'+idVal+'","donorEventsId":"'+donorEventsId+'","editAllSchedule":"false","gcid":"'+gcid+'","amount":"'+amount+'"'+paymentScheduleId+',"date":"'+dateVal+'","donorPaymentMethodId":"'+PMTDataVal+'"}';
            system.debug(PostString);
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Label.UpdateOpp);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Authorization', 'Bearer '+AccessToken);  
            req.setBody(PostString);
            HttpResponse ResCreate = http.send(req);
            string strRes=ResCreate.getBody();
            system.debug(PostString);
            system.debug(ResCreate);
            system.debug(strRes);
            
            	JSONParser parserResult =JSON.createParser(strRes);
                List<String> payment_schedule_id=new List<String>();
                while(parserResult.nextToken() != null){
                    if ((parserResult.getText() == 'donor_payment_schedule_id')) {
                        //----------------Get the value.
                        parserResult.nextToken();
                        payment_schedule_id.add(parserResult.getText());
                    }
                }
            
            List<Opportunity> updateOpp = new List<Opportunity>();
            List<Opportunity> DataRec = [select Id,GcScheduleId__c from Opportunity where Id=:idVal];
            for(Opportunity objRec:DataRec){
                objRec.GcScheduleId__c = Decimal.valueOf(payment_schedule_id[0]);                
                updateOpp.add(objRec);
            }
            
            
            String valRes = String.valueOf(ResCreate.getStatusCode());
            List<string> returnstr = new List<string>();
            returnstr.add(valRes);
            
            String [] storeData = new List<String>();
            storeData.add('Opportunity');
            storeData.add(strRes);
            storeData.add(string.valueOf(idVal));
            storeData.add(string.valueOf(ResCreate.getStatusCode()));
            ErrorLogClass.ErrorLogClass(storeData);
            
            return returnstr;
        }catch(exception e){
            system.debug(String.valueOf(e));
            List<string> returnstr = new List<string>();
            returnstr.add('Issue');
            return returnstr;
        }
    }
}