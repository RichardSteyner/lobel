trigger DeleteBank on Bank_Stats__c (before insert, after insert) {

    if(!System.isBatch()){
        if(Trigger.isAfter){
            List<Bank_Stats__c> banksToDelete = new List<Bank_Stats__c>();
            List<Bank_Stats__c> banksToRelation = new List<Bank_Stats__c>();
            for(Bank_Stats__c bank : Trigger.new){
                if(bank.Delete__c!=null && bank.Delete__c.equalsIgnoreCase('Y')) banksToDelete.add(bank);
                else banksToRelation.add(bank);
            }
            System.Database.executeBatch(new clsBatchDeleteBank(banksToDelete, banksToRelation));
        }else {
            //System.debug(Trigger.new.size());
            Set<String> lotIds = new Set<String>();
            Set<String> periods = new Set<String>();
            Set<String> lotPeriodConcatenado = new Set<String>();
            for(Bank_Stats__c bs : Trigger.new){
                if( String.isNotBlank(bs.LotID__c) && String.isNotBlank(bs.Period__c) /*&& (bs.Delete__c==null || !bs.Delete__c.equalsIgnoreCase('Y'))*/ ){
                    lotIds.add(bs.LotID__c);
                    periods.add(bs.Period__c);
                    lotPeriodConcatenado.add(bs.LotID__c + '-' + bs.Period__c);
                }
            }

            String auxConcat;
            Map<String, String> ids = new Map<String, String>();
            for(Bank_Stats__c bs : [select Id, LotID__c, Period__c 
                                        from Bank_Stats__c 
                                        where LotID__c in: lotIds or Period__c in: periods]){
                auxConcat = bs.LotID__c + '-' + bs.Period__c;
                if(lotPeriodConcatenado.contains(auxConcat)) ids.put(auxConcat, bs.Id);
                
            }

            List<Bank_Stats__c> banksToUpdate = new List<Bank_Stats__c>();
            for(Bank_Stats__c bs : Trigger.new){
                if(String.isNotBlank(bs.LotID__c) && String.isNotBlank(bs.LotID__c) && ids.keySet().contains(bs.LotID__c + '-' + bs.Period__c)){
                    /*bs.addError('Account already exists in your Organization');*/
                    System.debug(ids.get(bs.LotID__c + '-' + bs.Period__c));
                    banksToUpdate.add(new Bank_Stats__c(Id=ids.get(bs.LotID__c + '-' + bs.Period__c),
                                                        Total__c=bs.Total__c,
                                                        Total1__c=bs.Total1__c,
                                                        Bank1__c=bs.Bank1__c,
                                                        Total2__c=bs.Total2__c,
                                                        Bank2__c=bs.Bank2__c,
                                                        Total3__c=bs.Total3__c,
                                                        Bank3__c=bs.Bank3__c,
                                                        Total4__c=bs.Total4__c,
                                                        Bank4__c=bs.Bank4__c,
                                                        Total5__c=bs.Total5__c,
                                                        Bank5__c=bs.Bank5__c,
                                                        Total6__c=bs.Total6__c,
                                                        Bank6__c=bs.Bank6__c,
                                                        Total7__c=bs.Total7__c,
                                                        Bank7__c=bs.Bank7__c,
                                                        Delete__c=bs.Delete__c));
                    bs.Delete__c = 'Y';
                }else{

                }
            }

            if(banksToUpdate.size()>0)
                update banksToUpdate;
        }
    }
}