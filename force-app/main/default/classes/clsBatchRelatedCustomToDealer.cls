global class clsBatchRelatedCustomToDealer implements Database.Batchable<sObject>, Database.Stateful {
	
    global Integer recordsProcessed = 0;
 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id,LotID__c,IdExternal__c,Dealer__c, Name FROM Bank_Stats__c where Dealer__c = Null '
        );
    }
    
    
    global void execute(Database.BatchableContext bc, List<Bank_Stats__c> scope){
        
        // MAP1 obtener los id de Bank
        Map<String,Account> acc=new Map<String,Account>();
        
        // MAP2 IDLot - Dealert
        Map<String,Account> mapBankId_Dealert=new Map<String,Account>();
        
        for(Bank_Stats__c bs: scope){
             acc.put(bs.LotID__c,null);
         }
        
        //Buscar los account que contengan los LotID__c de Bank
        list<Account> a= [Select Id, LotID__c,Name from Account where LotID__c =:acc.keyset()];
        
        //Agregar al Map2
        for(Account at:a){
            if(at!=null){
                mapBankId_Dealert.put(at.LotID__c,at);
            } 
        }
        
        List<Bank_Stats__c> listbk= new List<Bank_Stats__c>();
        
        
        System.debug('----Map---'+mapBankId_Dealert);
        
        
        for(Bank_Stats__c bts: scope){
            
            String id=mapBankId_Dealert.containsKey(bts.LotID__c) ? mapBankId_Dealert.get(bts.LotID__c).Id : null;
           	
            if(id!=null){
                
                 bts.Dealer__c= id;
				listbk.add(bts);
            }
                
  		}	
        System.debug('----List---'+listbk);
        if(listbk.size()>0){
            update listbk;
        }   
        
        
    }    

	global void finish(Database.BatchableContext bc){
        //System.debug(' ---Batch sinc');
        
    }    
}