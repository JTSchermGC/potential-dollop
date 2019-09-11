public class GCDeleteAPI {
	 @Future(callout=true)
	public static Void DeleteCallout(List<Id> idVal) {
//-------------Get GC Token------------------------------------------------------------------------------ 
             String AccessToken = GetGcToken.TokenData();  
//-----------End GC Token Code-----------------------------------------------------------------------------------------------             
//-----------Get New Doner Details-----------------------------------------------------------------------------------------------                          
             List<string> SetContactId = new List<string>();
             npe03__Recurring_Donation__c[] recurringData = [select Id,GcSignupId__c from npe03__Recurring_Donation__c where Id=:idVal];
                 //-----------New Donor Api Call ---------------------------------------------------------------
        	string passingParameter=string.valueOf(recurringData[0].GcSignupId__c); 
        	if(passingParameter!=''){
                Http http = new Http();
             	 string parameter ='';
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(Label.GcURL+'signups/'+passingParameter);
                 //req.setEndpoint(Label.Delete_GC_Recurring+passingParameter);
                 req.setTimeout(120000);
                 req.setMethod('DELETE');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 req.setHeader('Authorization', 'Bearer '+AccessToken);  
                 req.setBody(parameter);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser parserResult =JSON.createParser(strRes);
                 
                 //system.debug(stringjson);
                 system.debug(strRes);
                 system.debug(ResCreate);
                 if(ResCreate.getStatusCode() == 201){
                     List<String> gcid=new List<String>();
                 }    
             }else{
                 
             }
                     
    }
    @Future(callout=true)
	public static Void DeleteOpporCallout(string idVal,string gcid_val) {
//-------------Get GC Token------------------------------------------------------------------------------ 
             String AccessToken = GetGcToken.TokenData();  
             Http http = new Http();
//-----------End GC Token Code-----------------------------------------------------------------------------------------------             

                 //-----------New Donor Api Call ---------------------------------------------------------------
        	string passingParameter=idVal; 
        	if(passingParameter!='' && gcid_val!=''){
             	 String PostString='{"editAllSchedule":"false","gcid":"'+gcid_val+'"}';
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(Label.GcURL+'editPaymentSchedule'+'/'+passingParameter);
                 req.setTimeout(120000);
                 req.setMethod('DELETE');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 req.setHeader('Authorization', 'Bearer '+AccessToken);  
                 req.setBody(PostString);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser parserResult =JSON.createParser(strRes);
                 
                 //system.debug(stringjson);
                 system.debug(strRes);
                 system.debug(ResCreate);
                 if(ResCreate.getStatusCode() == 201){
                     List<String> gcid=new List<String>();
                 }    
             }else{
                 
             }
                     
    }
        @Future(callout=true)
	public static Void DeleteContactCallout(string idVal) {
//-------------Get GC Token------------------------------------------------------------------------------ 
             String AccessToken = GetGcToken.TokenData();  
             Http http = new Http();
//-----------End GC Token Code-----------------------------------------------------------------------------------------------             

                 //-----------New Donor Api Call ---------------------------------------------------------------
        	string passingParameter=idVal; 
        	if(passingParameter!=''){
             	 String PostString='';
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(Label.GcURL+'donor'+'/'+passingParameter);
                 req.setTimeout(120000);
                 req.setMethod('DELETE');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 req.setHeader('Authorization', 'Bearer '+AccessToken);  
                 req.setBody(PostString);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser parserResult =JSON.createParser(strRes);
                 
                 //system.debug(stringjson);
                 system.debug(strRes);
                 system.debug(ResCreate);
                 if(ResCreate.getStatusCode() == 201){
                     List<String> gcid=new List<String>();
                 }    
             }else{
                 
             }
                     
    }
}