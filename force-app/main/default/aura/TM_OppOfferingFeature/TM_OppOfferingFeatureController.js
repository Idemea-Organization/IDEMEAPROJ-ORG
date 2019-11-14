({
    doInit : function(component, event, helper) {
        var action=component.get("c.getoppOffering");
        action.setParams({ 
            "recId" :component.get("v.pageReference").state.c__offeringId
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                
                component.set("v.wrpOppOfffeatureDetails",response.getReturnValue()); 
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
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
    saveOppOffFeatu:function(component,event,helper)
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