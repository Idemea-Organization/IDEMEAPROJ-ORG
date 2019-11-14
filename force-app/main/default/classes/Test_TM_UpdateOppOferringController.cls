@isTest
public class Test_TM_UpdateOppOferringController {
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
        
        Opportunity_Offering_Feature__c  oppOffFeatureObj=new Opportunity_Offering_Feature__c();
        oppOffFeatureObj.Growth_Opportunity__c=opp.Id;
        oppOffFeatureObj.Offering_Feature__c = featuObj.Id;
        oppOffFeatureObj.Opportunity_Offering__c = OppOffObj.Id;
        insert oppOffFeatureObj;
        
        
        TM_UpdateOppOferringController.OppOferringWrapper wrepperObj1= new TM_UpdateOppOferringController.OppOferringWrapper();
        wrepperObj1.oppOff=OppOffObj;
        wrepperObj1.Offering=offObj;
        wrepperObj1.feature=featuObj;
        wrepperObj1.oppOffFeature=oppOffFeatureObj;
        wrepperObj1.isChecked=true;
        wrepperObj1.isCheckedOpOff =true; 
        List<TM_UpdateOppOferringController.OppOferringWrapper> wrepperLists =new List<TM_UpdateOppOferringController.OppOferringWrapper>();
        wrepperLists.add(wrepperObj1);
        String str1=   JSON.serialize(wrepperLists);
        
        test.startTest();
        System.assertEquals('test', featuObj.Name);
        TM_UpdateOppOferringController.getoppOffering(opp.Id);
        TM_UpdateOppOferringController.saveOffering(str1,opp.Id);
         TM_UpdateOppOferringController.saveOfferingFeatures(str1, opp.Id);
        TM_UpdateOppOferringController.deleteOffering(opp.Id, OppOffObj.Id);
        TM_UpdateOppOferringController.deleteOfferingFeature(opp.Id, OppOffObj.Id);
        TM_UpdateOppOferringController.getOppOferFeatures(opp.Id);
        test.stopTest();
        
    }
}