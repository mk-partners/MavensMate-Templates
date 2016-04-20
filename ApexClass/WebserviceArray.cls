/**
* @author MK Partners Inc.
* @date 2016-04-20
*
* @description Webservice class to receive incoming data.
*/
@RestResource(urlMapping='/FILL_ME_IN/*')
global class {{ api_name }} {
// TODO: Fill in the urlMapping

	global class RecordWrapper {
		// TODO: Fill in the remaining fields

		global String salesforceId;
		global String error;
	}

	// Map of webservice field names to Salesforce {{ object_name }} API names
	public static Map<String, String> fieldMapping = new Map<String, String> {
		'name' => 'Name'
	};

	/**
	* @name handlePost
	* @date 4/20/2016
	* @description Handles the POST operation
	**/
	@HttpPost
	global static (Map<String,Object>) handlePost() {
		
		// Parse the POST body
		String requestBody = RestContext.request.requestBody.toString();
		List<Object> requestRecords;
		try {
			requestRecords = (List<Object>)JSON.deserializeUntyped( requestBody );
		} catch (Exception e) {
			// TODO: Handle parsing errors

			System.Debug(e);
			return null;
		}


		// Loop through input records
		Map<Integer, {{ object_name }}> recordMap = new Map<Integer, {{ object_name }}>();
		Map<Integer, Object> wrapperMap = new Map<Integer, Object>();
		for ( Integer i = 0; i < requestRecords.size(); i++ ) {
			
			Object w = requestRecords[i];
			{{ object_name }} record = new {{ object_name }}();

			// TODO: Construct the {{ object_name }} from the wrapper
			Map<String, Object> wMap = (Map<String, Object>)w;
			for ( String s : wMap.keySet() ) {
				if ( fieldMapping.containsKey(s) ) {

					if ( s == 'field_with_custom_logic' ) {
						// do custom logic
					} else {
						record.put(fieldMapping.get(s), wMap.get(s));	
					}
				}
			}

			recordMap.put(i, record);
			wrapperMap.put(i, w);
		}


		// Update the {{ object_name }} records in Salesforce and return results
		//List<Database.UpsertResult> results = Database.upsert(recordMap.values()); 
		//for ( Integer i = 0; i < results.size(); i++ ) {
		//	Database.UpsertResult result = results[i];
		//	if ( result.isSuccess() ) {
		//		wrapperMap.get(i).salesforceId = result.getId();
		//	} else {
		//		wrapperMap.get(i).error = result.getErrors()[0].getMessage();
		//	}
		//}


		(Map<String,Object>) returnResults = (Map<String,Object>)(wrapperMap.values());
		return returnResults;
	}
}
