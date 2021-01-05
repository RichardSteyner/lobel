@isTest
public class GeneralTestClass {

    static {
        Application__c app = new Application__c();
        app.LotID__c = '001';
        app.Period__c = '202012';
        insert app;
        app = new Application__c();
        app.Period__c = '202012';
        app.LotID__c = '004';
        insert app;

        Bank_Stats__c bk = new Bank_Stats__c();
        bk.LotID__c = '001';
        bk.Period__c = '202012';
        insert bk;
        bk = new Bank_Stats__c();
        bk.LotID__c = '002';
        bk.Period__c = '202012';
        insert bk;
    }
    
	@isTest
    static void DeleteApplicationsTest(){
       	List<Application__c> lstApp = new List<Application__c>();
        Application__c app = new Application__c();
        app.LotID__c = '001';
        app.Period__c = '202012';
       	lstApp.add(app);
        app = new Application__c();
        app.LotID__c = '002';
        app.Period__c = '202012';
        lstApp.add(app);
        app = new Application__c();
        app.Period__c = '202012';
        app.LotID__c = '003';
        lstApp.add(app);
        app = new Application__c();
        app.LotID__c = '004';
        app.Period__c = '202012';
        app.Delete__c = 'y';
        lstApp.add(app);

        System.debug([select Id, LotID__c, Period__c, Delete__c from Application__c].size());
        Test.startTest();
        insert lstApp;
        System.debug([select Id, LotID__c, Period__c, Delete__c from Application__c].size());
        Test.stopTest();
        System.debug([select Id, LotID__c, Period__c, Delete__c from Application__c].size());
    }
    
    @isTest
    static void DeleteBankTest(){
        List<Bank_Stats__c> lstbk = new List<Bank_Stats__c>();
        Bank_Stats__c bk = new Bank_Stats__c();
        bk.LotID__c = '001';
        bk.Period__c = '202012';
       	lstbk.add(bk);
        bk = new Bank_Stats__c();
        bk.LotID__c = '002';
        bk.Period__c = '202012';
        bk.Delete__c = 'y';
        lstbk.add(bk);
        
        System.debug([select Id from Bank_Stats__c].size());
        Test.startTest();
        insert lstbk;
        System.debug([select Id from Bank_Stats__c].size());
        Test.stopTest();
        System.debug([select Id from Bank_Stats__c].size());
    }
    
    @isTest
    static void DeleteDealertTest(){
        List<Account> lstAcc = new List<Account>();
        Account acc = new Account();
        acc.LotID__c = '001';
        acc.Name = 'TestCloud1';
       	lstAcc.add(acc);
        acc = new Account();
        acc.LotID__c = '002';
        acc.Name = 'TestCloud2';
        acc.Delete__c = 'y';
        lstAcc.add(acc);
        
        Test.startTest();
        insert lstAcc;
        Test.stopTest();
    }
    
    @isTest
    static void clsBatchRelationApplicationsTest(){
        List<Application__c> lstApp = new List<Application__c>();
        Application__c app = new Application__c();
        app.LotID__c = '001';
       	lstApp.add(app);
        app = new Application__c();
        app.LotID__c = '002';
        lstApp.add(app);
        app = new Application__c();
        app.LotID__c = '003';
        lstApp.add(app);
        app = new Application__c();
        app.LotID__c = '004';
        app.Delete__c = 'y';
        lstApp.add(app);
        insert lstApp;
        
        Account acc = new Account();
        acc.LotID__c = '001';
        acc.Name = 'TestCloud1';
        insert acc;
        
        Test.startTest();
        Database.executeBatch(new clsBatchRelationApplications(lstApp),100);
        Test.stopTest();
    }
    
    @isTest
    static void clsBatchRelationBankTest(){
       	List<Bank_Stats__c> lstBk = new List<Bank_Stats__c>();
        Bank_Stats__c bk = new Bank_Stats__c();
        bk.LotID__c = '001';
        lstBk.add(bk);
        bk = new Bank_Stats__c();
        bk.LotID__c = '002';
        lstBk.add(bk);
       	insert lstBk;
        
        Account acc = new Account();
        acc.LotID__c = '001';
        acc.Name = 'TestCloud1';
        insert acc;
        
        Test.startTest();
        Database.executeBatch(new clsBatchRelationBank(lstBk),100);
        Test.stopTest();
    }
}