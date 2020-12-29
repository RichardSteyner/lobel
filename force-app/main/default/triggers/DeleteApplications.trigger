trigger DeleteApplications on Application__c (after insert) {

    if(!System.isBatch()){
        List<Application__c> appsToDelete = new List<Application__c>();
        List<Application__c> appsToRelation = new List<Application__c>();
        for(Application__c app : Trigger.new){
            if(app.Delete__c!=null && app.Delete__c.equalsIgnoreCase('Y')) appsToDelete.add(app);
            else appsToRelation.add(app);
        }
        System.Database.executeBatch(new clsBatchDeleteApplication(appsToDelete, appsToRelation));
     }
}