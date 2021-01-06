trigger DeleteApplications on Application__c (before insert, after insert) {

    if(!System.isBatch()){
        if(Trigger.isAfter){
            List<Application__c> appsToDelete = new List<Application__c>();
            List<Application__c> appsToRelation = new List<Application__c>();
            for(Application__c app : Trigger.new){
                if(app.Delete__c!=null && app.Delete__c.equalsIgnoreCase('Y')) appsToDelete.add(app);
                else appsToRelation.add(app);
            }
            System.Database.executeBatch(new clsBatchDeleteApplication(appsToDelete, appsToRelation));
        } else {
            //System.debug(Trigger.new.size());
            Set<String> lotIds = new Set<String>();
            Set<String> periods = new Set<String>();
            Set<String> lotPeriodConcatenado = new Set<String>();

            //Get LotIds and PeriodIds of the new records (to insert o delete).
            for(Application__c app : Trigger.new){
                if( String.isNotBlank(app.LotID__c) && String.isNotBlank(app.Period__c) /*&& (app.Delete__c==null || !app.Delete__c.equalsIgnoreCase('Y'))*/ ){
                    lotIds.add(app.LotID__c);
                    periods.add(app.Period__c);
                    lotPeriodConcatenado.add(app.LotID__c + '-' + app.Period__c);
                }
            }

            String auxConcat;
            Map<String, String> ids = new Map<String, String>();

            //Check if LotIds and PeriodIds already exist in existing records, if so add then to the ids map.
            for(Application__c app : [select Id, LotID__c, Period__c 
                                        from Application__c 
                                        where LotID__c in: lotIds or Period__c in: periods]){
                auxConcat = app.LotID__c + '-' + app.Period__c;
                if(lotPeriodConcatenado.contains(auxConcat)) ids.put(auxConcat, app.Id);
                
            }

            List<Application__c> appsToUpdate = new List<Application__c>();

            for(Application__c app : Trigger.new){
                //Check which of the new records is on the ids map.
                if(String.isNotBlank(app.LotID__c) && String.isNotBlank(app.Period__c) && ids.keySet().contains(app.LotID__c + '-' + app.Period__c)){
                    /*app.addError('Account already exists in your Organization');*/
                    System.debug(ids.get(app.LotID__c + '-' + app.Period__c));
                    //Add the existing record to be updated with new data
                    appsToUpdate.add(new Application__c(Id=ids.get(app.LotID__c + '-' + app.Period__c),
                                                        Applications__c=app.Applications__c,
                                                        Approved__c=app.Approved__c,
                                                        Delivered__c=app.Delivered__C,
                                                        Funded__c=app.Funded__c,
                                                        Delete__c=app.Delete__c));
                    //Set the field "Delete"="Y" to the new record so that it can later be deleted with the batch.
                    app.Delete__c = 'Y';
                }else{

                }
            }

            if(appsToUpdate.size()>0)
                update appsToUpdate;
        }
    }
}