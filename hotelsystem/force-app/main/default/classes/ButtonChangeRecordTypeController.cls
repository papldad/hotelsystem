public with sharing class ButtonChangeRecordTypeController {
    
    @AuraEnabled
    public static void changeRecordTypeRes (string recordId) {
        string resType = '0122w000000Y5BkAAK';
        string preResType = '0122w000000Y5BpAAK';
        Reservation__c record = [SELECT RecordTypeId FROM Reservation__c WHERE Id =: recordId LIMIT 1];
        
        if (record.RecordTypeId == resType){
            record.RecordTypeId = preResType;
        }else{
            record.RecordTypeId = resType;
        }

        update record;
    }
}