trigger DeleteBank on Bank_Stats__c (after insert) {

    if(!System.isBatch()){
        List<Bank_Stats__c> banksToDelete = new List<Bank_Stats__c>();
        List<Bank_Stats__c> banksToRelation = new List<Bank_Stats__c>();
        for(Bank_Stats__c bank : Trigger.new){
            if(bank.Delete__c!=null && bank.Delete__c.equalsIgnoreCase('Y')) banksToDelete.add(bank);
            else banksToRelation.add(bank);
        }
        System.Database.executeBatch(new clsBatchDeleteBank(banksToDelete, banksToRelation));
    }
}