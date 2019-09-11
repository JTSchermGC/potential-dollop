public class RecurringBatchClass {
	public static Void RecurringData(List<String> idVal) {
        DeleteOpportunity bcn = new DeleteOpportunity(idVal);
		ID batchprocessid = Database.executeBatch(bcn);
    }
}