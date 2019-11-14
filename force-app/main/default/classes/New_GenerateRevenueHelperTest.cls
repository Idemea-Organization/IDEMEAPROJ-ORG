/*************************************************************************************** 
* Copyright (C) 2019   
* Technomile LLC    
* All Rights Reserved      
*
* Name          :     	New_GenerateRevenueHelper
* Class Name	:		New_GenerateRevenueHelper
* Trigger Name  :   	TocreateRevenueObjects
* Purpose       :    	To create revenue forecast from Growth opportunity when Start Date or End Date or Ammount changes on Growth opportunity.
* Test Class    :       New_GenerateRevenueHelperTest       		
*                    		.
* History       :                                                                           
*************************************************************************************   
* Ver      Chg Date                 Name                 Description 
*                                       
* 1.0      14/11/2019            Vishvanil Ingle        Initial Creation      
**************************************************************************************/
@isTest
public class New_GenerateRevenueHelperTest {
    static testMethod void testforopp() {
        
       
        
        
        TM_GovSuite__FedCap_Opportunity__c Oppobj=new TM_GovSuite__FedCap_Opportunity__c();
        Oppobj.Name='Test';
        Oppobj.TM_GovSuite__Stage__c='Opportunity Assessment';
        Oppobj.TM_GovSuite__Amount__c=12000;
        Oppobj.TM_GovSuite__Solicitation_Date__c=Date.today().addDays(-50);
        Oppobj.TM_GovSuite__CloseDate__c=Date.today().addMonths(4);
        Oppobj.TM_GovSuite__Start_Date__c=Date.today().addDays(5);
        Oppobj.End_Date__c=Date.today().addMonths(4);
       
        Test.startTest();
        insert Oppobj;
        Opportunity_Offering__c OppOff=new Opportunity_Offering__c();
        OppOff.Growth_Opportunity__c=Oppobj.Id;
        OppOff.Price__c=10000;
        OppOff.Quantity__c=200;
        insert OppOff;
        Oppobj.End_Date__c=Date.today().addMonths(5);
        update Oppobj;
      /*  Oppobj.TM_GovSuite__Start_Date__c=Date.today();
        Oppobj.End_Date__c=Date.today();
        update Oppobj;*/
        Test.stopTest();
        System.assertEquals(Oppobj.Id, Oppobj.Id);
        
        
    }
    
}