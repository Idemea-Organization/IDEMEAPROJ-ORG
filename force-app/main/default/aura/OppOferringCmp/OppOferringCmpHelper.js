({
	 validateRequired : function(component, event) {
      
       var isValid = true;
         /*
        var allfeatureRows = component.get("v.wrpOppOfffeatureDetails");
        
         for (var indexVar = 0; indexVar < allfeatureRows.length; indexVar++) {
              for (var indexVar1 = 0; indexVar1 < allfeatureRows[indexVar].featureList.length; indexVar1++) {
            
              if (allfeatureRows[indexVar].featureList[indexVar1].Required_Level__c == '' || allfeatureRows[indexVar].featureList[indexVar1].Required_Level__c == undefined || allfeatureRows[indexVar].featureList[indexVar1].Required_Level__c == null || allfeatureRows[indexVar].featureList[indexVar1].Required_Level__c == '--None--') {
                isValid = false;
                 
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": 'ERROR',
                      "type":'ERROR',
                      "message": 'Required Level Can\'t be Blank on Row Number ' + (indexVar1 + 1)
                  });
                  toastEvent.fire();
              //  alert('User Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
              }
         }
         */
           return isValid;
    },
    
})