public class SyncDonorCallout {
	 @Future(callout=true)
	public static Void ContactDataCallout(List<Id> idVal) {
        system.debug('asdasdddddddd');
        contact[] donorData1 = [select Id,FirstName from contact where Id=:idVal];
        if(donorData1.get(0).FirstName !='TestFirstApi1'){
              final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
               String guid = '';
               while (guid.length() < 7) {
               Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
               guid += chars.substring(idx, idx+1);
              }
            DateTime now = DateTime.now();
            Integer hours = now.hour(), minutes = now.minute(), seconds = now.second();
            string userkey = guid+''+hours+''+minutes+''+seconds;
             
//-------------Get GC Token------------------------------------------------------------------------------ 
             String AccessToken = GetGcToken.TokenData();
             //String AccessToken ='sdsdf';  

//-----------End GC Token Code-----------------------------------------------------------------------------------------------             
//-----------Get New Doner Details-----------------------------------------------------------------------------------------------                          
            
        List<string> SetContactId = new List<string>();
             contact[] donorData = [select Id,User_Id__c,HomePhone,Donor_Id__c,Salutation,FirstName,LastName,Email,MailingAddress,OtherAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,npe01__WorkEmail__c,Birthdate,OtherPhone,Title,Households__c from contact where Id=:idVal];
             
                string HParish = (donorData.get(0).Households__c == null) ? '' : donorData.get(0).Households__c;
                string parishid='';
                if( HParish!=Null || HParish!='' ){
                    Account[] parishData = [select Id,Parish_Id__c from Account where Id=:HParish];
                    parishid = (parishData.get(0).Parish_Id__c == null) ? '' : parishData.get(0).Parish_Id__c; 
                }else{
                    parishid ='';
                }
            system.debug(AccessToken);
             Street_Address__c[] streetData = [select Id,GC_Address_2__c,GC_Address_1__c,SF_Address__c from Street_Address__c where Donors__c=:idVal];
			 system.debug(streetData);
             string address2 = (streetData.get(0).GC_Address_2__c == null) ? '' : streetData.get(0).GC_Address_2__c;
             string address1 = (streetData.get(0).GC_Address_1__c == null) ? '' : streetData.get(0).GC_Address_1__c;
            
       system.debug(AccessToken);
             string first_name = (donorData.get(0).FirstName == null) ? '' : donorData.get(0).FirstName;
             string last_name = (donorData.get(0).LastName == null) ? '' : donorData.get(0).LastName;
             string email =  (donorData.get(0).email == null) ? '' : donorData.get(0).email;
             //string address1 = string.valueOf(donorData.get(0).MailingStreet);
             //string address2 = string.valueOf(donorData.get(0).MailingStreet);
             string city = (donorData.get(0).MailingCity == null) ? '' : donorData.get(0).MailingCity;
             string state = (donorData.get(0).MailingState == null) ? '' : donorData.get(0).MailingState;
             string zip = (donorData.get(0).MailingPostalCode == null) ? '' : donorData.get(0).MailingPostalCode;
             string country_val = (donorData.get(0).MailingCountry == null) ? '' : donorData.get(0).MailingCountry;
             string phone = (donorData.get(0).HomePhone == null) ? '' : donorData.get(0).HomePhone;
             string secondary_email = (donorData.get(0).npe01__WorkEmail__c == null) ? '' : donorData.get(0).npe01__WorkEmail__c;
             string date_of_birth = (string.valueOf(donorData.get(0).Birthdate) == null) ? '' : string.valueOf(donorData.get(0).Birthdate);
             string phone2 = (donorData.get(0).OtherPhone == null) ? '' : donorData.get(0).OtherPhone;
             string title = (donorData.get(0).Title == null) ? '' : donorData.get(0).Title;
             string gcidVal = (string.valueOf(donorData.get(0).Donor_Id__c) == null) ? '' : string.valueOf(donorData.get(0).Donor_Id__c);
             string recorduserid = (donorData.get(0).User_Id__c == null) ? '' : donorData.get(0).User_Id__c;
			 
             string country='';
             if(country_val!='' && country_val.length()!=2){
                Country_Codes__c[] CountryData = [select Id,Country_Code__c from Country_Codes__c where Name=:country_val];
                country = (CountryData.get(0).Country_Code__c == null) ? '' : CountryData.get(0).Country_Code__c;
             }else{
                country=country_val;
             }
             Http http = new Http();
        //----------Code End--------------------------------------------------------------------------------------------------             
             if(gcidVal != null && gcidVal !=''){
                 
                 //-------------Edit Doner Api Call-------------------------------------------------------
                 //string stringjson = '{"token":"'+AccessToken+'" ,"Api_Link":"'+Label.NewDonorApi+'/'+gcidVal+'","first_name": "'+first_name+'","last_name": "'+last_name+'","email": "'+email+'","address1": "'+address1+'","address2": "'+address2+'", "city": "'+city+'","state": "'+state+'","country": "'+country+'","zip": "'+zip+'","phone":"'+phone+'","parishid": "","secondary_email": "", "gender": "", "date_of_birth": "'+date_of_birth+'","marital_status": "","marriage_date": "","deceased": "","current_employer": "", "gplink": "", "fblink": "","linkedin": "","personal_website": "","prefix_code": "","suffix_code": "","spouse_first_name": "","spouse_last_name": "","twitterlink":"","session_id":"","sf_api_call":"0"}';
                 string stringjson = '{"token":"'+AccessToken+'" ,"Api_Link":"'+Label.GcURL+'donor'+'/'+gcidVal+'","first_name": "'+first_name+'","last_name": "'+last_name+'","email": "'+email+'","address1": "'+address1+'","address2": "'+address2+'", "city": "'+city+'","state": "'+state+'","country": "'+country+'","zip": "'+zip+'","phone":"'+phone+'","parishid": "'+parishid+'","date_of_birth": "'+date_of_birth+'","sf_api_call":"0"}';

                 HttpRequest req = new HttpRequest();
                 req.setMethod('POST');
                 req.setEndpoint(Label.ApiCallUrl+'SalesforceAPICall/GePatchRecord');
                 req.setTimeout(120000);
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 //req.setHeader('Authorization', 'Bearer '+AccessToken[0]); 
                 //req.setHeader('X-HTTP-Method-Override','PATCH');
                 req.setBody(stringjson);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser errParserResult =JSON.createParser(strRes);
                 system.debug('ranbir patch test---'+ResCreate.getStatusCode());
            
                 if(ResCreate.getStatusCode() != 200){
                     List<String> errStatus=new List<String>();
                     while(errParserResult.nextToken() != null){
                         if ((errParserResult.getText() == 'errorstatus')) {
                             //----------------Get the value.
                             errParserResult.nextToken();
                             errStatus.add(errParserResult.getText());
                         }
                     }
                     String [] storeData = new List<String>();
                     storeData.add('DonorEdit');
                     storeData.add(strRes);
                     storeData.add(string.valueOf(donorData.get(0).Id));
                     storeData.add(string.valueOf(ResCreate.getStatusCode()));
                     ErrorLogClass.ErrorLogClass(storeData);
                 }else{
                     	List<contact> updateId = new List<contact>(); 
                        List<contact> contactData = [select Id,User_Id__c,Donor_Id__c,Sync_Flag__c from contact where Id=:idVal];
                        for(contact objUpdate: contactData){
                            objUpdate.Sync_Flag__c='1';
                            updateId.add(objUpdate);
                        }
                             //system.debug(updateId);
                         updation.isfutureupdate = true;
                         if(updateId.size() > 0){
                             update updateId;
                         }
                 }

                 //-----------Edit Donor Code End-------------------------------------------------------------------
             }else{
                 system.debug('bbbb'+parishid);
                 //-----------New Donor Api Call ---------------------------------------------------------------
               string testnitin = '{"userid":"'+userkey+'","password":"","first_name":"'+first_name+'","last_name":"'+last_name+'","email":"'+email+'","address1":"'+address1+'","address2":"'+address2+'","city":"'+city+'","state":"'+state+'","country":"'+country+'","zip":"'+zip+'","phone":"'+phone+'","date_of_birth":"'+date_of_birth+'","parishid": "'+parishid+'","phone2":"'+phone2+'","suppressConfirmationEmail":"0","sf_api_call":"0"}';

                 
                 HttpRequest req = new HttpRequest();
                 req.setEndpoint(Label.GcURL+'donor');
                 req.setTimeout(120000);
                 req.setMethod('POST');
                 req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                 req.setHeader('Authorization', 'Bearer '+AccessToken); 
                 //req.setHeader('Authorization', 'Bearer fgfhfg');
                 //system.debug('hello2');
                 req.setBody(testnitin);
                 HttpResponse ResCreate = http.send(req);
                 string strRes=ResCreate.getBody();
                 JSONParser parserResult =JSON.createParser(strRes);
                 system.debug(testnitin);
                 system.debug(ResCreate);
                 system.debug(strRes);
                 if(ResCreate.getStatusCode() == 201){
                     List<String> gcid=new List<String>();
                     while(parserResult.nextToken() != null){
                         if ((parserResult.getText() == 'gcid')) {
                             //----------------Get the value.
                             parserResult.nextToken();
                             gcid.add(parserResult.getText());
                         }
                     }
                     JSONParser parserResult1 =JSON.createParser(strRes);
                     List<String> userid=new List<String>();
                     while(parserResult1.nextToken() != null){
                         if ((parserResult1.getText() == 'userid')) {
                             //----------------Get the value.
                             parserResult1.nextToken();
                             userid.add(parserResult1.getText());
                         }
                     } 
                //system.debug(userid);
                //system.debug(gcid);
                List<contact> updateId = new List<contact>(); 
                List<contact> contactData = [select Id,User_Id__c,Donor_Id__c,Sync_Flag__c from contact where Id=:idVal];
                for(contact objUpdate: contactData){
                	objUpdate.User_Id__c = userid[0];
                    objUpdate.Donor_Id__c = decimal.valueOf(gcid[0]);
                    objUpdate.Sync_Flag__c='1';
                    updateId.add(objUpdate);
                }
                     //system.debug(updateId);
                     updation.isfutureupdate = true;
                     if(updateId.size() > 0){
                         update updateId;
                     }
                 }else{
                     String [] storeData = new List<String>();
                     storeData.add('Donor');
                     storeData.add(strRes);
                     storeData.add(string.valueOf(donorData.get(0).Id));
                     storeData.add(string.valueOf(ResCreate.getStatusCode()));
                     ErrorLogClass.ErrorLogClass(storeData);
                 }
           }
    }
    }
}