/*************************************************************************************** 
* Copyright (C) 2019   
* Technomile LLC    
* All Rights Reserved      
*
* Name          :     	New_GenerateRevenueHelper
* Class Name	:		New_GenerateRevenueHelper
* Trigger Name  :   	TocreateRevenueObjects
* Purpose       :    	To create revenue forecast from Growth opportunity when Start Date or End Date or Ammount changes on Growth opportunity.
*                    		
*                    		.
* History       :                                                                           
*************************************************************************************   
* Ver      Chg Date                 Name                 Description 
*                                       
* 1.0      13/11/2019            Vishvanil Ingle        Initial Creation      
**************************************************************************************/
trigger TocreateRevenueObjects on TM_GovSuite__FedCap_Opportunity__c (before insert, after update) {
    if(Trigger.isBefore)
    {
        Set<Id> OppIdSet=new    Set<Id>();
        if(Trigger.isInsert)
        {
            for(TM_GovSuite__FedCap_Opportunity__c opp : Trigger.New)
            {
                if(opp.TM_GovSuite__Start_Date__c != null && opp.End_Date__c != null && opp.Amount__c != null)
                { 
                    OppIdSet.add(opp.Id);
                }
            }
            if(OppIdSet!=null && OppIdSet.size()>0)
            {
               // New_GenerateRevenueHelper.deleteRevenueProjectionOnSplitChange(OppIdSet);
                New_GenerateRevenueHelper.calculateMonthlyRevenueByDailyValue(OppIdSet);
            }
        }
    }
    if(Trigger.isAfter)
    {
      Set<Id> OppIdSet=new    Set<Id>();
        if(Trigger.isUpdate)
        {
            for(TM_GovSuite__FedCap_Opportunity__c opp : Trigger.New)
            {
                TM_GovSuite__FedCap_Opportunity__c oldOpp = Trigger.oldMap.get(opp.Id);
                if(opp.TM_GovSuite__Start_Date__c != oldOpp.TM_GovSuite__Start_Date__c  || opp.End_Date__c != oldOpp.End_Date__c || opp.Amount__c != oldOpp.Amount__c)
                { 
                    if(opp.TM_GovSuite__Start_Date__c != null && opp.End_Date__c != null && opp.Amount__c != null)
                    { 
                         OppIdSet.add(opp.Id);
                    }
                   
                }
            }
            if(OppIdSet!=null && OppIdSet.size()>0)
            {
                New_GenerateRevenueHelper.deleteRevenueProjectionOnSplitChange(OppIdSet);
                New_GenerateRevenueHelper.calculateMonthlyRevenueByDailyValue(OppIdSet);
            }
        }
    }
    
}