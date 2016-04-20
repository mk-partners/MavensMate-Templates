/**
* @author MK Partners Inc.
* @date 2016-04-20
*
* @description Webservice class to receive incoming data.
*/
@RestResource(urlMapping='/FILL_ME_IN/*')
global class {{ api_name }} {

	global class RecordWrapper {
		// TODO: Fill in the remaining fields

		global String salesforceId;
		global String error;
	}

	/**
	* @name doPost
	* @date 4/20/2016
	* @description Handles the POST operation
	**/
	@HttpPost
	global static void doPost() {
		
		// Parse the POST body
		String requestBody = RestContext.request.requestBody.toString();
		List<RecordWrapper> requestRecords;
		try {
			requestRecords = (List<RecordWrapper>)JSON.deserializeUntyped( requestBody );
		} catch (Exception e) {
			// TODO: Handle parsing error
			System.Debug(e);
			return;
		}

		// Loop through input records
		Map<String, {{ object_name }}> recordMap = new Map<String, {{ object_name }}>();
		Map<String, RecordWrapper> wrapperMap = new Map<String, RecordWrapper>();
		for ( Integer i = 0; i < requestRecords.size(); i++ ) {
			
			RecordWrapper w = requestRecords[i];
			{{ object_name }} record = new {{ object_name }}();

			// TODO: Construct the {{ object_name }} from the wrapper
			

			recordMap.put(i, record);
			wrapperMap.put(i, w);
		}

		List<Database.UpsertResult> results = Database.upsert(recordMap.values()); 
		for ( Integer i = 0; i < results.size(); i++ ) {
			Database.UpsertResult result = results[i];
			if ( result.isSuccess() ) {
				wrapperMap.get(i).salesforceId = result.getId();
			} else {
				wrapperMap.get(i).error = result.getErrors()[0].getMessage();
			}
		}

	}
}
