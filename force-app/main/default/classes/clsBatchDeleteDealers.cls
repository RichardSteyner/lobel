global class clsBatchDeleteDealers implements Database.Batchable<sObject>, Database.Stateful{

 	global Integer recordsProcessed = 0;
    List<Account> listAccount;
    
    public clsBatchDeleteDealers(List<Account> listAccount){
        this.listAccount=listAccount;
    }
    
    global List<Account> start(Database.BatchableContext bc) {
        return listAccount;
    }
    
     global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
      
       List<Account> dealer= new List<Account>();
         
       for(Account acc: scope){
       		 If (acc.Delete__c== 'y'){
       				dealer.add(acc);
       			}
  		}	
          if(dealer.size()>0){
         	 delete dealer;
         }
        
         
        
        
    }    

	global void finish(Database.BatchableContext bc){
       // System.debug(recordsProcessed + ' ---records finish!');
       
    }    


}