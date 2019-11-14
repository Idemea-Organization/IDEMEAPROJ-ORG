/*************************************************************************************** 
* Copyright (C) 2019   
* Technomile LLC    
* All Rights Reserved      
*
* Name          :    	TM_SaveOppOffrFeature
* TestClass Name:       Test_TM_SaveOppOffrFeature
* Trigger Name  :   	Name of trigger
* Purpose       :    	Save  the features related to offering in opportunity_Offering_feature junc obj. 
* History       :                                                                           
*************************************************************************************   
* Ver      Created Date            Employee Id                 Description 
*                                      
* 1.0      10/28/2019               181024                   Initial Creation      
**************************************************************************************/

public class TM_SaveOppOffrFeature {
    public class featureWrapper{
        @AuraEnabled
        public List<Opportunity_Offering__c> oppOffring {get;set;}
        @AuraEnabled
        public Offering__c Offering {get;set;}
        @AuraEnabled
        public List<Feature__c> featureList {get;set;}
        
        public featureWrapper() {
            oppOffring=new List<Opportunity_Offering__c>();
            featureList = new List<Feature__c>();
            Offering = new Offering__c();
        }
    }
    
    @AuraEnabled
    public static List<featureWrapper> getoppOffering(String recId){
        List<String> offIdList=new  List<String>();
        List<Opportunity_Offering__c> OppOffList=[SELECT Id ,Name,Offering__c FROM Opportunity_Offering__c  WHERE Growth_Opportunity__c=:recId] ;
        
        if (!OppOffList.isEmpty()) {
            for (Opportunity_Offering__c oppOffObj: OppOffList) {
                offIdList.add(oppOffObj.Offering__c);
            }
        }   
        
        List<Feature__c> offList;
        List<featureWrapper> oppWrapList = new List<featureWrapper>();
        if(!offIdList.isempty()){
            offList=[SELECT Id ,Name,Estimated_Delivery_Date__c,Feature_Description__c,Feature_Status__c,Offering__c,Offering__r.Name,Required_Level__c FROM Feature__c  Where Offering__c In:offIdList] ;
        }
        Offering__c  Offering ;
        if (!offList.isEmpty()) {
            for(Id IDobj:offIdList)
            {
                featureWrapper wrapObj2 = new featureWrapper();
                List<Feature__c> featureList = new List<Feature__c>();
                for (Feature__c oppOffObj: offList) {
                    if(oppOffObj.Offering__c==IDobj)
                    {
                        wrapObj2.Offering.Id=oppOffObj.Offering__c;
                        wrapObj2.Offering.Name=oppOffObj.Offering__r.Name;
                        featureList.add(oppOffObj);
                    } 
                }
                wrapObj2.featureList=featureList;
                oppWrapList.add(wrapObj2);
            }
        }  
        System.debug('oppWrapList33==>>'+oppWrapList);
        return oppWrapList;
    }
    
    @AuraEnabled
    public static void saveOfferingFeatures(String WrapperString,String recId){
        
        List<Opportunity_Offering__c> OppOffringList=[SELECT Id ,Name,Offering__c FROM Opportunity_Offering__c  WHERE Growth_Opportunity__c=:recId] ;
        
        List<featureWrapper> WraperPerList=(List<featureWrapper>)System.JSON.deserialize(WrapperString,List<featureWrapper>.class);
        System.debug('WraperPerList//** '+WraperPerList);
        System.debug('RecId: ' + recId);
        System.debug('OppOffringList//** '+OppOffringList);
        List<Opportunity_Offering_Feature__c> offList= new  List<Opportunity_Offering_Feature__c>();
        
        
        try { 
            if(recId !=null && !OppOffringList.isEmpty()){
                for(featureWrapper fw:WraperPerList)
                {
                    for(Feature__c f:fw.featureList)
                    {
                        for(Opportunity_Offering__c offr :OppOffringList ){
                            if(offr.Offering__c==f.Offering__c && f.Required_Level__c != null && f.Required_Level__c != '' && f.Required_Level__c != null  ){
                                Opportunity_Offering_Feature__c modObjObj=new Opportunity_Offering_Feature__c();
                                //modObjObj.Id=b.Offering.Id;
                                System.debug(recId);
                                modObjObj.Growth_Opportunity__c=recId;
                                modObjObj.Offering_Feature__c=f.Id;
                                modObjObj.Opportunity_Offering__c= offr.Id;
                                modObjObj.Required_Level__c = f.Required_Level__c;
                                //modObjObj.Feature_Status__c = f.Feature_Status__c;
                                modObjObj.Feature_Description__c = f.Feature_Description__c;
                                modObjObj.Estimated_Delivery_Date__c = f.Estimated_Delivery_Date__c;
                                
                                offList.add(modObjObj);  
                            }         
                        }}
                }
            }
            System.debug('offList33**'+offList);
            
            insert offList;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
    
    
    
    
}