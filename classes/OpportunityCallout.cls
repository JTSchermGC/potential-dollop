public class OpportunityCallout {
    @Future(callout=true)
	public static Void OpportunityData(List<Id> idVal){
        try{
            system.debug(idVal);
            String AccessToken = GetGcToken.TokenData();
            Opportunity[] OppData=[select Id,GcSignupId__c,GcScheduleId__c,npe03__Recurring_Donation__c,npsp__Primary_Contact__c,Amount,CloseDate from Opportunity where Id =:idVal];
            Contact[] ContactData=[select Id,Donor_Id__c from Contact where Id =:OppData.get(0).npsp__Primary_Contact__c];
            string ReccuringId = string.valueOf(OppData.get(0).npe03__Recurring_Donation__c);
            npe03__Recurring_Donation__c[] CampQuery = [select Id,DonorPaymentMethod__c from npe03__Recurring_Donation__c where Id=:ReccuringId];
            String PMTId = CampQuery.get(0).DonorPaymentMethod__c;
            DonorPaymentMethod__c[] PMTData = [select donor_payment_method_id__c from DonorPaymentMethod__c where Id=:PMTId];
            String PMTDataVal = string.valueOf(PMTData.get(0).donor_payment_method_id__c);
            string donorPaymentScheduleId = string.valueOf(OppData.get(0).GcScheduleId__c);
            string donorEventsId = (string.valueOf(OppData.get(0).GcSignupId__c) == null) ? '' : string.valueOf(OppData.get(0).GcSignupId__c);
            string gcid = (string.valueOf(ContactData.get(0).Donor_Id__c) == null) ? '' : string.valueOf(ContactData.get(0).Donor_Id__c);
			string amount = (string.valueOf(OppData.get(0).Amount) == null) ? '' : string.valueOf(OppData.get(0).Amount);
			string dateVal = (string.valueOf(OppData.get(0).CloseDate) == null) ? '' : string.valueOf(OppData.get(0).CloseDate);
            
            String PostString='{"donorEventsId":"'+donorEventsId+'","editAllSchedule":"false","gcid":"'+gcid+'","amount":"'+amount+'","donorPaymentScheduleId":"'+donorPaymentScheduleId+'","date":"'+dateVal+'","donorPaymentMethodId":"'+PMTDataVal+'"}';
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Label.GcURL+'editPaymentSchedule');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Authorization', 'Bearer '+AccessToken);  
            req.setBody(PostString);
            HttpResponse ResCreate = http.send(req);
            string strRes=ResCreate.getBody();
            JSONParser parserResult =JSON.createParser(strRes);
            system.debug(PostString);
            system.debug(ResCreate);
            system.debug(strRes);
            String valRes = String.valueOf(ResCreate.getStatusCode()); 
        }catch(exception e){
            system.debug(String.valueOf(e));
        }
        
    }
}