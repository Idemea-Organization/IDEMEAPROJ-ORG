({
	 doInit : function(component, event, helper) { 
       
     
        
          setTimeout(function(){ 
            $('#CertId').DataTable( {
                responsive: true
            } );
            
        }, 2000);
        
    },
     scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
})