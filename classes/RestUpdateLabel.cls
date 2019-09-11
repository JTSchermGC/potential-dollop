@RestResource(urlMapping='/Label/RestUpdateLabel/*')
global with sharing class RestUpdateLabel {
	@HttpPost
    global static void doPost(string csname,string description,string language,string value, boolean isProtected,string passname,string passvalue)
    {
       
        List<MetadataService.Metadata> allMetadataList = new List<MetadataService.Metadata>();
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomLabel csLabel = new MetadataService.CustomLabel();
        MetadataService.CustomLabel csLabel1 = new MetadataService.CustomLabel();
        csLabel.fullName = csname;
        csLabel.language = language;
        csLabel.protected_x  = isProtected;
        csLabel.shortDescription  = description;
        csLabel.value=value;
        allMetadataList.add(csLabel);
        csLabel1.fullName = passname;
        csLabel1.language = language;
        csLabel1.protected_x  = isProtected;
        csLabel1.shortDescription  = description;
        csLabel1.value=passvalue;
        allMetadataList.add(csLabel1);
        List<MetadataService.SaveResult> results = service.updateMetadata(allMetadataList);
        string concat_result='{';
        for(MetadataService.SaveResult result: results){
            if(result.success==true){
            	concat_result=concat_result+'"'+result.fullName+'" : "'+result.success+'",';   
            }else{
               	concat_result=concat_result+'"'+result.fullName+'" : "'+result.success+'",'; 
            }
        }
        concat_result=concat_result.removeEnd(',');
        concat_result=concat_result+'}';
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(concat_result);
        response.statusCode = 200;
    }
    public static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}