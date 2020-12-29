global class clsBatchDeleteApplication implements Database.Batchable<sObject>, Database.Stateful {

    List<Application__c> listApplication;
    List<Application__c> listApplicationForRelations;
    
    public clsBatchDeleteApplication(List<Application__c> listApplication, List<Application__c> listApplicationForRelations){
        this.listApplication = listApplication;
        this.listApplicationForRelations = listApplicationForRelations;
    }
    
    global List<Application__c> start(Database.BatchableContext bc) {
        return listApplication;
    }
    
     global void execute(Database.BatchableContext bc, List<Application__c> scope){
        // process each batch of records
      
        List<Application__c> applications = new List<Application__c>();
        Set<String> lotIds = new Set<String>();
        Set<String> periods = new Set<String>();
        Set<String> lotPeriodConcatenado = new Set<String>();
         
        for(Application__c app: scope){
       		/*If (app.Delete__c== 'y' ){                	
                applications.add(app);
            }*/
            if(String.isNotBlank(app.LotID__c) && String.isNotBlank(app.LotID__c)){
                lotIds.add(app.LotID__c);
                periods.add(app.Period__c);
                lotPeriodConcatenado.add(app.LotID__c + '-' + app.Period__c);
            }
        }
        
        String auxConcat;
        for(Application__c app : [select Id, LotID__c, Period__c 
                                    from Application__c 
                                    where LotID__c in: lotIds or Period__c in: periods]){
            auxConcat = app.LotID__c + '-' + app.Period__c;
            if(lotPeriodConcatenado.contains(auxConcat)) applications.add(app);
        }
        
        if(applications.size()>0){
         	delete applications;
        }
         
    }    

	global void finish(Database.BatchableContext bc){
       // System.debug(recordsProcessed + ' ---records finish!');
        if(!Test.isRunningTest()){
            System.Database.executeBatch(new clsBatchRelationApplications(listApplicationForRelations));
        }
       
    }    
}