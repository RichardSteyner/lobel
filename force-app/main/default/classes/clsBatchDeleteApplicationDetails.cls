global class clsBatchDeleteApplicationDetails implements Database.Batchable<sObject>, Database.Stateful {

    List<Application_Detail__c> listApplicationDetails;
    
    public clsBatchDeleteApplicationDetails(List<Application_Detail__c> listApplicationDetails){
        this.listApplicationDetails=listApplicationDetails;
    }
    
    global List<Application_Detail__c> start(Database.BatchableContext bc) {
        return listApplicationDetails;
    }
    
     global void execute(Database.BatchableContext bc, List<Application_Detail__c> scope){
        // process each batch of records
      
       List<Application_Detail__c> applicationDetails= new List<Application_Detail__c>();
         
       for(Application_Detail__c appDT: scope){
       		 If (appDT.Delete__c== 'y'){
       				applicationDetails.add(appDT);
       			}
  		}	
         if(applicationDetails.size()>0){
         	delete applicationDetails;
         }
         
    }    

	global void finish(Database.BatchableContext bc){
       // System.debug(recordsProcessed + ' ---records finish!');
       
    }    
}