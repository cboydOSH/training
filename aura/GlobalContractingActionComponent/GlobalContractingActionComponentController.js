({
    navigateToeDiscoverySearchCmp : function(component, event, helper) {
       console.log('component',component);
       console.log('event',event);
       console.log('helper',helper);
       var evt = $A.get("e.force:navigateToComponent");
       evt.setParams({
           componentDef : "c:eDiscoverySearchCmp",
       });
       evt.fire();
   },
    doInit: function(cmp) {
       

   var urlEvent = $A.get("e.force:navigateToURL");
  // urlEvent.setParams({
  //   "url": "/apex/vlocity_ins__OmniScriptUniversalPage?id={0}&layout=newport#/OmniScriptType/MSA Sales/OmniScriptSubType/Qualifying Questions/OmniScriptLang/English/ContextId/null/PrefillDataRaptorBundle//true"
  // });
  
  urlEvent.setParams({
     "url": "/apex/vlocity_ins__OmniScriptUniversalPage?id={0}&layout=newport#/OmniScriptType/Contracting/OmniScriptSubType/Lead/OmniScriptLang/English/ContextId/{0}/PrefillDataRaptorBundle//true"
  });

   urlEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
   }
})