public class TM_UpdateOppOferringController {
    public static List<OppOferringWrapper> oppWrapList {get;set;}
    @AuraEnabled
    public static List<OppOferringWrapper> getoppOffering(String recId){
        oppWrapList = new List<OppOferringWrapper>();
        List<Opportunity_Offering__c> offList=[SELECT Id ,Name,Offering__c,Offering__r.Name,Description__c,Growth_Opportunity__c,Price__c,Quantity__c,Total_Price__c FROM Opportunity_Offering__c  Where Growth_Opportunity__c =:recId ORDER BY Name ASC ] ;
        
        if (!offList.isEmpty()) {
            for (Opportunity_Offering__c oppOffObj: offList) {
                OppOferringWrapper wrapObj = new OppOferringWrapper();
                wrapObj.isChecked = false;
                wrapObj.oppOff = oppOffObj;
                oppWrapList.add(wrapObj); 
            }
        }          
        
        System.debug('oppWrapList==>>'+oppWrapList);
        return oppWrapList;
    }
    
    @AuraEnabled
    public static void saveOffering(String WrapperString,String recId){
        
        List<OppOferringWrapper> WraperPerList=(List<OppOferringWrapper>)System.JSON.deserialize(WrapperString,List<OppOferringWrapper>.class);
        
        List<Opportunity_Offering__c> offList= new  List<Opportunity_Offering__c>();
        try { 
            if(recId !=null && !WraperPerList.isEmpty()){
                for(OppOferringWrapper b:WraperPerList)
                {
                    Opportunity_Offering__c modObjObj=new Opportunity_Offering__c();
                    modObjObj.Id=b.oppOff.Id;
                    // modObjObj.Growth_Opportunity__c=recId;
                    modObjObj.Offering__c=b.oppOff.Offering__c;
                    modObjObj.Price__c=b.oppOff.Price__c;
                    modObjObj.Quantity__c = b.oppOff.Quantity__c;
                    modObjObj.Description__c = b.oppOff.Description__c;
                    modObjObj.Date__c = b.oppOff.Date__c;
                    offList.add(modObjObj);
                }
            }
            System.debug('offList**'+offList);
            
            
            upsert offList;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
        /* List<Feature__c> featureIdList =new List<Feature__c>();
List<String> OffIdIList =new List<String>();
List<Opportunity_Offering__c> Instance =new List<Opportunity_Offering__c>();

if(offList.size()>0 ){
Instance =[SELECT Id,Offering__c  FROM Opportunity_Offering__c WHERE Id NOT IN :offList and Growth_Opportunity__c=:recId];

}*/
        /* for(Opportunity_Offering__c OppoffObj:Instance){
OffIdIList.add(OppoffObj.Offering__c);
}
if(offList.size()>0 ){
featureIdList =[SELECT Id  FROM Feature__c WHERE Offering__c IN :OffIdIList ]; 
}
*/
        
        // System.debug('featureIdList**'+featureIdList);
        /* System.debug('Instance**'+Instance);
try { 
delete Instance;
// delete featureIdList;
} catch(DmlException e) {
System.debug('The following exception has occurred: ' + e.getMessage());
}    */   
    }
    
    @AuraEnabled
    public static void deleteOffering(String recId,String oppOffId){
        System.debug('oppOffId**'+oppOffId);
        System.debug('recId**'+recId);
        List<Opportunity_Offering__c> oppOffList =new List<Opportunity_Offering__c>();
        List<Opportunity_Offering_Feature__c> oppOffFetureList =new List<Opportunity_Offering_Feature__c>();
        
        try { 
            if(recId !=null && oppOffId !=null ){
                oppOffFetureList =[SELECT Id FROM Opportunity_Offering_Feature__c WHERE Opportunity_Offering__c =:oppOffId AND Growth_Opportunity__c=:recId];
                System.debug('oppOffFetureList**'+oppOffFetureList);
            }
            delete oppOffFetureList;  
            
            if(recId !=null && oppOffId !=null ){
                oppOffList =[SELECT Id FROM Opportunity_Offering__c WHERE Id =:oppOffId and Growth_Opportunity__c=:recId ];
                System.debug('oppOffList**'+oppOffList);
            }    
            delete oppOffList;
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    
    
    
    @AuraEnabled
    public static List<OppOferringWrapper> getOppOferFeatures(String recId){
        oppWrapList = new List<OppOferringWrapper>();
        List<Opportunity_Offering_Feature__c> offList=[SELECT Id,Offering_Feature__c,Required_Level__c,Feature_Status__c,Name,Estimated_Delivery_Date__c,Growth_Opportunity__c,Feature_Description__c FROM Opportunity_Offering_Feature__c  Where Growth_Opportunity__c =:recId ORDER BY Name ASC ] ;
        
        if (!offList.isEmpty()) {
            for (Opportunity_Offering_Feature__c oppOffObj: offList) {
                OppOferringWrapper wrapObj = new OppOferringWrapper();
                wrapObj.isChecked = false;
                wrapObj.oppOffFeature = oppOffObj;
                oppWrapList.add(wrapObj); 
            }
        }          
        
        System.debug('oppWrapList***==>>'+oppWrapList.size());
        return oppWrapList;
    }
    
    
    @AuraEnabled
    public static void deleteOfferingFeature(String recId,String oppOffId){
        System.debug('oppOffId**2'+oppOffId);
        List<Opportunity_Offering__c> oppOffList =new List<Opportunity_Offering__c>();
        List<Opportunity_Offering_Feature__c> oppOffFetureList =new List<Opportunity_Offering_Feature__c>();
        if(recId !=null && oppOffId !=null ){
            oppOffFetureList =[SELECT Id FROM Opportunity_Offering_Feature__c WHERE Id =:oppOffId and Growth_Opportunity__c=:recId ];
        }
        try { 
            if(oppOffFetureList.size()>0 ){
                System.debug('oppOffId**2'+oppOffFetureList);
                delete oppOffFetureList;
            }
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static void saveOfferingFeatures(String WrapperString,String recId){
        
        List<OppOferringWrapper> WraperPerList=(List<OppOferringWrapper>)System.JSON.deserialize(WrapperString,List<OppOferringWrapper>.class);
        List<Opportunity_Offering_Feature__c> offList= new  List<Opportunity_Offering_Feature__c>();
        try { 
            if(recId !=null){
                for(OppOferringWrapper f:WraperPerList)
                {
                    Opportunity_Offering_Feature__c modObjObj=new Opportunity_Offering_Feature__c();
                    modObjObj.Id=f.oppOffFeature.Id;
                    // modObjObj.Growth_Opportunity__c=recId;
                    modObjObj.Offering_Feature__c=f.oppOffFeature.Offering_Feature__c;
                    modObjObj.Required_Level__c = f.oppOffFeature.Required_Level__c;
                    modObjObj.Feature_Status__c = f.oppOffFeature.Feature_Status__c;
                    modObjObj.Feature_Description__c = f.oppOffFeature.Feature_Description__c;
                    modObjObj.Estimated_Delivery_Date__c = f.oppOffFeature.Estimated_Delivery_Date__c;
                    offList.add(modObjObj);
                }
            }
            System.debug('offList**'+offList);
            
            upsert offList;
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
}