trigger DeleteDealert on Account(after insert,after update) {

   
   System.Database.executeBatch(new clsBatchDeleteDealers(Trigger.new));


}