public class SyncParishId {
    @InvocableMethod
	public static Void ParishSync(List<Id> idVal) {
       if (!updation.isfutureupdate) {
           SyncParishIdCallout.ParishSyncData(idVal);
       }
    }
}