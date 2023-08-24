public with sharing class EmployeePortalDataController {
    @AuraEnabled(cacheable = true)
    public static DataWrapper getEmployeeDetail(String dataType, Boolean isSingle) {
        DataWrapper returnValue = new DataWrapper();
        Employee_Portal__mdt epMtd = Employee_Portal__mdt.getInstance(dataType); 
        if (dataType == 'Employee') {
            returnValue.columns = getFieldsByFieldSet('Employee__c', 'Employee_Portal_FieldSet');
            returnValue.records = getEmployeeData(returnValue.columns);
            returnValue.isSingle = isSingle;
            returnValue.recordId = (String) returnValue.records[0].get('Id');
            returnValue.tableColumns = null;
            System.debug('Return value ' +returnValue.columns);
            System.debug('Return oinijhe ' +returnValue.isSingle);
            System.debug('Return msdjsabj ' +returnValue.records);
        } 
        return returnValue; 
    }
    
    private static List<String> getFieldsByFieldSet(String objectApi, String fieldSetName) {
        List<String> returnValue = new List<String>();
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objectApi);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName); 
        for (Schema.FieldSetMember fieldSet : fieldSetObj.getFields()) {
            returnValue.add(fieldSet.getFieldPath()); 
        }
        return returnValue;
    }
    
    public static Map<String, String> getComFieldsByobjectAPI(String objAPI){
        Map<String, String> objFields = new Map<String, String>();
        Map <String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objAPI).getDescribe().fields.getMap();
        for(Schema.SObjectField singlefield : fieldsMap.Values()) {
            String apiName = singlefield.getDescribe().getLocalName();
            String name = singlefield.getDescribe().getLabel();
            objFields.put(apiName, name);
        }
        System.debug('Comp objFields = '+objFields);
        return objFields;
    }
    
    private static List<SObject> getEmployeeData(List<String> fields) {
        Id userId = UserInfo.getUserId();
        String queryString = 'SELECT ' + String.join(fields,',') + ' FROM Employee__c WHERE Connected_User__c   =: userId LIMIT 1';
        System.debug('queryString=='+queryString);
        return Database.query(queryString);
    }
    public class DataWrapper {
        @AuraEnabled public List<SObject> records;
        @AuraEnabled public Boolean isSingle;
        @AuraEnabled public List<String> columns;
        @AuraEnabled public List<ColumnWrapper> tableColumns;
        @AuraEnabled public String recordId;
    }
    
    public class ColumnWrapper {
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String fieldName {get;set;}
        
        public ColumnWrapper(String fieldName, String label) {
            this.label     = label;
            this.fieldName = fieldName;         
        }
    }
    }