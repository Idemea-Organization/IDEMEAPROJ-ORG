/*************************************************************************************** 
* Copyright (C) 2019   
* Technomile LLC    
* All Rights Reserved      
*
* Name          :    	TM_OppOferringController
* TestClass Name:       Test_TM_OppOferringController
* Trigger Name  :   	Name of trigger
* Purpose       :    	Save & update the features related to offering in opportunity_Offering junc obj. 
* History       :                                                                           
*************************************************************************************   
* Ver      Created Date            Employee Id                 Description 
*                                      
* 1.0      10/28/2019               181024                   Initial Creation      
**************************************************************************************/
public class TM_OppOferringController {
    @AuraEnabled
    public static List<OppOferringWrapper> oppWrapList {get;set;}
    
    
    @AuraEnabled
    public static List<OppOferringWrapper> getoppOffering(String recId){
        oppWrapList = new List<OppOferringWrapper>();
        List<Offering__c> offList=[SELECT Id ,Name,Product_Code__c,Description__c,Offering_Family__c,Quantity_Unit_Of_Measure__c FROM Offering__c ] ;
        
        if (!offList.isEmpty()) {
            for (Offering__c oppOffObj: offList) {
                OppOferringWrapper wrapObj = new OppOferringWrapper();
                wrapObj.isChecked = false;
                wrapObj.Offering = oppOffObj;
                oppWrapList.add(wrapObj); 
            }
        }          
        //  allDetailsMap.put('disciplinesList',disciplinWrapp);
        System.debug('oppWrapList==>>'+oppWrapList);
        return oppWrapList;
    }
    
    
    @AuraEnabled
    public static  List<OppOferringWrapper> getSelectdOffering(String WrapperString,String recId){
        
        List<OppOferringWrapper> WraperPerList=(List<OppOferringWrapper>)System.JSON.deserialize(WrapperString,List<OppOferringWrapper>.class);
        System.debug('WraperPerList2==>>'+WraperPerList);
        List<Id> IdList= new  List<Id>();
        
        if(recId !=null){
            for(OppOferringWrapper b:WraperPerList)
            {
                
                if(b.isChecked == true){
                    System.debug('b.isChecked '+b.isChecked);
                    IdList.add(b.Offering.Id);
                }
                
            }
        }
        List<Offering__c> offList;
        List<OppOferringWrapper> oppWrapList = new List<OppOferringWrapper>();
        if(!IdList.isempty()){
            offList=[SELECT Id ,Name,Product_Code__c,Offering_Family__c FROM Offering__c  Where Id In:IdList] ;
        }
        
        if (!offList.isEmpty()) {
            for (Offering__c oppOffObj: offList) {
                OppOferringWrapper wrapObj = new OppOferringWrapper();
                wrapObj.isChecked = false;
                wrapObj.Offering = oppOffObj;
                oppWrapList.add(wrapObj); 
            }
        }          
        System.debug('oppWrapList==>>'+oppWrapList);
        return oppWrapList;
    }
    
