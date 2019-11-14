({
    doInit : function(component, event, helper) {
     
        var action=component.get("c.getoppOffering");
        action.setParams({ 
            "recId" :component.get("v.pageReference").state.c__offeringId
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                
                component.set("v.wrpOppOffDetails",response.getReturnValue()); 
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
         
    },
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
    onCheck: function(component, event, helper) {
        var status=[];
      var nextBtn = component.find('nextBtnFunc');
          var AllRowsList = component.get("v.wrpOppOffDetails"); 
        for(var i=0;i<AllRowsList.length;i++){
          
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
         $A.enqueueAction(component.get('c.handleSave'));
         component.set("v.screen",'secondscreen'); 
        var action=component.get("c.getOppOferFeatures");
        action.setParams({ 
            "recId" : component.get("v.pageReference").state.c__offeringId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(state==="SUCCESS"){
                   console.log("SUCCESS &&&& ");
           
                console.log(response.getReturnValue());
            
                component.set("v.wrpOppOfffeatureDetails",response.getReturnValue()); 
               
            }
 
        });
        $A.enqueueAction(action); 
    },
    
    prevAction: function(component, event, helper) {
          component.set("v.screen",'home');
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
  
   
    removeRow: function(component, event, helper) {
        var index = event.target.id;
        var oppOffId = event.target.title;
        
        var AllRowsList = component.get("v.wrpOppOffDetails"); 
        for(var i=0;i<AllRowsList.length;i++){
            if(i == index){
                AllRowsList.splice(i, 1);
            } 
        }        
        console.log(AllRowsList);
       component.set("v.wrpOppOffDetails", AllRowsList);
        
          var action=component.get("c.deleteOffering");
        action.setParams({ 
            "recId" : component.get("v.pageReference").state.c__offeringId,
            "oppOffId":oppOffId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(state==="SUCCESS"){
                   console.log("SUCCESS &&&& ");
           
                console.log(response.getReturnValue());
            
            }
        });
        $A.enqueueAction(action);
        
    },
    
    removeRowFeature: function(component, event, helper) {
        var index = event.target.id;
          var oppOffId = event.target.title;
    
        var AllRowsList = component.get("v.wrpOppOfffeatureDetails"); 
      
        for(var i=0;i<AllRowsList.length;i++){
            if(i == index){
                AllRowsList.splice(i, 1);
            } 
        }         
        component.set("v.wrpOppOfffeatureDetails", AllRowsList);
        
         var action=component.get("c.deleteOfferingFeature");
        action.setParams({ 
            "recId" : component.get("v.pageReference").state.c__offeringId,
            "oppOffId":oppOffId
            
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(state==="SUCCESS"){
                 
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
  
    handleSave:function(component,event,helper)
    {
       var checkAllId = JSON.stringify(component.get("v.wrpOppOffDetails"));
         console.log('checkAllId******** ');
        console.log(checkAllId);
       
        var action=component.get("c.saveOffering");
        action.setParams({ 
            "WrapperString" : checkAllId,
            "recId" : component.get("v.pageReference").state.c__offeringId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(state==="SUCCESS"){
                   console.log("SUCCESS &&&& ");
           
                console.log(response.getReturnValue());
            
                //component.set("v.wrpOppOfffeatureDetails",response.getReturnValue()); 
             /*  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been Save successfully."
                    
                });
                toastEvent.fire();*/
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
          
             window.parent.location = '/' + component.get("v.pageReference").state.c__offeringId;
            
            }
            
        });
        $A.enqueueAction(action);
     
    },
})