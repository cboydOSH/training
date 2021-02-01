({
    // when user click on Send button 
    sendMail: function(component, event, helper) {	
        var getEmail = component.get("v.email");
        var getSubject = component.get("v.subject");
        var getbody = component.get("v.body");
        var getFirstName = component.get("v.firstname");
        var getLastName = component.get("v.lastname");
        var getPhone = component.get("v.phone");
        //Email basic validation (still no need this because of UI validation)
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {
            helper.sendHelper(component, getEmail, getSubject, getbody, getFirstName, getLastName, getPhone);
        }
    },
    //click on the close buttton on message popup hide message and clean values 
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.email", null);
        component.set("v.subject", null);
        component.set("v.body", null);
        component.set("v.firstname", null);
        component.set("v.lastname", null);
        component.set("v.phone", null);
    },
})