    @AuraEnabled
    public static  List<Opportunity_Offering__c> saveOffering(String WrapperString,String recId){ 
        List<OppOferringWrapper> WraperPerList=(List<OppOferringWrapper>)System.JSON.deserialize(WrapperString,List<OppOferringWrapper>.class);
        List<Opportunity_Offering__c> offList= new  List<Opportunity_Offering__c>();
        try { 
            if(recId !=null){
                for(OppOferringWrapper b:WraperPerList)
                {
                    Opportunity_Offering__c modObjObj=new Opportunity_Offering__c();
                    //modObjObj.Id=b.Offering.Id;
                    modObjObj.Growth_Opportunity__c=recId;
                    modObjObj.Offering__c=b.Offering.Id;
                    modObjObj.Price__c=b.Offering.Sales_Price__c;
                    modObjObj.Quantity__c = b.Offering.Quantity__c;
                    modObjObj.Description__c = b.Offering.Description__c;
                    modObjObj.Date__c = b.Offering.Date__c;
                    offList.add(modObjObj);
                }
            }
            System.debug('offList**'+offList);
            
            
            insert offList;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return offList;
        /*  List<Opportunity_Offering__c> Instance =new List<Opportunity_Offering__c>();
if(offList.size()>0 ){
Instance =[SELECT Id  FROM Opportunity_Offering__c WHERE Id NOT IN :offList and Growth_Opportunity__c=:recId];
}
System.debug('Instance**'+Instance);
delete Instance;*/
    }
    
    
    /*   @AuraEnabled
public static  List<OppOferringWrapper> getSelectdOfferingFeatures(String WrapperString,String recId){

List<OppOferringWrapper> WraperPerList=(List<OppOferringWrapper>)System.JSON.deserialize(WrapperString,List<OppOferringWrapper>.class);
System.debug('WraperPerList23==>>'+WraperPerList);
List<Id> IdList= new  List<Id>();

if(recId !=null){
for(OppOferringWrapper b:WraperPerList)
{

if(b.isCheckedOpOff == true){
System.debug('b.isChecked333 '+b.isCheckedOpOff);
IdList.add(b.Offering.Id);
System.debug('IdList333 '+IdList);
}

}
}
List<Feature__c> offList;
List<OppOferringWrapper> oppWrapList = new List<OppOferringWrapper>();
if(!IdList.isempty()){
offList=[SELECT Id ,Name,Estimated_Delivery_Date__c,Feature_Description__c,Feature_Status__c,Offering__c,Offering__r.Name,Required_Level__c FROM Feature__c  Where Offering__c In:IdList] ;
}

if (!offList.isEmpty()) {
for (Feature__c oppOffObj: offList) {
OppOferringWrapper wrapObj = new OppOferringWrapper();
wrapObj.isCheckedOpOff = false;
wrapObj.feature = oppOffObj;
oppWrapList.add(wrapObj); 
}
}          
System.debug('oppWrapList33==>>'+oppWrapList);
return oppWrapList;
}
*/
    
    @AuraEnabled
    public static void saveOfferingFeatures(String WrapperString,String recId,String oppOferingLst){
        List<Opportunity_Offering__c> oppOffList=(List<Opportunity_Offering__c>)System.JSON.deserialize(oppOferingLst,List<Opportunity_Offering__c>.class);
        List<featureWrapper> WraperPerList=(List<featureWrapper>)System.JSON.deserialize(WrapperString,List<featureWrapper>.class);
        System.debug('WraperPerList//** '+WraperPerList);
        System.debug('RecId: ' + recId);
        System.debug('oppOffList//** '+oppOffList);
        List<Opportunity_Offering_Feature__c> offList= new  List<Opportunity_Offering_Feature__c>();
        Map<String,String>  offSobjectMap = new Map<String,String>();
        
        
        
        try { 
            if(recId !=null){
                for(featureWrapper fw:WraperPerList)
                {
                    for(Feature__c f:fw.featureList)
                    {
                        for(Opportunity_Offering__c offr :oppOffList ){
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
    
    
    
    
    
    
    public class OppOferringWrapper{
        @AuraEnabled
        public Opportunity_Offering__c oppOff {get;set;}
        @AuraEnabled
        public Offering__c Offering {get;set;}
        @AuraEnabled
        public Feature__c feature {get;set;}
        @AuraEnabled
        public Opportunity_Offering_Feature__c oppOffFeature {get;set;}
        @AuraEnabled
        public Boolean  isChecked;
        @AuraEnabled
        public Boolean  isCheckedOpOff;
        public OppOferringWrapper() {
            
            feature = new Feature__c();
            Offering = new Offering__c();
            oppOff = new Opportunity_Offering__c();
            oppOffFeature = new Opportunity_Offering_Feature__c();
            isChecked=false; 
            isCheckedOpOff =false;
        }
    }
    
    
    
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
    public static  List<featureWrapper> getSelectdFeatures(String WrapperString,String recId){
        
        List<OppOferringWrapper> WraperPerList=(List<OppOferringWrapper>)System.JSON.deserialize(WrapperString,List<OppOferringWrapper>.class);
        System.debug('WraperPerList23==>>'+WraperPerList);
        List<Id> IdList= new  List<Id>();
        
        if(recId !=null){
            for(OppOferringWrapper b:WraperPerList)
            { 
                IdList.add(b.Offering.Id);
                System.debug('IdList333 '+IdList);
            }
        }
        List<Feature__c> offList;
        List<featureWrapper> oppWrapList = new List<featureWrapper>();
        if(!IdList.isempty()){
            offList=[SELECT Id ,Name,Estimated_Delivery_Date__c,Feature_Description__c,Feature_Status__c,Offering__c,Offering__r.Name,Required_Level__c FROM Feature__c  Where Offering__c In:IdList] ;
        }
        Offering__c  Offering ;
        if (!offList.isEmpty()) {
            for(Id IDobj:IdList)
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
    
}