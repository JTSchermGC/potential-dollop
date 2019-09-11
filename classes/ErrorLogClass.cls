public class ErrorLogClass {
    public static void ErrorLogClass(string [] val){
        ErrorLogAPI__c ErrorLogAPI = new ErrorLogAPI__c(
        Donor__c=val[0],
        RecordId__c=val[2],
        ErrorStatus__c=val[3]
        );
        insert ErrorLogAPI;
    }
}