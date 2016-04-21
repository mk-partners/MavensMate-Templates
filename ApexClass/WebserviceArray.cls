/**
* @author MK Partners Inc.
* @date 2016-04-20
*
* @description Webservice class to receive incoming data.
*/
@RestResource(urlMapping='/FILL_ME_IN_{{ api_name }}/*')
global class {{ api_name }} {


	// TODO: Fill in urlMapping
	// TODO: Fill in Field Mapping
	// TODO: Change the SObject type from Account in the fieldDescribeMap and in the "SObject record" schema declaration


	// Map of salesforce fields
	public static Map<String, Schema.SObjectField> fieldDescribeMap = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();	

	// Map of webservice field names to Salesforce Account API names
	public static Map<String, String> fieldMap = new Map<String, String> {
		'salesforceId' => 'Id'
		, 'name' => 'Name'
	};
	

	/**
	* @name postMethod
	* @date 4/20/2016
	* @description Handles the POST operation
	**/
	@HttpPost
	global static String postMethod() {

		String input = RestContext.request.requestBody.toString();

		Account[] records = new Account[] {};
		List<Map<String, Object>> wrappers = new List<Map<String, Object>>();
		for ( Object o : (List<Object>)JSON.deserializeUntyped(input) ) {
			wrappers.add( (Map<String, Object>)o );
		}

		// Process wrappers
		for ( Map<String, Object> wrapper : wrappers ) {
			Account record = new Account();

			for ( String field : wrapper.keySet() ) {	
				if ( fieldMap.containsKey( field ) && fieldDescribeMap.containsKey( field ) ) {
					if ( field == 'field_with_custom_logic' ) {
						// Custom Logic for some fields if necessary
					} else {
						record.put( fieldMap.get( field ), wrapper.get( field ) );
					}
				}
			}
			records.add( record );
		}

		// Save results
		List<Database.UpsertResult> results = Database.upsert( records, false ); 
		for ( Integer i = 0; i < results.size(); i++ ) {

			if ( results[i].isSuccess() ) {
				wrappers[i].put( 'salesforceId', results[i].getId()) ;
			} else {
				wrappers[i].put( 'error', results[i].getErrors()[0].getMessage() );
			}
		}

		return JSON.serialize(wrappers);
	}
}