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
public class New_GenerateRevenueHelper {
    
    @future 
    public static void calculateMonthlyRevenueByDailyValue(Set<Id> opportunityIdSet)
    {
        List<TM_GovSuite__FedCap_Opportunity__c> opportunityList = [SELECT Id, TM_GovSuite__Start_Date__c, End_Date__c, Amount__c FROM TM_GovSuite__FedCap_Opportunity__c
                                                                    WHERE id IN: opportunityIdSet];
        
        List<Revenue_Forecast__c> revenueForecastListToInsert = new List<Revenue_Forecast__c>();
        if(!opportunityList.isEmpty())
        {
            for(TM_GovSuite__FedCap_Opportunity__c opp : opportunityList)
            {
                Integer NumberOfDays;
                Decimal DailyValue;
                if(opp.TM_GovSuite__Start_Date__c != null && opp.End_Date__c != null)
                {
                    NumberOfDays = opp.TM_GovSuite__Start_Date__c.daysBetween(opp.End_Date__c);
                }
                
                if(opp.Amount__c != null)
                {
                    DailyValue = (NumberOfDays != null && NumberOfDays > 0 ? (opp.Amount__c/NumberOfDays) : (opp.Amount__c));
                    
                }
                List<Revenue_Forecast__c> calculatedRevenueListForOpportunity =new  List<Revenue_Forecast__c>();
                if(DailyValue != null && opp.TM_GovSuite__Start_Date__c != null && opp.End_Date__c != null && opp.Id != null &&  opp.Amount__c != null )
                {
                    calculatedRevenueListForOpportunity = calculateMonthlyAmount(DailyValue, opp.TM_GovSuite__Start_Date__c, opp.End_Date__c, opp.Id,   opp.Amount__c); 
                }
                if(calculatedRevenueListForOpportunity.size() > 0)
                {
                    revenueForecastListToInsert.addAll(calculatedRevenueListForOpportunity);
                }
            }
        }
        try{
            if(!revenueForecastListToInsert.isEmpty())
            {
                insert revenueForecastListToInsert;
            }
        }catch(DmlException e)
        {
            System.debug('DML Insert Exception'+e.getMessage()+e.getLineNumber());
        }
        
    }
    
    
    public static List<Revenue_Forecast__c>  calculateMonthlyAmount(Decimal DailyValue, Date startDate, Date endDate, Id splitId, Decimal OpportunityAmount)
    {
        List<Revenue_Forecast__c> calulatedMonthlyRevenues = new List<Revenue_Forecast__c>();
        
        if(startDate != null && endDate != null)
        {
            Integer monthsBetween= startDate.monthsBetween(endDate);
            for(integer i=0; i<=monthsBetween; i++)
            {
                Revenue_Forecast__c revenueObj = new Revenue_Forecast__c();
                revenueObj.Growth_Opportunity__c=splitId;
                if(monthsBetween == 0)
                {
                    System.debug('monthsBetween == 0');
                    revenueObj.POP_Start_Date__c=startDate;
                    revenueObj.POP_End_Date__c=endDate;
                    Date firstDate = startDate.toStartOfMonth();
                    revenueObj.Month_Start_Date__c=firstDate;
                    Integer totaldays;
                    if(startDate != null && endDate != null)
                    {
                        totaldays = startDate.daysBetween(endDate);
                    }
                    if(DailyValue != null)
                    {
                        revenueObj.Actual_Revenue_Amount__c = DailyValue * totaldays;
                    }
                }
                else if(i==0) //calculation for starting month
                {
                    
                    revenueObj.POP_Start_Date__c=startDate;
                    Date firstDate = startDate.toStartOfMonth();
                    revenueObj.Month_Start_Date__c=firstDate;
                    Date lastDate = firstDate.addDays(date.daysInMonth(startDate.year() , startDate.month())  - 1);
                    revenueObj.POP_End_Date__c=lastDate;
                    
                    Integer numberOfDays=startDate.daysBetween(lastDate);
                    
                    if(DailyValue != null && numberOfDays != null)
                    {
                        Decimal totalformonth= DailyValue * numberOfDays;
                        revenueObj.Actual_Revenue_Amount__c =totalformonth;
                        
                    }
                }
                else if(i == monthsBetween) //calculation for end month
                {
                    Date firstDate = startDate.toStartOfMonth();
                    revenueObj.POP_Start_Date__c=firstDate;
                    revenueObj.Month_Start_Date__c=firstDate;
                    revenueObj.POP_End_Date__c=endDate;
                    Date midMonth;
                    Integer numberOfDays;
                    numberOfDays=  firstDate.daysBetween( endDate);
                    if(DailyValue != null && numberOfDays != null)
                    {
                        revenueObj.Actual_Revenue_Amount__c = DailyValue * numberOfDays;  
                    }
                }
                else    //calculation for mid months
                {
                    
                    Date firstDate = startDate.toStartOfMonth();
                    revenueObj.POP_Start_Date__c=firstDate;
                    revenueObj.Month_Start_Date__c=firstDate;
                    Date lastDate = firstDate.addDays(date.daysInMonth(startDate.year() , startDate.month())  - 1);
                    revenueObj.POP_End_Date__c=lastDate;
                    Date midMonth;
                    Integer numberOfDays;
                    numberOfDays= firstDate.daysBetween(lastDate);
                    if(DailyValue != null && numberOfDays != null)
                    {
                        revenueObj.Actual_Revenue_Amount__c = DailyValue * numberOfDays;  
                    }
                }
                calulatedMonthlyRevenues.add(revenueObj);
                startDate=startDate.addMonths(1);
            }
        }
        return calulatedMonthlyRevenues;
    }
    
    
    
    public static void deleteRevenueProjectionOnSplitChange(Set<Id> opportunityIdSet)
    {
        List<Revenue_Forecast__c> monthlyRevenueListToDelete = new List<Revenue_Forecast__c>();
        monthlyRevenueListToDelete = [SELECT id FROM Revenue_Forecast__c WHERE Growth_Opportunity__c IN: opportunityIdSet];
        try{
            if(monthlyRevenueListToDelete != null && monthlyRevenueListToDelete.size() > 0)
            {
                delete monthlyRevenueListToDelete;
            }   
        }catch(DmlException e)
        {
            System.debug('DML delete exception'+e.getLineNumber()+e.getMessage());
        }
        
    }
    
}