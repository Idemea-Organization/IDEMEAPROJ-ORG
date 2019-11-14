@isTest
public with sharing class Test_TM_OppOferringController {
    @isTest
    public static void getResult() {
        
        
        TM_GovSuite__FedCap_Opportunity__c opp =new TM_GovSuite__FedCap_Opportunity__c();
        opp.Name ='test';
        insert opp;
        
        Offering__c offObj = new Offering__c();
        offObj.Name='test';
        insert offObj;
        
        Feature__c  featuObj=new Feature__c();
        featuObj.Name='test';
        featuObj.Offering__c=offObj.Id;
        insert featuObj;
        List<Feature__c> featuList=new List<Feature__c>();
        featuList.add(featuObj);
        
        
         List<Opportunity_Offering__c> oppOffList = new List<Opportunity_Offering__c>();
        Opportunity_Offering__c OppOffObj = new Opportunity_Offering__c();
        OppOffObj.Offering__c=offObj.Id;
        OppOffObj.Growth_Opportunity__c=opp.Id;
        //OppOffObj.Name='test';
        insert OppOffObj;
        oppOffList.add(OppOffObj);
         String str2=   JSON.serialize(oppOffList);
        
        
        
        TM_OppOferringController.OppOferringWrapper wrepperObj= new TM_OppOferringController.OppOferringWrapper();
        wrepperObj.oppOff=OppOffObj;
        wrepperObj.Offering=offObj;
        wrepperObj.feature=featuObj;
        wrepperObj.isChecked=true;
        wrepperObj.isCheckedOpOff=true;
        
        
        List<TM_OppOferringController.OppOferringWrapper> wrepperList =new List<TM_OppOferringController.OppOferringWrapper>();
        wrepperList.add(wrepperObj);
        String str=   JSON.serialize(wrepperList);
        
        
        
        TM_OppOferringController.featureWrapper wrepperObj1= new TM_OppOferringController.featureWrapper();
        wrepperObj1.Offering=offObj;
        wrepperObj1.featureList=featuList;
        List<TM_OppOferringController.featureWrapper> wrepperList1 =new List<TM_OppOferringController.featureWrapper>();
        wrepperList1.add(wrepperObj1);
        String str1=   JSON.serialize(wrepperList1);
        
        test.startTest();
        System.assertEquals('test', featuObj.Name);
        TM_OppOferringController.getoppOffering(opp.Id);
        TM_OppOferringController.getSelectdFeatures(str, opp.Id);
        TM_OppOferringController.saveOffering(str,opp.Id);
        TM_OppOferringController.getSelectdOffering(str,opp.Id);
       // TM_OppOferringController.getSelectdOfferingFeatures(str,opp.Id);
       TM_OppOferringController.saveOfferingFeatures(str1,opp.Id,str2);
        TM_OppOferringController.getSelectdFeatures(str, opp.Id);
         test.stopTest();
    }
}