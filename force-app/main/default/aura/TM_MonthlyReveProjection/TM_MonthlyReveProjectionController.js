({
	 doInit : function(component, event, helper) {
     
        var action=component.get("c.getReveProjection");
        action.setParams({ 
            "recId" :component.get("v.pageReference").state.c__revenueId
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                
                component.set("v.prvenuProjList",response.getReturnValue()); 
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
         
    },
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
      removeRow: function(component, event, helper) {
        var index = event.target.id;
        var revenId = event.target.title;
        
        var AllRowsList = component.get("v.prvenuProjList"); 
        for(var i=0;i<AllRowsList.length;i++){
            if(i == index){
                AllRowsList.splice(i, 1);
            } 
        }        
        console.log(AllRowsList);
       component.set("v.prvenuProjList", AllRowsList);
        
          var action=component.get("c.deleteRevenue");
        action.setParams({ 
            "recId" : component.get("v.pageReference").state.c__revenueId,
            "revenId":revenId
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
     handleSave:function(component,event,helper){
       var checkAllId = JSON.stringify(component.get("v.prvenuProjList"));
         console.log('checkAllId******** ');
        console.log(checkAllId);
       
        var action=component.get("c.saveReveu");
        action.setParams({ 
            "prvenuProjList" : checkAllId,
            "recId" : component.get("v.pageReference").state.c__revenueId
        });
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(state==="SUCCESS"){
                   console.log("SUCCESS &&&& ");
           
                console.log(response.getReturnValue());
            
                //component.set("v.wrpOppOfffeatureDetails",response.getReturnValue()); 
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been Save successfully."
                    
                });
                toastEvent.fire();
                  window.parent.location = '/' + component.get("v.pageReference").state.c__revenueId;
            }
 
        });
        $A.enqueueAction(action);
      
    },
})