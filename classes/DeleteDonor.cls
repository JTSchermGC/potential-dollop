public with sharing class DeleteDonor {
@AuraEnabled
	public static void DonorDeleteData(Id idVal,string paramType) {
        if(paramType=='Donor'){
            Contact dataContact = [SELECT Id,Donor_Id__c from Contact where Id=:idVal];
            string idData=string.valueOf(dataContact.Donor_Id__c);
            dataContact.Record_Status__c = 'Inactive';
            update dataContact;
            
            List<DonorPaymentMethod__c> datalistPyment = [SELECT Id FROM DonorPaymentMethod__c where Contact__c=:idVal];
            for(DonorPaymentMethod__c data :datalistPyment){
                data.Record_Status__c ='Inactive';
            }
            update datalistPyment;
            
            List<String> RecId = new List<String>();
            List<npe03__Recurring_Donation__c> datalist = [SELECT Id, Name FROM npe03__Recurring_Donation__c where npe03__Contact__c=:idVal];
            for(npe03__Recurring_Donation__c data :datalist){
                data.Record_Status__c ='Inactive';
                RecId.add(data.Id);
            }
            update datalist;
            
            RecurringBatchClass.RecurringData(RecId);
            if (!updation.isfutureupdate) {
                if(idData!=''){
                	GCDeleteAPI.DeleteContactCallout(idData);    
                }
            		//
            }
            //DeleteOpportunity bcn = new DeleteOpportunity(RecId);
            //ID batchprocessid = Database.executeBatch(bcn);
            
           /* Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            for (Schema.ChildRelationship cr: R.getChildRelationships()) 
            {
              system.debug('====child object==='+cr.getChildSObject());
            }
            */
        }
        else if(paramType=='Recurring'){
        	List<String> RecId = new List<String>();
            List<npe03__Recurring_Donation__c> datalist = [SELECT Id FROM npe03__Recurring_Donation__c where Id=:idVal];
            system.debug('inside datalist'+datalist);
            for(npe03__Recurring_Donation__c data :datalist){
                data.Record_Status__c ='Inactive';
                RecId.add(data.Id);
            }
            if(RecId.size()>0){
            	update datalist;   
                RecurringBatchClass.RecurringData(RecId);
                if (!updation.isfutureupdate) {
            		GCDeleteAPI.DeleteCallout(RecId);
            	}
            }
        }
        else if(paramType=='Pledge'){
            List<Opportunity> datalist = [SELECT Id,npsp__Primary_Contact__c, GcScheduleId__c FROM Opportunity where Id=:idVal];
            List<Contact> datalistContact = [SELECT Id,Donor_Id__c FROM Contact where Id=:datalist[0].npsp__Primary_Contact__c];
            List<String> RecIdOppor = new List<String>();
            for(Opportunity data :datalist){
                data.Record_Status__c ='Inactive';
                RecIdOppor.add(data.Id);
            }
            if(RecIdOppor.size()>0){
                update datalist;  
            }
            if(datalist[0].GcScheduleId__c!=null && datalistContact[0].Donor_Id__c!=null){
                if (!updation.isfutureupdate) {
            		GCDeleteAPI.DeleteOpporCallout(string.valueOf(datalist[0].GcScheduleId__c),string.valueOf(datalistContact[0].Donor_Id__c));
            	}
            }else{
                return;
            }
            
        }
    }
}