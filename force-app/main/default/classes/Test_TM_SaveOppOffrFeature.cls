@isTest
public class Test_TM_SaveOppOffrFeature {
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
        featuObj.Required_Level__c='Level 1';
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
        
     
        TM_SaveOppOffrFeature.featureWrapper wrepperObj= new TM_SaveOppOffrFeature.featureWrapper();
        wrepperObj.oppOffring=oppOffList;
        wrepperObj.featureList=featuList;
        wrepperObj.Offering=offObj;
    
        
        
        List<TM_SaveOppOffrFeature.featureWrapper> wrepperList =new List<TM_SaveOppOffrFeature.featureWrapper>();
        wrepperList.add(wrepperObj);
        String str=   JSON.serialize(wrepperList);
        
         test.startTest();
         System.assertEquals('test', featuObj.Name);
        TM_SaveOppOffrFeature.getoppOffering(opp.Id);
        TM_SaveOppOffrFeature.saveOfferingFeatures(str, opp.Id);
         test.stopTest();
    } 
}