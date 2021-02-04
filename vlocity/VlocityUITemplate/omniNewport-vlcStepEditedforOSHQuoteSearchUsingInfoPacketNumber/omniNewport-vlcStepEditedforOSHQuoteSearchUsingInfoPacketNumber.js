vlocity.cardframework.registerModule.controller('quoteController', ['$scope', function($scope) {

  //Current URL header
  var url = 'https://'+  window.location.hostname +'/';
  $scope.currentLocation = function (){
    if(url != null){
      $scope.bpTree.response.currentUrl = url;
      $scope.bpTree.response.thisIsCommunity = false;
      if(url.includes("oshtraining")){
        $scope.bpTree.response.thisIsCommunity = true;
        $scope.mapLetsGetStartedData();
        console.log('this is community');
        var visualforcepageurl='';
        if(window.top.location.pathname.includes('member')){
          visualforcepageurl = url.replace('vlocity-ins','c')+'membercommunity/';
        }else if(window.top.location.pathname.includes('producer')){
           visualforcepageurl = url.replace('vlocity-ins','c')+'producercommunity/';
        }
        console.log('visualforcepageurl', visualforcepageurl);
         $scope.bpTree.response.urlForVisualForcePages = visualforcepageurl;
      }else{
        $scope.bpTree.response.urlForVisualForcePages = url.replace('vlocity-ins','c');
      }      
    }else{
      $scope.bpTree.response.currentUrl = 'null';
    }
  }

  $scope.mapLetsGetStartedData = function(){
    console.log('urls START');
    var parentURL = document.referrer;
    console.log('document.referrer', parentURL);
    var fname = getParameterByName('fname', parentURL);
    var lname = getParameterByName('lname', parentURL);
    var compaddress = getParameterByName('compaddress', parentURL);
    var address = getParameterByName('address', parentURL);
    var city = getParameterByName('city', parentURL);
    var state = getParameterByName('state', parentURL);
    var zipcode = getParameterByName('zipcode', parentURL);
    var country = getParameterByName('country', parentURL);
    var buildingSuite = getParameterByName('buildingSuite', parentURL);
    var telephone = getParameterByName('telephone', parentURL);
    var email = getParameterByName('email',parentURL);
    var hearabout = getParameterByName('hearabout',parentURL);
    console.log('data', fname,lname,compaddress,address,city,state,zipcode,country,buildingSuite,telephone,email,hearabout);
    var customLetsGetStarted = {
                                                    BlkNoExistingInfoPacket: {
                                                        'TAAddressGoogle-Block':{ 
                                                                                  TAAddressGoogle: '',
                                                                                  City:''
                                                                                }
                                                                            }
                                                  };
    customLetsGetStarted.BlkNoExistingInfoPacket.fName=fname;
    customLetsGetStarted.BlkNoExistingInfoPacket.lName=lname;
    customLetsGetStarted.BlkNoExistingInfoPacket.Telephone1=telephone;
    customLetsGetStarted.BlkNoExistingInfoPacket.Email1=email;
    customLetsGetStarted.BlkNoExistingInfoPacket.SelectReferer=hearabout;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].TAAddressGoogle=compaddress;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].address=address;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].City=city;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].State=state;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].zipCode=zipcode;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].Country=country;
    customLetsGetStarted.BlkNoExistingInfoPacket['TAAddressGoogle-Block'].buildingSuiteApartment=buildingSuite;

    $scope.bpTree.response.letsGetStartedAnswers = customLetsGetStarted;
    $scope.bpTree.response.prefilledDataFromUrl=true;
    console.log('letsGetStarted', $scope.bpTree.response.letsGetStarted);
  }

  $scope.basicSearchForQuote = function(child){
     $scope.loading = true;
    //if($scope.bpTree.response.UserType == "Producer"){
      var request = {
        'infoPacketNumber':'',
        'AgentLabel':'',
        'UserType':'',
        'ServicingAgent':''
      };
      var response;
      request.AgentLabel = $scope.bpTree.response.AgentLabel;
      request.UserType = $scope.bpTree.response.UserType;
      request.ServicingAgent = $scope.bpTree.response.ServicingAgent;
      if($scope.bpTree.response.UserType=='OSH Employee'){
        request.ServicingAgent = $scope.bpTree.response.OSHServicingAgent;
      }
      console.info('UserType', $scope.bpTree.response.UserType);
      console.info('writingAgentGet', $scope.bpTree.response.writingAgentGet);
      $scope.bpService.GenericInvoke('%vlocity_namespace%.IntegrationProcedureService', 'Indivual/OSH_Get/QuoteDetails', JSON.stringify(request),'{}').then(
          function(result) {
            response = JSON.parse(result).IPResult;
            console.info('response from search of agent label', response);
            var countAllowedPrograms = 0; //Counter For productPrivilegeSearch
            //If is a producer
            if(response.DREX_GetAccountProductPrivileges.AccountProductPrivileges != undefined ){
              if(response.DREX_GetAccountProductPrivileges.AccountProductPrivileges != "[]"){
                //and he has products to offer then
                console.log('response.DREX_GetAccountProductPrivileges.AccountProductPrivileges', response.DREX_GetAccountProductPrivileges.AccountProductPrivileges);
                //for each products available for the producer verify
                response.DREX_GetAccountProductPrivileges.AccountProductPrivileges.forEach( productPrivilege => {
                //for each productPrivilege see if there are programs allowed
                if(productPrivilege.selectPrivilegie=="allowed"){
                  //If found and producer allowed then...
                  countAllowedPrograms++;//increase counter
                }
                });
                console.log('countAllowedPrograms', countAllowedPrograms);
                if(countAllowedPrograms == 0){
                  alert("Unfortunately, none of the programs are available for this producer to offer.");
                  return false;
                }else{
                  $scope.bpTree.response.AccountProductPrivileges = response.DREX_GetAccountProductPrivileges.AccountProductPrivileges;
                  sleep(100);
                  $scope.nextRepeater(child.nextIndex, child.indexInParent); 
                }
            }else{
              alert("Unfortunately, none of the programs are set for this producer account to offer.");
              return false;
            }
          }
        }
      );
    // }else{
    //   $scope.nextRepeater(child.nextIndex, child.indexInParent);
    // }
     $scope.loading = false;
}


  //Integration Procedure call
  $scope.searchInfoPacketNumber = function(child) {
    $scope.loading = true;
    var request = {
      'infoPacketNumber':'',
      'AgentLabel':'',
      'UserType':'',
      'ServicingAgent':''
    };
    var response;
    request.infoPacketNumber=$scope.bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtInfoPacketNumber;
    request.AgentLabel = $scope.bpTree.response.AgentLabel;
    request.UserType = $scope.bpTree.response.UserType;
    request.ServicingAgent = $scope.bpTree.response.ServicingAgent;
    if($scope.bpTree.response.UserType=='OSH Employee'){
      request.ServicingAgent = $scope.bpTree.response.OSHServicingAgent;
    }
    $scope.bpService.GenericInvoke('%vlocity_namespace%.IntegrationProcedureService', 'Indivual/OSH_Get/QuoteDetails', JSON.stringify(request),'{}').then(
        function(result) {
          response = JSON.parse(result).IPResult;
             console.info('response from search info packet', response);
          if(response.DRExGetLeadDetails.length != 0 && response.DRExGetPrimaryDetails.PrimaryFamilyMember != undefined && response.DRExGetLeadDetails.letsGetStarted != undefined && response.DRExGetLeadDetails.letsGetStarted.BlkNoExistingInfoPacket.fName != undefined){
            if($scope.mapIPResultToOSData(response)){
              sleep(500);
              $scope.nextRepeater(child.nextIndex, child.indexInParent); 
            }
          }else{
            //alert("No result for "+$scope.bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtInfoPacketNumber + " Information Packet");
            var message = "We were not able to load the entered Information Packet information. Possible causes are: "
            +"<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;i.	Y​​​​​ou are not allowed to start an application using this Information Packet number."+
            "<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;ii.	The provided Information Packet number was not found."+
            "<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;iii.	You have entered a wrong Information Packet number." +
            "<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;iv.	You have entered Information Packet number that was already enrolled." +
            "<br/>"+"Please review and try again";
            $scope.bpTree.response.ExistingInfoPacket.BlkExistingInfoPacket.TxtInfoPacketNumber=null;
            alert(message);
          }
      $scope.loading = false;
      }
    );
  }

  $scope.restartData = function(){
    console.log('restartData called');
    
     if($scope.bpTree.response.letsGetStartedAnswers!= undefined && $scope.bpTree.response.letsGetStartedAnswers.BlkNoExistingInfoPacket!= undefined && $scope.bpTree.response.letsGetStartedAnswers.BlkNoExistingInfoPacket.SSNITIN!=undefined){
      $scope.bpTree.response.letsGetStartedAnswers.BlkNoExistingInfoPacket.SSNITIN='';
     }
    //DRId_Lead
    $scope.bpTree.response.DRId_Lead='';
    //statement of beliefs
    $scope.bpTree.response.stateofBeliefsAnswers={};
    //radio family selection and primary language
    $scope.bpTree.response.FamilySelection='';
    $scope.bpTree.response.PrimaryLanguage='';
    $scope.bpTree.response.AccountProductPrivileges = [];
    //my family table
    var tempArray = [];
    var uniqueId = new Date().valueOf().toString();
    tempArray.push({
            'id': uniqueId,
            'parent_id': uniqueId,
            'fname': null,
            'lname': null,
            'dob': '',
            //'tobacco': "",
            'defaultNo': "false",
            'age': 0,
            'relationship': "Primary",
            'americanIndian':"",
            'eligiblemedicare':"",
            'address':"",
            'city':"",
            'state':"",
            'zipcode':"",
            'phone':"",
            'email':"",
            'gender': ""
        });
      $scope.bpTree.response.AddEditFamilyMember = angular.copy(tempArray);
    //tell us about you
    $scope.bpTree.response.tellUsAboutYouAnswers={};
  }

  $scope.mapIPResultToOSData = function(ipResult){
   
    var datesplited = ipResult.DRExGetLeadDetails.CreateDateQuote.split('/');
    var createdQuoteDate = new Date(datesplited[2], datesplited[0]-1, datesplited[1]);
    var diffDateDays = moment(new Date()).diff(createdQuoteDate, 'days', false);
   
    if(diffDateDays>30){
      alert("Quote expired, effective date for previous quote: " + createdQuoteDate + " please create a new one.");
      return false;
    }else{
      //lets get started
      $scope.bpTree.response.letsGetStartedAnswers=ipResult.DRExGetLeadDetails.letsGetStarted;
      $scope.bpTree.response.letsGetStartedAnswers.BlkNoExistingInfoPacket.SSNITIN=ipResult.DRExGetLeadDetails.letsGetStarted.BlkNoExistingInfoPacket.SSNITIN;
      //DRId_Lead
      //$scope.bpTree.response.DRId_Lead=ipResult.DRExGetLeadDetails.DRId_Lead;
      //statement of beliefs
      $scope.bpTree.response.stateofBeliefsAnswers=ipResult.DRExGetLeadDetails.stateofBeliefs;
      //radio family selection and primary language
      $scope.bpTree.response.FamilySelection=ipResult.DRExGetPrimaryDetails.radioFamilySelection;
      $scope.bpTree.response.PrimaryLanguage=ipResult.DRExGetLeadDetails.PrimaryLanguage;
      $scope.bpTree.response.EffectiveDate=ipResult.DRExGetLeadDetails.EffectiveDate;
      //Accounts ID Primary
      //$scope.bpTree.response.Account_1=ipResult.DRExGetLeadDetails.Account_1;
      //my family table
      $scope.bpTree.response.AddEditFamilyMember=[];
      ipResult.DRExGetPrimaryDetails.PrimaryFamilyMember.parent_id=ipResult.DRExGetPrimaryDetails.PrimaryFamilyMember.id;
      $scope.bpTree.response.AddEditFamilyMember.push(ipResult.DRExGetPrimaryDetails.PrimaryFamilyMember);
      if(ipResult.DRExGetPrimaryDetails.FamilyMember!=[] && ipResult.DRExGetPrimaryDetails.FamilyMember!=undefined){
        ipResult.DRExGetPrimaryDetails.FamilyMember.forEach(member =>{
          member.parent_id=ipResult.DRExGetPrimaryDetails.PrimaryFamilyMember.id;
        });
        ipResult.DRExGetPrimaryDetails.FamilyMember.forEach(member =>{
          $scope.bpTree.response.AddEditFamilyMember.push(member);
        });
      }    
      //tell us about you
      $scope.bpTree.response.tellUsAboutYouAnswers = ipResult.DRExGetPrimaryDetails.tellUsAboutYou.tellUsAboutYouFields;

      if($scope.bpTree.response.UserType == "Producer"){
        var countAllowedPrograms = 0; //Counter For productPrivilegeSearch
        //If is a producer
        if(ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges != undefined && ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges != "[]"){
          //and he has products to offer then
          console.log('ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges', ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges);
          //for each products available for the producer verify
          ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges.forEach( productPrivilege => {
            //for each productPrivilege see if there are programs allowed
            if(productPrivilege.selectPrivilegie=="allowed"){
              //If found and producer allowed then...
              countAllowedPrograms++;//increase counter
            }
          });
          console.log('countAllowedPrograms', countAllowedPrograms);
          if(countAllowedPrograms == 0){
            alert("Unfortunately, none of the programs are available for this producer to offer.");
            return false;
          }else{
            $scope.bpTree.response.AccountProductPrivileges = ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges;
          }
        }
      }
      return true;
    }
  }

  //Get Url parameters
  function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
  }

  function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
      if ((new Date().getTime() - start) > milliseconds){
        break;
      }
    }
  }

}]);