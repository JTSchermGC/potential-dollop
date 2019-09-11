public class StreetAddress {
	public static Void StreetAddressData(List<Id> idVal) {
        system.debug(idVal);
        contact[] donorData = [select Id from contact where Id=:idVal];
        Street_Address__c[] StreetData = [select Id from Street_Address__c where Donors__c=: donorData.get(0).Id];	
        system.debug('aS'+StreetData.size());
        //string Idvalll =  ( StreetData.get(0).Id == null) ? '' :  StreetData.get(0).Id;
        //system.debug('values'+Idvalll);
        if( StreetData.size() >0){
            
        }else{
        	List<Street_Address__c> streetList = new List<Street_Address__c>();
            Street_Address__c newAcct = new Street_Address__c(Donors__c = donorData.get(0).Id);
            streetList.add(newAcct);
            try {
                Insert streetList;
            } catch (DmlException e) {
                // Process exception here
            }
        }
    }
}