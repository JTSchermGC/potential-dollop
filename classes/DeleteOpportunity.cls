global class DeleteOpportunity implements Database.Batchable<sObject>, Database.Stateful  {
    //private strParameter;
    
    global List<String> strParameter;
    public DeleteOpportunity(List<String> strParam) {
        strParameter = strParam;
        system.debug(strParameter);
    }

    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('****Start ***');

        String query = 'SELECT ID,Record_Status__c from Opportunity where npe03__Recurring_Donation__c IN:strParameter';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        // process each batch of records
        system.debug(scope);
       	List<Opportunity> OppData = new List<Opportunity>();
        for (Opportunity Data : scope) {
                Data.Record_Status__c ='Inactive';
                OppData.add(Data);
        }
       update OppData;
    }    
    global void finish(Database.BatchableContext bc){
        //System.debug(recordsProcessed + ' records processed. Shazam!');
        //AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                       //     JobItemsProcessed,
                        //    TotalJobItems, CreatedBy.Email
                         //   FROM AsyncApexJob
                         //   WHERE Id = :bc.getJobId()];
        // call some utility to send email
    }    
}