global class {{ api_name }} implements Database.Batchable<String> {

	List<String> toProcess;

	public {{ api_name }}(List<String> toDo) {
		toProcess = toDo;
	}

	public Iterable<String> start(Database.BatchableContext bc) {
		return toProcess == null ? new List<String>() : toProcess;
	}

	public void execute(Database.BatchableContext bc, List<String> toProcess) {
		try {
			processIds(toProcess);
		}
		catch (Exception e) {
			reschedule(15);
		}
	}	

	public void finish(Database.BatchableContext bc) {
		reschedule(15);
	}

	public static void reschedule(Integer minutesFromNow) {
		Set<String> nextIds = new Set<String>();
		// Generate the next list of IDs to be processed

		String jobName = 'Batch Job for ' + system.now().addMinutes(minutesFromNow).format();
		System.scheduleBatch(new {{ api_name }}( nextIds ), jobName, minutesFromNow, 50);
	}	

	public static void processIds( List<String> ids ) {
		// Handle the records
	}
}