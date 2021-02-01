({
    sendHelper: function(component, getEmail, getSubject, getbody, getFirstName, getLastName, getPhone) {
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        // set the 3 params to sendMailMethod method   
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mBody': getbody,
            'mFirstName': getFirstName,
            'mLastName': getLastName,
            'mPhone': getPhone
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                component.set("v.mailStatus", true);
                console.info('state', state);
                console.info('storeResponse', storeResponse);
            }else if (state === "ERROR"){
                console.info('state', state);
                console.info('response', response);
                console.info('response', response.getParams);
                console.info('response', response);
            }
        });
        $A.enqueueAction(action);
    },
})