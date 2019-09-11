public class SyncEventToGC {
	 @InvocableMethod
	public static Void EventData(List<Id> idVal) {
        if (!updation.isfutureupdate) {
         try{
             SyncEventCallout.EventDataCallout(idVal);
         }catch(exception e){
            system.debug(String.valueOf(e));       
        }
        }
	}
}