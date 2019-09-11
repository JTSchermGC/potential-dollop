public class GetGcToken {
	public static String TokenData() {
        	 Http http = new Http();
             HttpRequest request = new HttpRequest();
             request.setEndpoint(Label.GcURL+'oauth');
             request.setMethod('POST');
             request.setHeader('Content-Type', 'application/json;charset=UTF-8');
             
             request.setBody('{"username":"'+Label.BMLoginId+'","password":"'+Label.bmpassword+'","user_type":"Location Administrator","grant_type":"password","client_id":"stacknew","client_secret":"test123"}');
             HttpResponse response = http.send(request);
             // Parse the JSON response
             string strResponse=response.getBody();
        	
             JSONParser parser1 =JSON.createParser(strResponse);
             List<String> AccessToken=new List<String>();
             while(parser1.nextToken() != null){
                // if(parser1.getText()=='status'){
                     
                     parser1.nextToken();
                    // if(parser1.getText()=='200'){
                         //parser1.nextToken();
                         if ((parser1.getText() == 'access_token')) {
                             //----------------Get the value.
                             parser1.nextToken();
                             AccessToken.add(parser1.getText());
                         }
                     //}else{
                      //	system.debug('cccc'+strResponse);   
                     //}
                // }
             }
             return AccessToken[0];
    }
}