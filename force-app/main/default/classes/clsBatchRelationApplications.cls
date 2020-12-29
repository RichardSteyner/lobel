global class clsBatchRelationApplications implements Database.Batchable<sObject>, Database.Stateful {

	List<Application__c> listAppplication;
    
    //CONSTRUCTOR
    public clsBatchRelationApplications(List<Application__c> listAppplication){
        this.listAppplication=listAppplication;
    }
    
    global List<Application__c> start(Database.BatchableContext bc) {
        
        
       //List<Account> accounts = [select Id, Name from Account];
	   Set<Id> ids = (new Map<Id,Application__c>(listAppplication)).keySet();
       
        //System.debug('----idsc---'+ids);
        
        list<Application__c> newListApp=[SELECT Id,LotID__c, Name FROM Application__c where Id in : ids ];
        
        //System.debug('----Lista in Constuctor---'+newListApp);
       return newListApp;
    }
    
    global void execute(Database.BatchableContext bc, List<Application__c> scope){
        
        // MAP1 obtener los id de Application en acc
        Map<String,Account> acc=new Map<String,Account>();
        
        // MAP2 IDLot - Dealert
        Map<String,Account> mapAppId_Dealert=new Map<String,Account>();
        
        for(Application__c bs: scope){
             acc.put(bs.LotID__c,null);
         }
        
        //Buscar los account que contengan los LotID__c de Bank
        list<Account> a= [Select Id, LotID__c,Name from Account where LotID__c =:acc.keyset()];
        
        //Agregar al Map2
        for(Account at:a){
            if(at!=null){
                mapAppId_Dealert.put(at.LotID__c,at);
            } 
        }
        
        List<Application__c> listApp= new List<Application__c>();
        
        
        //System.debug('----Map---'+mapBankId_Dealert);
        
        
        for(Application__c bts: scope){
            
            String id=mapAppId_Dealert.containsKey(bts.LotID__c) ? mapAppId_Dealert.get(bts.LotID__c).Id : null;
           	
            if(id!=null){
                
                 bts.Dealer__c= id;
				listApp.add(bts);
            }
                
  		}	
        //System.debug('----List---'+listApp);
        if(listApp.size()>0){
            update listApp;
        }   
        
        
    }    

	global void finish(Database.BatchableContext bc){
        //System.debug(' ---Batch sinc');
        
    }    
}