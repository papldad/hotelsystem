public with sharing class HotelCmpController {
    
    @AuraEnabled
    public static Map<String, String> getCity(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Hotel__c.City__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<Hotel__c> getHotelListA(string searchcity) {
        List<Hotel__c> listHotel;
        listHotel = [SELECT Id, Name, City__c, Street__c, ImageURL__c, Phone__c, Description__c FROM Hotel__c WHERE City__c =: searchcity ORDER BY Name ASC];
        return listHotel;
    }
    
    @AuraEnabled
    public static Map<String, String> getCapacity(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Room__c.Capacity__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<Room__c> getRoomListA(string searchcapacity, string searchhotel, Date startDate, Date endDate) {
        List<Reservation__c> reservations = [
            SELECT room__r.id FROM Reservation__c 
            WHERE (Check_In__c < :endDAte and Check_In__c >= :startDate) or (Check_Out__c <= :endDAte and Check_Out__c > :startDate)
        ];
        
        List<Id> reserved_rooms = new List<Id>();
        for (Reservation__c reservation: reservations){
            reserved_rooms.add(reservation.room__r.id);
        }
        
        List<Room__c> listRoom = [
            SELECT Id, Name, Price_per_Day__c, Capacity__c FROM Room__c
            WHERE Hotel__r.id = :searchhotel AND Capacity__c = :searchcapacity AND Id NOT IN :reserved_rooms
            ORDER BY Name DESC
        ];
        return listRoom;
    }
    
    @AuraEnabled
    public static List<Service_Hotel__c> getServiceList() {
        List<Service_Hotel__c> listService;
        listService = [SELECT Id, Name, Price_per_Day__c FROM Service_Hotel__c];
        return listService;
    }
    
    @AuraEnabled
    public static Reservation__c saveNewReservation
        (Reservation__c newReservationA, String idHotelA, String idRoomA, List<String> valueSerA, Date startDateA, Date endDateA){
            Date startDate = date.valueOf(startDateA);                                                
            Date endDate = date.valueOf(endDateA);
            newReservationA.RecordTypeId = '0122w000000Y5BpAAK';
            newReservationA.Hotel__c = [SELECT Id FROM Hotel__c WHERE Id =:idHotelA LIMIT 1].Id;
            newReservationA.Room__c = [SELECT Id FROM Room__c WHERE Id =:idRoomA LIMIT 1].Id;
            upsert newReservationA;
            for (String serId: valueSerA)
            {
                Reservation_Service__c rs = new Reservation_Service__c();
                rs.Service_Hotel__c = serId;
                rs.Reservation__c = newReservationA.Id;
                insert rs;
            }        
            return newReservationA = [SELECT Id, Name FROM Reservation__c LIMIT 1];
            /*return newReservationA = [SELECT Id, Name, Check_In__c, Check_Out__c, Total_Reservation_Cost__c, 
                               Hotel__r.Name, Hotel__r.City__c, Hotel__r.Street__c, 
                               Room__r.Name, Room__r.Capacity__c FROM Reservation__c];*/
            
        }  
    
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {mMail};
            mail.setToAddresses(toAddresses);
        mail.setSubject(mSubject);
        mail.setPlainTextBody(mbody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}