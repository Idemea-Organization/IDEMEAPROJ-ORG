public class TM_MonthlyReveProjectionController {
    @AuraEnabled
    public static List<Revenue_Forecast__c> getReveProjection(String recId){
        
        return [SELECT Id ,Name,Actual_Revenue_Amount__c,Actual_Cost__c,Forecasted_Cost__c,Growth_Opportunity__c,Growth_Opportunity__r.Name,Month_Start_Date__c,POP_End_Date__c,POP_Start_Date__c FROM Revenue_Forecast__c  Where Growth_Opportunity__c =:recId ORDER BY Name ASC ];
    }
    
    @AuraEnabled
    public static void saveReveu(String prvenuProjList,String recId){
        
        List<Revenue_Forecast__c> revenList=(List<Revenue_Forecast__c>)System.JSON.deserialize(prvenuProjList,List<Revenue_Forecast__c>.class);
        
        List<Revenue_Forecast__c> finRevList= new  List<Revenue_Forecast__c>();
        try { 
            if(recId !=null && !revenList.isEmpty()){
                for(Revenue_Forecast__c b:revenList)
                {
                    Revenue_Forecast__c modObjObj=new Revenue_Forecast__c();
                    modObjObj.Id=b.Id;
                    // modObjObj.Growth_Opportunity__c=recId;
                    modObjObj.Actual_Revenue_Amount__c=b.Actual_Revenue_Amount__c;
                    modObjObj.Month_Start_Date__c=b.Month_Start_Date__c;
                    modObjObj.POP_End_Date__c = b.POP_End_Date__c;
                    modObjObj.POP_Start_Date__c = b.POP_Start_Date__c;
                    finRevList.add(modObjObj);
                }
            }
            System.debug('finRevList**'+finRevList); 
            update finRevList;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static void deleteRevenue(String recId,String revenId){
        System.debug('revenId**'+revenId);
        System.debug('recId**'+recId);
        List<Revenue_Forecast__c> oppRevnList =new List<Revenue_Forecast__c>();
        try { 
            if(recId !=null && revenId !=null){
                oppRevnList =[SELECT Id FROM Revenue_Forecast__c WHERE Id =:revenId AND Growth_Opportunity__c=:recId];
                System.debug('oppRevnList**'+oppRevnList);
            }
            delete oppRevnList;  
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}