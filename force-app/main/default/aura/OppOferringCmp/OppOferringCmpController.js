({
    doInit : function(component, event, helper) {
     
        var action=component.get("c.getoppOffering");
        action.setParams({ 
            "recId" :component.get("v.pageReference").state.c__offeringId
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                
                component.set("v.wrpOppOff",response.getReturnValue()); 
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
         setTimeout(function(){ 
            $('.CertIds').DataTable( {
                responsive: true
            } );
            
        }, 1500);
        
         
    },
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
    onCheck: function(component, event, helper) {
        var status=[];
      var nextBtn = component.find('nextBtnFunc');
          var AllRowsList = component.get("v.wrpOppOff"); 
        for(var i=0;i<AllRowsList.length;i++){
           /* if(AllRowsList[i].isChecked == true){
               $A.util.removeClass(nextBtn, 'slds-hide');
            $A.util.addClass(nextBtn, 'slds-show');
            } */
            if(AllRowsList[i].isChecked == true){
             status.push('1');
            }else{
                 status.push('0');
            } 
            if(status.includes('1')){
                  $A.util.removeClass(nextBtn, 'slds-hide');
            $A.util.addClass(nextBtn, 'slds-show');
               
            }else{
                $A.util.removeClass(nextBtn, 'slds-show');
            $A.util.addClass(nextBtn, 'slds-hide');
            }
           
        }
	 },
 
    onOffAction: function(component, event, helper) {
    
       
       /* var offChkBox = component.find('offDetailId');
        var offDetail = component.find('offDetailId1');           
        
        $A.util.removeClass(offDetail, 'slds-hide');
        $A.util.addClass(offDetail, 'slds-show');
        $A.util.addClass(offChkBox, 'slds-hide');*/
       
        //console.log(component.get("v.wrpOppOff"));
        var checkAllId = JSON.stringify(component.get("v.wrpOppOff"));
        // console.log('checkAllId******** ');
       // console.log(checkAllId);
        
        var action=component.get("c.getSelectdOffering");
        action.setParams({ 
            "WrapperString" : checkAllId,
            "recId" : component.get("v.pageReference").state.c__offeringId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
         
            if(state==="SUCCESS"){
                
                component.set("v.wrpOppOffDetails",response.getReturnValue()); 
                 component.set("v.screen",'secscreen');
                //  window.location.reload();
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    prevAction: function(component, event, helper) {
       /* var offChkBox = component.find('offDetailId');
        var offDetail = component.find('offDetailId1');           
        
        $A.util.removeClass(offDetail, 'slds-show');
        $A.util.addClass(offDetail, 'slds-hide');
        $A.util.removeClass(offChkBox, 'slds-hide');
        $A.util.addClass(offChkBox, 'slds-show');*/
         setTimeout(function(){ 
            $('.CertIds').DataTable( {
                responsive: true
            } );
            
        }, 1500);
          component.set("v.screen",'home');
          $A.enqueueAction(component.get('c.onCheck'));
         
         
    },
    prevFeatureActions: function(component, event, helper) {
        component.set("v.screen",'secscreen');
      /*   var offFeatureDetId = component.find('offFeatureDetailId');
        var offChkBox = component.find('offDetailId');
        var offDetail = component.find('offDetailId1');           
      
         $A.util.addClass(offFeatureDetId, 'slds-hide');
        $A.util.removeClass(offDetail,'slds-hide' );
        $A.util.addClass(offDetail, 'slds-show');*/
      
    },
    onOfffeatureNextAction: function(component, event, helper) {
        /* var offFeatureDetId = component.find('offFeatureDetailId');
        var offChkBox = component.find('offDetailId');
        var offDetail = component.find('offDetailId1');           
        
         $A.util.removeClass(offDetail, 'slds-show');
         $A.util.addClass(offDetail, 'slds-hide');  
         $A.util.removeClass(offFeatureDetId, 'slds-hide');
          $A.util.addClass(offFeatureDetId, 'slds-show');*/
        
       $A.enqueueAction(component.get('c.handleSave'));      
     var checkAllId = JSON.stringify(component.get("v.wrpOppOffDetails"));
         console.log('checkAllId******** ');
        console.log(checkAllId);
       
        var action=component.get("c.getSelectdFeatures");
        action.setParams({ 
            "WrapperString" : checkAllId,
            "recId" : component.get("v.pageReference").state.c__offeringId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(state==="SUCCESS"){
                   console.log("SUCCESS &&&& ");
           
                console.log(response.getReturnValue());
            
                component.set("v.wrpOppOfffeatureDetails",response.getReturnValue()); 
                  component.set("v.screen",'thirdscreen');
                //  window.location.reload();
            }
 
        });
        $A.enqueueAction(action);

    },
    
   
    removeRow: function(component, event, helper) {
        var index = event.target.id;
       alert(index)
        var AllRowsList = component.get("v.wrpOppOffDetails"); 
        for(var i=0;i<AllRowsList.length;i++){
            if(i == index){
                AllRowsList.splice(i, 1);
            } 
        }        
        console.log(AllRowsList);
       component.set("v.wrpOppOffDetails", AllRowsList);
    },
    
    removeRowFeature: function(component, event, helper) {
        var index = event.target.id;
         var textIndex = event.target.title;
     
        var AllRowsList = component.get("v.wrpOppOfffeatureDetails"); 
      
        for(var i=0;i<AllRowsList.length;i++){
            if(AllRowsList[i].Offering.Id == textIndex){
                AllRowsList[i].featureList.splice(index, 1);
            } 
        }        
        component.set("v.wrpOppOfffeatureDetails", AllRowsList);
    },
    
    addOffering : function(component, event){
        
        var book = component.get("v.wrpOppOffDetails");
        var len = book.length;
        book.push({
            'sobjectType':'Opportunity_Offering__c',
            'Name':'',
            'Quantity_Unit_Of_Measure__c':'',
            'Description__c':'',
            'Sales_Price__c':'',
             'Date__c':'',
             'Description__c':''
            
        }); 
        
        component.set("v.wrpOppOffDetails",book);
    },
    handleSave:function(component,event,helper)
    {
      
        var checkAllId = JSON.stringify(component.get("v.wrpOppOffDetails"));
        console.log(checkAllId);
      
        var action=component.get("c.saveOffering");
        action.setParams({ 
            "WrapperString" : checkAllId,
            "recId" : component.get("v.pageReference").state.c__offeringId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
          
            if(state==="SUCCESS"){
                
              /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been Save successfully."
                    
                });
                toastEvent.fire();*/
               /* var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.pageReference").state.c__offeringId
                 
                });
                navEvt.fire();*/
            }
            
        });
        $A.enqueueAction(action);
        
    },
     handleSaveFeature:function(component,event,helper)
    {
       
        var checkAllId = JSON.stringify(component.get("v.wrpOppOfffeatureDetails"));
        console.log(checkAllId);
      
        var action=component.get("c.saveOfferingFeatures");
        action.setParams({ 
            "WrapperString" : checkAllId,
            "recId" : component.get("v.pageReference").state.c__offeringId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
          
            if(state==="SUCCESS"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been Save successfully."
                    
                });
                toastEvent.fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.pageReference").state.c__offeringId
                 
                });
                navEvt.fire();
            }
            
        });
        $A.enqueueAction(action);
        
    },
})