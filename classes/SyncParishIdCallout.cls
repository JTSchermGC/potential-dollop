public class SyncParishIdCallout {
    @Future(callout=true)
	public static Void ParishSyncData(List<Id> idVal) {
       system.debug('saxasdad');
        List<string> SetContactId = new List<string>();
        account[] donorData = [select Id,Parish_ID__c,Name,BillingPostalCode from account where Id=:idVal];
        string ParishID = (donorData.get(0).Parish_ID__c == null) ? '' : donorData.get(0).Parish_ID__c;
        string Name = (donorData.get(0).Name == null) ? '' : donorData.get(0).Name;
        string BillingPostalCode =  (donorData.get(0).BillingPostalCode == null) ? '' : donorData.get(0).BillingPostalCode;    
        
        if(ParishID != '' && ParishID != Null){
            String AccessToken = GetGcToken.TokenData();
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Label.GcURL+'parishid');
            req.setTimeout(120000);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Authorization', 'Bearer '+AccessToken);  
            req.setBody('{"parishnumber":"'+ParishID+'","parishname":"'+Name+'","zip":"'+BillingPostalCode+'"}');
            HttpResponse ResCreate = http.send(req);
            string strRes=ResCreate.getBody();
            //system.debug(ResCreate);
            system.debug(strRes);
        }
    }
}