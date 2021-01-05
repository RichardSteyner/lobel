global class clsBatchDeleteBank implements Database.Batchable<sObject>, Database.Stateful  {

    List<Bank_Stats__c> listBank;
    List<Bank_Stats__c> listBankForRelations;
    
    public clsBatchDeleteBank(List<Bank_Stats__c> listBank, List<Bank_Stats__c> listBankForRelations){
        this.listBank=listBank;
        this.listBankForRelations = listBankForRelations;
    }
    
    global List<Bank_Stats__c> start(Database.BatchableContext bc) {
        return listBank;
    }
    
     global void execute(Database.BatchableContext bc, List<Bank_Stats__c> scope){
        // process each batch of records
      
        List<Bank_Stats__c> bankDelete= new List<Bank_Stats__c>();
        Set<String> lotIds = new Set<String>();
        Set<String> periods = new Set<String>();
        Set<String> lotPeriodConcatenado = new Set<String>();

        for(Bank_Stats__c bs: scope){
            /*If (bs.Delete__c== 'y'){
       			bankDelete.add(bs);
            }*/
            if(String.isNotBlank(bs.LotID__c) && String.isNotBlank(bs.Period__c)){
                lotIds.add(bs.LotID__c);
                periods.add(bs.Period__c);
                lotPeriodConcatenado.add(bs.LotID__c + '-' + bs.Period__c);
            }
        }	

        String auxConcat;
        for(Bank_Stats__c bs : [select Id, LotID__c, Period__c, Delete__c 
                                    from Bank_Stats__c 
                                    where LotID__c in: lotIds or Period__c in: periods]){
            if(bs.Delete__c!=null && bs.Delete__c.equalsIgnoreCase('y')){
                auxConcat = bs.LotID__c + '-' + bs.Period__c;
                if(lotPeriodConcatenado.contains(auxConcat)) bankDelete.add(bs);
            }
        }
          
        if(bankDelete.size()>0){
         	delete bankDelete;
        }
        
         
    }    

	global void finish(Database.BatchableContext bc){
		if(!Test.isRunningTest()){
            System.Database.executeBatch(new clsBatchRelationBank(listBankForRelations));
        }
       
        
    }    
}