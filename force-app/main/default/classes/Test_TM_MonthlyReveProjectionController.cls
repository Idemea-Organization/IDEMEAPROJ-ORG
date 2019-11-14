@isTest
public class Test_TM_MonthlyReveProjectionController {
 @isTest
    public static void getResult() {
         TM_GovSuite__FedCap_Opportunity__c opp =new TM_GovSuite__FedCap_Opportunity__c();
        opp.Name ='test';
        insert opp;
        
        Revenue_Forecast__c revObj= new Revenue_Forecast__c();
        revObj.Growth_Opportunity__c=opp.Id;
        insert revObj;
        
         List<Revenue_Forecast__c> oppOffList = new List<Revenue_Forecast__c>();
        oppOffList.add(revObj);
         String str=   JSON.serialize(oppOffList);
        
         test.startTest();
        System.assertEquals('test', opp.Name);
        TM_MonthlyReveProjectionController.getReveProjection(opp.Id);
        TM_MonthlyReveProjectionController.saveReveu(str, opp.Id);
        TM_MonthlyReveProjectionController.deleteRevenue(revObj.Id,opp.Id);
        test.stopTest();
    }
}