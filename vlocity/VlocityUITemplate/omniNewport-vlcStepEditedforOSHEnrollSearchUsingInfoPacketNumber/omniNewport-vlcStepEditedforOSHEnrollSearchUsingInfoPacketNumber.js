vlocity.cardframework.registerModule.controller('enrollSearchNextControl', ['$scope', function($scope) {

//Current URL header
var url = 'https://'+  window.location.hostname +'/';

  $scope.currentLocation = function (){
    console.info("top url", url);
    if(url != null){
      $scope.bpTree.response.thisIsCommunity = false;
      if(url.includes("oshtraining")){
        $scope.bpTree.response.thisIsCommunity = true;
        var hrefUrl = top.location.href;
        if(hrefUrl.includes("Thisisdirect=true")){
          $scope.bpTree.response.Thisisdirect = true;
          console.info("Result this is direct and href :", $scope.bpTree.response.Thisisdirect,"href :", hrefUrl);
          $scope.bpTree.response.ContextId = getParameterByName('ContextId',hrefUrl);
          console.info("Context id :" ,$scope.bpTree.response.ContextId);
        }
      }
      $scope.bpTree.response.currentUrl = url;
    }else{
      $scope.bpTree.response.currentUrl = 'null';
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

  //Integration Procedure call
  $scope.nextBeforeLoadData = function(child) {
    $scope.bpTree.response.EditFamilyMember=[];
    $scope.loading = true;
    var request = {
      'packetNumber':'',
      'AgentLabel':'',
      'UserType':'',
      'ServicingAgent':''
    };
    var response;
    request.packetNumber = $scope.bpTree.response.Search.questionsBlock.packetNumber;
    request.AgentLabel = $scope.bpTree.response.AgentLabel;
    request.UserType = $scope.bpTree.response.UserType;
    request.ServicingAgent = $scope.bpTree.response.ServicingAgent;
    if($scope.bpTree.response.UserType=='OSH Employee'){
      request.ServicingAgent = $scope.bpTree.response.OSHServicingAgent;
    }
    $scope.bpService.GenericInvoke('%vlocity_namespace%.IntegrationProcedureService', 'Indivual/OSH_Search/EnrollMemberInfoPaktNumber', JSON.stringify(request),'{}').then(
        function(result) {
          response = JSON.parse(result).IPResult;
          if(response.DREX_INDIV_enrollgetPacketNumber.length != 0 && response.DREX_INDIV_enrollgetPacketNumber.infoPacket.packetFound == true){
            console.log(response);
            $scope.bpTree.response.isThereAInactiveProduct = false;
            $scope.bpTree.response.EditFamilyMember=[];
            $scope.bpTree.response.planSelection=null;
            $scope.bpTree.response.productConfigurationDetail=null;
            $scope.productPriceChange=false;
            sleep(100);
            $scope.bpTree.response.radioConditions24monthFunction= null;
            $scope.bpTree.response.radioMedicalServiceFunction=null;
            $scope.bpTree.response.radioHospitalizedFunction=null;
            $scope.bpTree.response.radioHaveorHadCancerFunction=null;
            $scope.bpTree.response.havePrescriptionMedicationsFunction=null;
            $scope.bpTree.response.radioPregnantFunction=null;
            $scope.bpTree.response.playExtremeSportsFunction=null;
            $scope.bpTree.response.radioConsumeAlcoholFunction=null;
            $scope.bpTree.response.radioConsumeTobaccoFunction=null;
            if($scope.mapIPResultToOSData(response)){
              sleep(100);
              $scope.nextRepeater(child.nextIndex, child.indexInParent); 
            }
          }else{
            var message = "We were not able to load the entered Information Packet information. Possible causes are: "
            +"<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;i.	Y​​​​​ou are not allowed to start an application using this Information Packet number."+
            "<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;ii.	The provided Information Packet number was not found."+
            "<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;iii.	You have entered a wrong Information Packet number." +
            "<br/>"+"&nbsp;&nbsp;&nbsp;&nbsp;iv.	You have entered Information Packet number that was already enrolled." +
            "<br/>"+"Please review and try again";
            alert(message);
            //alert("No result for "+ $scope.bpTree.response.Search.questionsBlock.packetNumber + " Information Packet");
          }
      $scope.loading = false;
      }
    );
  }

 $scope.mapIPResultToOSData = function(ipResult){
    var datesplited = ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.CreateDateQuote.split('/');
    var createdQuoteDate = new Date(datesplited[2], datesplited[0]-1, datesplited[1]);
    var diffDateDays = moment(new Date()).diff(createdQuoteDate, 'days', false);
    if(diffDateDays>30){
      alert("Quote expired, effective date for previous quote: " + createdQuoteDate + " please create a new one.");
      return false;
    }else{
      //Check if all programs are inactive
      var countFalse = 0; //Counter For false programs
      if(ipResult.DREX_INDIV_getProductAvailability.Products != undefined){
        ipResult.DREX_INDIV_getProductAvailability.Products.forEach( product => {
          console.log(product);
          if(product.IsActive==false){
            countFalse++;
          }
        });
        if(countFalse===ipResult.DREX_INDIV_getProductAvailability.Products.length){
          //All are false.
          alert("Unfortunately, none of the programs included in the Information Packet you selected are" +
          "currently available for Enrollment. Please create a new Information Packet to continue you " +
          "Enrollment process. Alternatively, click \“OK\” and select a different Information Packet.");

          return false;
        }
      }
      if(countFalse > 0){
        $scope.bpTree.response.isThereAInactiveProduct = true;
      }
      //Program Validity
      $scope.bpTree.response.productsAvailability = ipResult.DREX_INDIV_getProductAvailability.Products;
      //Store in Json
      $scope.bpTree.response.incomingQuoteId = ipResult.DREX_INDIV_enrollgetPacketNumber.incomingQuoteId;
      //Info Packet number
      $scope.bpTree.response.infoPacket = ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket;
      
     // if($scope.bpTree.response.UserType == "Producer"){
        var countAllowedPrograms = 0; //Counter For productPrivilegeSearch
        //If is a producer
        if(ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges != undefined){
          if(ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges != "[]"){
            //and he has products to offer then
            console.log('ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges', ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges);
            $scope.bpTree.response.productsAvailability.forEach( product => {
              //for each product in the quote verify that the producer is able to enroll
              ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges.forEach( productPrivilege => {
                //for each productPrivilege compare
                if(product.Id==productPrivilege.id){
                  if(productPrivilege.selectPrivilegie=="allowed"){
                    console.log('allowed', product);
                    //If found and producer allowed then...
                    countAllowedPrograms++;//increase counter
                  }else{
                    $scope.bpTree.response.isThereAInactiveProduct = true;
                  }                
                }
              });
            });
            console.log('countAllowedPrograms', countAllowedPrograms);
            if(countAllowedPrograms == 0){
              alert("Unfortunately, none of the programs included in the Information Packet you selected are available for this producer to offer.");
              return false;
            }else{
              $scope.bpTree.response.AccountProductPrivileges = ipResult.DREX_GetAccountProductPrivileges.AccountProductPrivileges;
            }
          }else{
            alert("Unfortunately, none of the programs are set for this producer account to offer.");
            return false;
          }
        }
        if($scope.bpTree.response.UserType == "Producer"){
        /* New logic added for producer hierarchy  STARTS*/
        if($scope.bpTree.response.AccountHierarchy != undefined){
          var agentLabelLevel = getLevel($scope.bpTree.response.AgentLabel);
          console.log('agentLabelLevel', agentLabelLevel);
          var quoteAgentLabelLevel = getLevel(ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.agentLabel);
          console.log('quoteAgentLabelLevel', quoteAgentLabelLevel);
          if(quoteAgentLabelLevel==0){
            alert("Producer not belonging to corresponding quote created producer tree, please contact a valid producer");
            return false;
          }
          if(agentLabelLevel < quoteAgentLabelLevel){
            alert("This producer cannot take superior producer quote created for enrolling");
            return false;
          }
          console.log('Agent label that is loged in: ', agentLabelLevel);
          console.log('Agent Label that created the quote: ', quoteAgentLabelLevel);          
        }else{
          alert("Account(producer) Hierarchy not found for this producer");
          return false;
        }
        /* New logic added for producer hierarchy  ENDS*/

      }

      //if logged in user is guest
      if($scope.bpTree.response.UserType == "Guest"){
        //if the user that created the quote is not a guest, throw error as guest users can only enroll self-service quotes.
        if(ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentProfile != $scope.bpTree.response.guestProfileName){
          alert("This quote was created via self-service and can only be enrolled via self-service");
          return false;
        }
      }

      //if logged in user is member
      if($scope.bpTree.response.UserType == "Member"){
        console.log('he is a member');
        console.log('ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentId', ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentId);
        console.log('$scope.bpTree.response.userId', $scope.bpTree.response.userId);
        console.log('ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentProfile', ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentProfile);
        console.log('$scope.bpTree.response.guestProfileName', $scope.bpTree.response.guestProfileName);
        console.log('1st', ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentId != $scope.bpTree.response.userId);
        console.log('2nd', ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentProfile != $scope.bpTree.response.guestProfileName);

        //If the writing agent id is not the member logged in
        if(ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentId != $scope.bpTree.response.userId){
          //compare if the quote was created via self-service
          if(ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentId != $scope.bpTree.response.guestUserId){
            alert("This quote was NOT created via self-service and can only be enrolled via Producer / OSH Employee");
            return false;
          }
        }
        //if the user that created the quote is not a guest, throw error as guest users can only enroll self-service quotes.
        // if(ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.writingAgentProfile != $scope.bpTree.response.guestProfileName){
          
        // }
      }

      //if logged in user is an osh employee
      if($scope.bpTree.response.UserType == "OSH Employee"){
        // if the user that created the quote was a producer, the osh employee cannot enroll it, osh employee can only enroll osh employee quotes and self-service quotes.
        if(!ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.agentLabelName.toUpperCase().includes("ASSOCIATE") 
            && $scope.bpTree.response.SelectedServicingAgentDropdown.Id != ipResult.DREX_INDIV_enrollgetPacketNumber.infoPacket.servicingAgent){
          alert("This quote was created by a producer and cannot be enrolled by an osh employee");
          return false;
        }
      }
      return true;      
    }
  }

  function getLevel(accountId){
    var level=1;
     for (level=1; level < $scope.bpTree.response.AccountHierarchy.length+1; level++) {
        if($scope.bpTree.response.AccountHierarchy[level-1].Id == accountId){
          console.log('found on the tree', level);
          break;
        }
    }
    if(level==$scope.bpTree.response.AccountHierarchy.length+1){
      level=0;
    }
    return level;
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